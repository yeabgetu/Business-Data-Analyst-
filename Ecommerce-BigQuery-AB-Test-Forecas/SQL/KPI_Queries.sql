-- =====================================================================
-- 03_kpi_queries.sql
-- Phase 1 KPIs rebuilt in BigQuery SQL.
-- =====================================================================


-- 6a. Funnel by device (cart abandonment = 1 - cart_to_purchase_rate)
-- Result: Mobile ATC 32.0%, cart->purchase 34.3%; Desktop ATC 36.0%, cart->purchase 37.2%
SELECT
  device,
  COUNT(*)           AS sessions,
  SUM(added_to_cart) AS carts,
  SUM(purchased)     AS purchases,
  SAFE_DIVIDE(SUM(added_to_cart), COUNT(*)) AS add_to_cart_rate,
  SAFE_DIVIDE(COUNTIF(added_to_cart = 1 AND purchased = 1), SUM(added_to_cart)) AS cart_to_purchase_rate,
  1 - SAFE_DIVIDE(COUNTIF(added_to_cart = 1 AND purchased = 1), SUM(added_to_cart)) AS cart_abandonment_rate,
  SAFE_DIVIDE(SUM(purchased), COUNT(*)) AS session_conversion
FROM `ecommerce.websession`
GROUP BY device
ORDER BY sessions DESC;


-- 6b. Conversion by channel and device
SELECT
  channel,
  device,
  COUNT(*) AS sessions,
  SAFE_DIVIDE(SUM(purchased), COUNT(*)) AS conversion
FROM `ecommerce.websession`
GROUP BY 1, 2
ORDER BY 1, 2;


-- 6c. Monthly revenue and month-over-month growth
SELECT
  month,
  orders,
  ROUND(revenue, 2) AS revenue,
  ROUND(aov, 2)     AS aov,
  ROUND(SAFE_DIVIDE(revenue - LAG(revenue) OVER (ORDER BY month),
                    LAG(revenue) OVER (ORDER BY month)), 3) AS mom_growth
FROM `ecommerce.monthly_revenue`
ORDER BY month;


-- 6d. Category revenue share
-- Result: Apparel 29.0%, Home 21.2%, Electronics 20.0%, Beauty 17.8%, Fitness 12.1%
SELECT
  category,
  ROUND(SUM(order_value), 2) AS revenue,
  SUM(units) AS units,
  ROUND(100 * SUM(order_value) / SUM(SUM(order_value)) OVER (), 1) AS pct_of_revenue
FROM `ecommerce.orders`
GROUP BY category
ORDER BY revenue DESC;


-- 6e. Discount effect on order value
-- Result: discounted AOV 61.82 vs full-price 67.44
SELECT
  discount_applied,
  COUNT(*) AS orders,
  ROUND(AVG(order_value), 2) AS aov,
  ROUND(AVG(units), 2)       AS avg_units
FROM `ecommerce.order_summary`
GROUP BY discount_applied;


-- 6f. Average order value by device
SELECT
  device,
  COUNT(*) AS orders,
  ROUND(AVG(order_value), 2) AS aov
FROM `ecommerce.order_summary`
GROUP BY device;
