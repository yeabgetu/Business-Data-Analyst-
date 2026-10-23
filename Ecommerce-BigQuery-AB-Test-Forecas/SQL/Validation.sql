-- =====================================================================
-- 01_validation.sql
-- Data-quality checks after migrating from PostgreSQL to BigQuery.
--
-- Load schemas used (BigQuery console, "Edit as text"):
--   websession: sessionid:STRING,sessiondate:TIMESTAMP,device:STRING,channel:STRING,
--               added_to_cart:INTEGER,purchased:INTEGER
--   orders:     sessionid:STRING,sessiondate:TIMESTAMP,device:STRING,channel:STRING,
--               sku:STRING,category:STRING,discount_applied:INTEGER,
--               order_value:NUMERIC,units:INTEGER
--
-- Results: 25,000 sessions and 3,037 orders (1 Jan – 31 Dec 2025);
--          0 duplicates; 1 row per order; 0 consistency issues.
-- =====================================================================


-- 4a. Row counts and date range (compare with PostgreSQL)
SELECT 'websession' AS tbl, COUNT(*) AS n, MIN(sessiondate) AS first_dt, MAX(sessiondate) AS last_dt
FROM `ecommerce.websession`
UNION ALL
SELECT 'orders', COUNT(*), MIN(sessiondate), MAX(sessiondate)
FROM `ecommerce.orders`;


-- 4b. Device and channel labels
SELECT device, channel, COUNT(*) AS sessions
FROM `ecommerce.websession`
GROUP BY 1, 2
ORDER BY 1, 2;


-- 4c. Grain check: duplicate sessions and rows per order
SELECT
  (SELECT COUNT(*) - COUNT(DISTINCT sessionid) FROM `ecommerce.websession`) AS duplicate_sessions,
  (SELECT COUNT(*) / COUNT(DISTINCT sessionid) FROM `ecommerce.orders`)     AS rows_per_order;


-- 4d. Consistency: do purchase flags match the orders table?
SELECT
  COUNTIF(w.purchased = 1 AND o.sessionid IS NULL)     AS purchased_but_no_order,
  COUNTIF(w.purchased = 0 AND o.sessionid IS NOT NULL) AS order_but_not_purchased,
  COUNTIF(w.purchased = 1 AND w.added_to_cart = 0)     AS purchased_without_cart
FROM `ecommerce.websession` w
LEFT JOIN (SELECT DISTINCT sessionid FROM `ecommerce.orders`) o USING (sessionid);
