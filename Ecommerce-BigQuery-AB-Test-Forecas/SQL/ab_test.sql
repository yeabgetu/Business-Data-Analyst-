-- =====================================================================
-- 04_ab_test.sql
-- A/B comparison: mobile vs desktop checkout (cart-to-purchase conversion).
-- Population: sessions with added_to_cart = 1.
-- H0: mobile rate = desktop rate; H1: they differ. alpha = 0.05, power = 80%.
-- Note: device is not randomly assigned, so this is an observational comparison.
-- =====================================================================


-- 7a. Sample size needed per group to detect a 10% relative drop from desktop
-- Result: ~2,600 per group needed; actual 4,136 mobile / 4,356 desktop
WITH base AS (
  SELECT SAFE_DIVIDE(COUNTIF(purchased = 1), COUNT(*)) AS p1
  FROM `ecommerce.websession`
  WHERE added_to_cart = 1 AND LOWER(device) = 'desktop'
),
params AS (SELECT p1, p1 * (1 - 0.10) AS p2 FROM base)
SELECT
  ROUND(p1, 4) AS desktop_baseline,
  ROUND(p2, 4) AS mobile_rate_to_detect,
  CEIL(POW(1.96 + 0.8416, 2) * (p1*(1-p1) + p2*(1-p2)) / POW(p1 - p2, 2)) AS n_needed_per_group
FROM params;


-- 7b. Two-proportion z-test with 95% confidence interval
-- Result: mobile 34.3% vs desktop 37.2%; diff -2.9 pts; CI [-5.0, -0.9]; z = -2.82; p ~ 0.005
WITH g AS (
  SELECT
    COUNTIF(LOWER(device) = 'mobile')                    AS n_m,
    COUNTIF(LOWER(device) = 'mobile'  AND purchased = 1) AS x_m,
    COUNTIF(LOWER(device) = 'desktop')                   AS n_d,
    COUNTIF(LOWER(device) = 'desktop' AND purchased = 1) AS x_d
  FROM `ecommerce.websession`
  WHERE added_to_cart = 1
),
r AS (
  SELECT *, x_m / n_m AS p_m, x_d / n_d AS p_d, (x_m + x_d) / (n_m + n_d) AS p_pool
  FROM g
)
SELECT
  n_m, x_m, ROUND(p_m, 4) AS mobile_rate,
  n_d, x_d, ROUND(p_d, 4) AS desktop_rate,
  ROUND(p_m - p_d, 4) AS diff,
  ROUND((p_m - p_d) / SQRT(p_pool * (1 - p_pool) * (1/n_m + 1/n_d)), 3) AS z,
  ROUND((p_m - p_d) - 1.96 * SQRT(p_m*(1-p_m)/n_m + p_d*(1-p_d)/n_d), 4) AS ci_low,
  ROUND((p_m - p_d) + 1.96 * SQRT(p_m*(1-p_m)/n_m + p_d*(1-p_d)/n_d), 4) AS ci_high
FROM r;


-- 7c. Same test within each channel (confounder check)
-- Result: gap largest in Paid Social (-8.1 pts, z = -3.31, significant after Bonferroni);
--         other channels not individually significant
WITH g AS (
  SELECT channel,
    COUNTIF(LOWER(device) = 'mobile')                    AS n_m,
    COUNTIF(LOWER(device) = 'mobile'  AND purchased = 1) AS x_m,
    COUNTIF(LOWER(device) = 'desktop')                   AS n_d,
    COUNTIF(LOWER(device) = 'desktop' AND purchased = 1) AS x_d
  FROM `ecommerce.websession`
  WHERE added_to_cart = 1
  GROUP BY channel
),
r AS (
  SELECT *,
    SAFE_DIVIDE(x_m, n_m) AS p_m,
    SAFE_DIVIDE(x_d, n_d) AS p_d,
    SAFE_DIVIDE(x_m + x_d, n_m + n_d) AS p_pool
  FROM g
)
SELECT
  channel, n_m, n_d,
  ROUND(p_m, 4) AS mobile_rate,
  ROUND(p_d, 4) AS desktop_rate,
  ROUND(p_m - p_d, 4) AS diff,
  ROUND(SAFE_DIVIDE(p_m - p_d, SQRT(p_pool * (1 - p_pool) * (1/n_m + 1/n_d))), 3) AS z
FROM r
ORDER BY channel;


-- 7f. Channel-adjusted test (Cochran-Mantel-Haenszel)
-- Result: adjusted gap -2.9 pts, z = -2.80 (p ~ 0.005): not explained by channel mix
WITH g AS (
  SELECT channel,
    COUNTIF(LOWER(device) = 'mobile')                    AS n_m,
    COUNTIF(LOWER(device) = 'mobile'  AND purchased = 1) AS x_m,
    COUNTIF(LOWER(device) = 'desktop')                   AS n_d,
    COUNTIF(LOWER(device) = 'desktop' AND purchased = 1) AS x_d
  FROM `ecommerce.websession`
  WHERE added_to_cart = 1
  GROUP BY channel
),
c AS (SELECT *, n_m + n_d AS n, x_m + x_d AS x FROM g)
SELECT
  SUM(x_m - n_m * x / n)
    / SQRT(SUM(n_m * n_d * x * (n - x) / (n * n * (n - 1))))      AS cmh_z,
  SUM((x_m/n_m - x_d/n_d) * (n_m * n_d / n)) / SUM(n_m * n_d / n) AS adjusted_gap
FROM c;


-- 7d. Revenue per carted session (Welch's t-test)
-- Result: mobile 22.14 vs desktop 24.57; t = -3.20 (p ~ 0.001)
WITH s AS (
  SELECT LOWER(w.device) AS device, IFNULL(o.order_value, 0) AS rev
  FROM `ecommerce.websession` w
  LEFT JOIN `ecommerce.order_summary` o USING (sessionid)
  WHERE w.added_to_cart = 1 AND LOWER(w.device) IN ('mobile', 'desktop')
),
g AS (
  SELECT device, COUNT(*) AS n, AVG(rev) AS mean, VAR_SAMP(rev) AS var
  FROM s
  GROUP BY device
)
SELECT
  ROUND(m.mean, 2) AS mobile_rev_per_cart_session,
  ROUND(d.mean, 2) AS desktop_rev_per_cart_session,
  ROUND(m.mean - d.mean, 2) AS diff,
  ROUND((m.mean - d.mean) / SQRT(m.var/m.n + d.var/d.n), 3) AS t
FROM g m CROSS JOIN g d
WHERE m.device = 'mobile' AND d.device = 'desktop';


-- 7d (part 2). Average order value among purchasers (Welch's t-test)
-- Result: mobile 64.62 vs desktop 66.06; t ~ -1.52 (not significant)
WITH g AS (
  SELECT LOWER(device) AS device, COUNT(*) AS n,
         AVG(order_value) AS mean, VAR_SAMP(order_value) AS var
  FROM `ecommerce.order_summary`
  WHERE LOWER(device) IN ('mobile', 'desktop')
  GROUP BY 1
)
SELECT
  ROUND(m.mean, 2) AS mobile_aov,
  ROUND(d.mean, 2) AS desktop_aov,
  ROUND((m.mean - d.mean) / SQRT(m.var/m.n + d.var/d.n), 3) AS t
FROM g m CROSS JOIN g d
WHERE m.device = 'mobile' AND d.device = 'desktop';


-- 7e. Business impact of the checkout gap
-- Result: ~10 lost orders/month (~121/year, ~7,800/year); half gap ~325/month
WITH g AS (
  SELECT
    SAFE_DIVIDE(COUNTIF(LOWER(device) = 'desktop' AND purchased = 1), COUNTIF(LOWER(device) = 'desktop')) AS p_d,
    SAFE_DIVIDE(COUNTIF(LOWER(device) = 'mobile'  AND purchased = 1), COUNTIF(LOWER(device) = 'mobile'))  AS p_m,
    COUNTIF(LOWER(device) = 'mobile') / COUNT(DISTINCT DATE_TRUNC(DATE(sessiondate), MONTH)) AS mobile_carts_per_month
  FROM `ecommerce.websession`
  WHERE added_to_cart = 1
),
a AS (
  SELECT AVG(order_value) AS mobile_aov
  FROM `ecommerce.order_summary`
  WHERE LOWER(device) = 'mobile'
)
SELECT
  ROUND((p_d - p_m) * mobile_carts_per_month, 0)                    AS lost_orders_per_month,
  ROUND((p_d - p_m) * mobile_carts_per_month * mobile_aov, 2)       AS lost_revenue_per_month,
  ROUND(0.5 * (p_d - p_m) * mobile_carts_per_month * mobile_aov, 2) AS gain_if_half_gap_closed
FROM g, a;


-- 7g. Add-to-cart gap (all sessions)
-- Result: mobile 32.0% vs desktop 36.0%; z ~ -6.7 (p < 0.001)
WITH g AS (
  SELECT
    COUNTIF(LOWER(device) = 'mobile')                        AS n_m,
    COUNTIF(LOWER(device) = 'mobile'  AND added_to_cart = 1) AS x_m,
    COUNTIF(LOWER(device) = 'desktop')                       AS n_d,
    COUNTIF(LOWER(device) = 'desktop' AND added_to_cart = 1) AS x_d
  FROM `ecommerce.websession`
),
r AS (
  SELECT *, x_m / n_m AS p_m, x_d / n_d AS p_d, (x_m + x_d) / (n_m + n_d) AS p_pool
  FROM g
)
SELECT
  ROUND(p_m, 4) AS mobile_atc_rate,
  ROUND(p_d, 4) AS desktop_atc_rate,
  ROUND(p_m - p_d, 4) AS diff,
  ROUND((p_m - p_d) / SQRT(p_pool * (1 - p_pool) * (1/n_m + 1/n_d)), 3) AS z
FROM r;
