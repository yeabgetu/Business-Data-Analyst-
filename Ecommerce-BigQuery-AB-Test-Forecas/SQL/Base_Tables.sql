-- =====================================================================
-- 02_base_tables.sql
-- Helper tables reused by the KPI, A/B test, and forecast queries.
-- =====================================================================


-- One row per order
CREATE OR REPLACE TABLE `ecommerce.order_summary` AS
SELECT
  sessionid,
  ANY_VALUE(sessiondate) AS sessiondate,
  ANY_VALUE(device)      AS device,
  ANY_VALUE(channel)     AS channel,
  SUM(order_value)       AS order_value,
  SUM(units)             AS units,
  MAX(discount_applied)  AS discount_applied
FROM `ecommerce.orders`
GROUP BY sessionid;


-- Monthly orders, revenue, and average order value
CREATE OR REPLACE TABLE `ecommerce.monthly_revenue` AS
SELECT
  DATE_TRUNC(DATE(sessiondate), MONTH) AS month,
  COUNT(*)         AS orders,
  SUM(order_value) AS revenue,
  AVG(order_value) AS aov
FROM `ecommerce.order_summary`
GROUP BY month;


-- Daily revenue with zero-revenue days filled in (input for forecasting)
CREATE OR REPLACE TABLE `ecommerce.daily_revenue` AS
WITH b AS (
  SELECT DATE(MIN(sessiondate)) AS mn, DATE(MAX(sessiondate)) AS mx
  FROM `ecommerce.order_summary`
),
days AS (
  SELECT d FROM b, UNNEST(GENERATE_DATE_ARRAY(b.mn, b.mx)) AS d
)
SELECT TIMESTAMP(d) AS day, IFNULL(SUM(o.order_value), 0) AS revenue
FROM days
LEFT JOIN `ecommerce.order_summary` o ON DATE(o.sessiondate) = d
GROUP BY day;
