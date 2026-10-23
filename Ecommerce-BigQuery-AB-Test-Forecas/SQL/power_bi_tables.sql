-- =====================================================================
-- 06_powerbi_tables.sql
-- Small result tables loaded into Power BI (Import mode).
-- Run 02_base_tables.sql and 05_forecast.sql first.
-- =====================================================================


-- Overall A/B test result (one row) – feeds the headline cards
CREATE OR REPLACE TABLE `ecommerce.ab_result` AS
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
),
s AS (
  SELECT *,
    (p_m - p_d) / SQRT(p_pool * (1 - p_pool) * (1/n_m + 1/n_d)) AS z,
    (p_m - p_d) - 1.96 * SQRT(p_m*(1-p_m)/n_m + p_d*(1-p_d)/n_d) AS ci_low,
    (p_m - p_d) + 1.96 * SQRT(p_m*(1-p_m)/n_m + p_d*(1-p_d)/n_d) AS ci_high
  FROM r
)
SELECT
  n_m AS mobile_cart_sessions,
  n_d AS desktop_cart_sessions,
  p_m AS mobile_rate,
  p_d AS desktop_rate,
  p_m - p_d AS difference,
  z, ci_low, ci_high,
  CASE WHEN ABS(z) > 1.96 THEN 'Statistically significant (p < 0.05)'
       ELSE 'Not statistically significant' END AS verdict
FROM s;


-- Conversion by device with each bar's 95% confidence range – feeds the error-bar chart
CREATE OR REPLACE TABLE `ecommerce.ab_device` AS
SELECT
  device,
  COUNT(*) AS cart_sessions,
  AVG(purchased) AS conversion,
  AVG(purchased) - 1.96 * SQRT(AVG(purchased) * (1 - AVG(purchased)) / COUNT(*)) AS ci_lower,
  AVG(purchased) + 1.96 * SQRT(AVG(purchased) * (1 - AVG(purchased)) / COUNT(*)) AS ci_upper
FROM `ecommerce.websession`
WHERE added_to_cart = 1 AND LOWER(device) IN ('mobile', 'desktop')
GROUP BY device;


-- Conversion by channel and device – feeds the channel comparison chart
CREATE OR REPLACE TABLE `ecommerce.ab_by_channel` AS
SELECT
  channel,
  device,
  COUNT(*)       AS cart_sessions,
  AVG(purchased) AS conversion
FROM `ecommerce.websession`
WHERE added_to_cart = 1 AND LOWER(device) IN ('mobile', 'desktop')
GROUP BY channel, device;


-- Actual and forecast monthly revenue in one table – feeds the forecast line chart
-- The last actual month is repeated as 'Forecast' so the two lines connect.
CREATE OR REPLACE TABLE `ecommerce.revenue_actual_vs_forecast` AS
WITH actual AS (
  SELECT DATE_TRUNC(DATE(day), MONTH) AS month, SUM(revenue) AS revenue
  FROM `ecommerce.daily_revenue`
  GROUP BY month
),
fc AS (
  SELECT DATE_TRUNC(DATE(forecast_timestamp), MONTH) AS month, SUM(forecast_value) AS revenue
  FROM ML.FORECAST(MODEL `ecommerce.revenue_forecast`,
                   STRUCT(90 AS horizon, 0.9 AS confidence_level))
  GROUP BY month
)
SELECT month, 'Actual' AS series, revenue FROM actual
UNION ALL
SELECT month, 'Forecast', revenue FROM fc
UNION ALL
SELECT month, 'Forecast', revenue FROM actual
WHERE month = (SELECT MAX(month) FROM actual);
