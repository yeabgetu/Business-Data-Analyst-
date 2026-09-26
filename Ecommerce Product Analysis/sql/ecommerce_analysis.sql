-- =====================================================
-- E-COMMERCE PRODUCT ANALYSIS
-- SQL Analysis
-- Database: ecommerce_analytics
-- =====================================================


-- =====================================================
-- 1. DATA QUALITY CHECKS
-- =====================================================

-- Check the number of records in each table

SELECT COUNT(*) AS total_order_rows
FROM orders;

SELECT COUNT(*) AS total_web_sessions
FROM websession;


-- Check whether purchasing sessions contain
-- multiple product/order rows

SELECT
    COUNT(*) AS purchasing_sessions,
    COUNT(CASE WHEN product_rows > 1 THEN 1 END) AS multi_product_sessions,
    MAX(product_rows) AS max_products_in_one_session
FROM (
    SELECT
        sessionid,
        COUNT(*) AS product_rows
    FROM orders
    GROUP BY sessionid
) AS session_summary;

-- =====================================================
-- 2. OVERALL BUSINESS KPIs
-- =====================================================

-- Overall sales performance

SELECT
    COUNT(DISTINCT sessionid) AS total_orders,
    SUM(units) AS total_units_sold,
    ROUND(SUM(order_value), 2) AS total_revenue,
    ROUND(AVG(order_value), 2) AS average_order_value
FROM orders;


-- Overall e-commerce funnel performance

SELECT
    COUNT(*) AS total_sessions,
    SUM(added_to_cart) AS cart_sessions,
    SUM(purchased) AS purchase_sessions,

    ROUND(
        100.0 * SUM(added_to_cart) / COUNT(*),
        2
    ) AS add_to_cart_rate,

    ROUND(
        100.0 * SUM(purchased) / COUNT(*),
        2
    ) AS overall_conversion_rate,

    SUM(added_to_cart) - SUM(purchased) AS abandoned_carts,

    ROUND(
        100.0 * (SUM(added_to_cart) - SUM(purchased))
        / SUM(added_to_cart),
        2
    ) AS cart_abandonment_rate

FROM websession;

-- =====================================================
-- 3. PRODUCT ANALYSIS
-- =====================================================


-- 3.1 Category performance

SELECT
    category,
    SUM(units) AS total_units,
    ROUND(SUM(order_value), 2) AS total_revenue
FROM orders
GROUP BY category
ORDER BY total_revenue DESC;


-- 3.2 Top 10 SKUs by revenue

SELECT
    sku,
    category,
    SUM(units) AS total_units,
    ROUND(SUM(order_value), 2) AS total_revenue
FROM orders
GROUP BY sku, category
ORDER BY total_revenue DESC
LIMIT 10;


-- 3.3 Revenue concentration by SKU

WITH sku_revenue AS (
    SELECT
        sku,
        category,
        SUM(order_value) AS revenue
    FROM orders
    GROUP BY sku, category
),
ranked_skus AS (
    SELECT
        sku,
        category,
        revenue,
        SUM(revenue) OVER (
            ORDER BY revenue DESC
        ) AS cumulative_revenue
    FROM sku_revenue
)
SELECT
    sku,
    category,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        100.0 * cumulative_revenue /
        SUM(revenue) OVER (),
        2
    ) AS cumulative_revenue_pct
FROM ranked_skus
ORDER BY revenue DESC
LIMIT 20;


-- 3.4 Number of SKUs required to generate 50% of revenue

WITH sku_revenue AS (
    SELECT
        sku,
        SUM(order_value) AS revenue
    FROM orders
    GROUP BY sku
),
ranked_skus AS (
    SELECT
        sku,
        revenue,
        SUM(revenue) OVER (
            ORDER BY revenue DESC
        ) AS cumulative_revenue,
        SUM(revenue) OVER () AS total_revenue
    FROM sku_revenue
)
SELECT
    COUNT(*) AS skus_needed_for_50pct_revenue,
    MAX(total_revenue) AS total_revenue,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sku_revenue)
        AS pct_of_skus
FROM ranked_skus
WHERE cumulative_revenue <= total_revenue * 0.50
   OR (
       cumulative_revenue - revenue
       < total_revenue * 0.50
   );

   -- =====================================================
-- 4. CHANNEL ANALYSIS
-- =====================================================


-- 4.1 Revenue performance by channel

SELECT
    channel,
    COUNT(DISTINCT sessionid) AS orders,
    SUM(units) AS total_units,
    ROUND(SUM(order_value), 2) AS total_revenue,
    ROUND(AVG(order_value), 2) AS average_order_value
FROM orders
GROUP BY channel
ORDER BY total_revenue DESC;


-- 4.2 Conversion performance by channel

SELECT
    channel,
    COUNT(*) AS total_sessions,
    SUM(added_to_cart) AS cart_sessions,
    SUM(purchased) AS purchases,

    ROUND(
        100.0 * SUM(added_to_cart) / COUNT(*),
        2
    ) AS add_to_cart_rate,

    ROUND(
        100.0 * SUM(purchased) / COUNT(*),
        2
    ) AS conversion_rate

FROM websession
GROUP BY channel
ORDER BY conversion_rate DESC;


-- 4.3 Cart abandonment by channel

SELECT
    channel,
    COUNT(*) AS total_sessions,
    SUM(added_to_cart) AS cart_sessions,
    SUM(purchased) AS purchases,

    SUM(added_to_cart) - SUM(purchased)
        AS abandoned_carts,

    ROUND(
        100.0 *
        (SUM(added_to_cart) - SUM(purchased))
        / SUM(added_to_cart),
        2
    ) AS cart_abandonment_rate

FROM websession
GROUP BY channel
ORDER BY cart_abandonment_rate DESC;

-- =====================================================
-- 5. DEVICE ANALYSIS
-- =====================================================


-- 5.1 Conversion performance by device

SELECT
    device,
    COUNT(*) AS total_sessions,
    SUM(added_to_cart) AS cart_sessions,
    SUM(purchased) AS purchases,

    ROUND(
        100.0 * SUM(added_to_cart) / COUNT(*),
        2
    ) AS add_to_cart_rate,

    ROUND(
        100.0 * SUM(purchased) / COUNT(*),
        2
    ) AS conversion_rate

FROM websession
GROUP BY device
ORDER BY conversion_rate DESC;


-- 5.2 Cart abandonment by device

SELECT
    device,
    COUNT(*) AS total_sessions,
    SUM(added_to_cart) AS cart_sessions,
    SUM(purchased) AS purchases,

    SUM(added_to_cart) - SUM(purchased)
        AS abandoned_carts,

    ROUND(
        100.0 *
        (SUM(added_to_cart) - SUM(purchased))
        / SUM(added_to_cart),
        2
    ) AS cart_abandonment_rate

FROM websession
GROUP BY device
ORDER BY cart_abandonment_rate DESC;


-- 5.3 Conversion by device and acquisition channel

SELECT
    device,
    channel,
    COUNT(*) AS total_sessions,
    SUM(purchased) AS purchases,

    ROUND(
        100.0 * SUM(purchased) / COUNT(*),
        2
    ) AS conversion_rate

FROM websession
GROUP BY device, channel
ORDER BY device, conversion_rate DESC;

-- =====================================================
-- 6. CONVERSION FUNNEL & CART ABANDONMENT
-- =====================================================


-- 6.1 Overall conversion funnel

SELECT
    COUNT(*) AS total_sessions,
    SUM(added_to_cart) AS cart_sessions,
    SUM(purchased) AS purchase_sessions,

    ROUND(
        100.0 * SUM(added_to_cart) / COUNT(*),
        2
    ) AS add_to_cart_rate,

    ROUND(
        100.0 * SUM(purchased) / SUM(added_to_cart),
        2
    ) AS cart_to_purchase_rate,

    ROUND(
        100.0 * SUM(purchased) / COUNT(*),
        2
    ) AS overall_conversion_rate

FROM websession;


-- 6.2 Cart abandonment overview

SELECT
    SUM(added_to_cart) AS cart_sessions,
    SUM(purchased) AS purchases,

    SUM(added_to_cart) - SUM(purchased)
        AS abandoned_carts,

    ROUND(
        100.0 *
        (SUM(added_to_cart) - SUM(purchased))
        / SUM(added_to_cart),
        2
    ) AS cart_abandonment_rate

FROM websession;


-- 6.3 Cart abandonment by device

SELECT
    device,
    SUM(added_to_cart) AS cart_sessions,
    SUM(purchased) AS purchases,

    SUM(added_to_cart) - SUM(purchased)
        AS abandoned_carts,

    ROUND(
        100.0 *
        (SUM(added_to_cart) - SUM(purchased))
        / SUM(added_to_cart),
        2
    ) AS cart_abandonment_rate

FROM websession
GROUP BY device
ORDER BY cart_abandonment_rate DESC;


-- 6.4 Cart abandonment by acquisition channel

SELECT
    channel,
    SUM(added_to_cart) AS cart_sessions,
    SUM(purchased) AS purchases,

    SUM(added_to_cart) - SUM(purchased)
        AS abandoned_carts,

    ROUND(
        100.0 *
        (SUM(added_to_cart) - SUM(purchased))
        / SUM(added_to_cart),
        2
    ) AS cart_abandonment_rate

FROM websession
GROUP BY channel
ORDER BY cart_abandonment_rate DESC;
-- =====================================================
-- 7. DISCOUNT & ORDER VALUE ANALYSIS
-- =====================================================


-- 7.1 Performance of discounted vs non-discounted purchases

SELECT
    discount_applied,
    COUNT(DISTINCT sessionid) AS purchasing_sessions,
    SUM(units) AS total_units,
    ROUND(SUM(order_value), 2) AS total_revenue,
    ROUND(AVG(order_value), 2) AS average_order_value
FROM orders
GROUP BY discount_applied
ORDER BY discount_applied;


-- 7.2 Share of purchasing sessions using discounts

SELECT
    COUNT(DISTINCT sessionid) AS total_purchasing_sessions,

    COUNT(DISTINCT CASE
        WHEN discount_applied = 1 THEN sessionid
    END) AS discounted_sessions,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE
            WHEN discount_applied = 1 THEN sessionid
        END)
        / COUNT(DISTINCT sessionid),
        2
    ) AS discounted_session_pct

FROM orders;


-- 7.3 Order value segmentation

SELECT
    CASE
        WHEN order_value < 50 THEN 'Under $50'
        WHEN order_value < 100 THEN '$50–$99'
        WHEN order_value < 150 THEN '$100–$149'
        ELSE '$150+'
    END AS order_value_segment,

    COUNT(*) AS purchasing_sessions,
    SUM(units) AS total_units,
    ROUND(SUM(order_value), 2) AS total_revenue,
    ROUND(AVG(order_value), 2) AS average_order_value

FROM orders

GROUP BY
    CASE
        WHEN order_value < 50 THEN 'Under $50'
        WHEN order_value < 100 THEN '$50–$99'
        WHEN order_value < 150 THEN '$100–$149'
        ELSE '$150+'
    END

ORDER BY MIN(order_value);
-- =====================================================
-- 8. MONTHLY PERFORMANCE ANALYSIS
-- =====================================================


-- 8.1 Monthly sales performance

SELECT
    DATE_TRUNC('month', sessiondate) AS month,
    COUNT(DISTINCT sessionid) AS purchasing_sessions,
    SUM(units) AS total_units,
    ROUND(SUM(order_value), 2) AS total_revenue

FROM orders

GROUP BY DATE_TRUNC('month', sessiondate)

ORDER BY month;


-- 8.2 Monthly conversion performance

SELECT
    DATE_TRUNC('month', sessiondate) AS month,
    COUNT(*) AS total_sessions,
    SUM(purchased) AS purchases,

    ROUND(
        100.0 * SUM(purchased) / COUNT(*),
        2
    ) AS conversion_rate

FROM websession

GROUP BY DATE_TRUNC('month', sessiondate)

ORDER BY month;


-- 8.3 Monthly traffic, conversion, and revenue

SELECT
    DATE_TRUNC('month', w.sessiondate) AS month,

    COUNT(*) AS total_sessions,

    SUM(w.purchased) AS purchases,

    ROUND(
        100.0 * SUM(w.purchased) / COUNT(*),
        2
    ) AS conversion_rate,

    ROUND(
        COALESCE(SUM(o.order_value), 0),
        2
    ) AS revenue

FROM websession w

LEFT JOIN orders o
    ON w.sessionid = o.sessionid

GROUP BY DATE_TRUNC('month', w.sessiondate)

ORDER BY month;

-- =====================================================
-- 9. ADVANCED SQL ANALYSIS
-- =====================================================


-- 9.1 Revenue contribution of the top 10% of SKUs

WITH sku_revenue AS (
    SELECT
        sku,
        SUM(order_value) AS revenue
    FROM orders
    GROUP BY sku
),

ranked_skus AS (
    SELECT
        sku,
        revenue,

        ROW_NUMBER() OVER (
            ORDER BY revenue DESC, sku
        ) AS sku_rank,

        COUNT(*) OVER () AS total_skus,

        SUM(revenue) OVER () AS total_revenue

    FROM sku_revenue
)

SELECT
    COUNT(*) AS top_10pct_skus,
    MAX(total_skus) AS total_skus,

    ROUND(
        100.0 * SUM(revenue)
        / MAX(total_revenue),
        2
    ) AS revenue_share_pct

FROM ranked_skus

WHERE sku_rank <= CEIL(total_skus * 0.10);
