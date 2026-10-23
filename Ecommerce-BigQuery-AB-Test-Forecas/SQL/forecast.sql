-- =====================================================================
-- 05_forecast.sql
-- Monthly revenue forecast with BigQuery ML (ARIMA_PLUS on daily revenue).
-- Daily data is used because 12 monthly points is too few to fit reliably.
-- =====================================================================


-- 8a. Backtest model: train on data before November 2025
CREATE OR REPLACE MODEL `ecommerce.revenue_backtest`
OPTIONS(
  model_type = 'ARIMA_PLUS',
  time_series_timestamp_col = 'day',
  time_series_data_col = 'revenue',
  data_frequency = 'DAILY'
) AS
SELECT day, revenue
FROM `ecommerce.daily_revenue`
WHERE day < TIMESTAMP('2025-11-01');


-- 8a. Backtest check: model vs actual vs naive baseline (Nov–Dec 2025)
-- Result: ARIMA MAPE 2.9%; naive baseline MAPE 3.2%
WITH f AS (
  SELECT DATE_TRUNC(DATE(forecast_timestamp), MONTH) AS month, SUM(forecast_value) AS forecast
  FROM ML.FORECAST(MODEL `ecommerce.revenue_backtest`, STRUCT(61 AS horizon))
  GROUP BY month
),
a AS (
  SELECT DATE_TRUNC(DATE(day), MONTH) AS month, SUM(revenue) AS actual
  FROM `ecommerce.daily_revenue`
  WHERE day >= TIMESTAMP('2025-11-01')
  GROUP BY month
),
naive AS (
  SELECT AVG(revenue) AS avg_daily
  FROM `ecommerce.daily_revenue`
  WHERE day < TIMESTAMP('2025-11-01')
)
SELECT
  a.month,
  ROUND(CAST(actual AS FLOAT64), 0) AS actual,
  ROUND(forecast, 0) AS arima_forecast,
  ROUND(100 * ABS(CAST(actual AS FLOAT64) - forecast) / CAST(actual AS FLOAT64), 1) AS arima_abs_pct_error,
  ROUND(CAST(avg_daily AS FLOAT64) * EXTRACT(DAY FROM LAST_DAY(a.month)), 0) AS naive_forecast,
  ROUND(100 * ABS(CAST(actual AS FLOAT64)
        - CAST(avg_daily AS FLOAT64) * EXTRACT(DAY FROM LAST_DAY(a.month)))
        / CAST(actual AS FLOAT64), 1) AS naive_abs_pct_error
FROM a
JOIN f USING (month)
CROSS JOIN naive
ORDER BY a.month;


-- 8b. Final model: train on all of 2025
CREATE OR REPLACE MODEL `ecommerce.revenue_forecast`
OPTIONS(
  model_type = 'ARIMA_PLUS',
  time_series_timestamp_col = 'day',
  time_series_data_col = 'revenue',
  data_frequency = 'DAILY'
) AS
SELECT day, revenue
FROM `ecommerce.daily_revenue`;


-- 8b. Forecast for Q1 2026, summed to months
-- Result: Jan 16,858; Feb 15,238; Mar 16,870 (~16,300/month)
SELECT
  DATE_TRUNC(DATE(forecast_timestamp), MONTH) AS month,
  ROUND(SUM(forecast_value), 0) AS forecast_revenue
FROM ML.FORECAST(MODEL `ecommerce.revenue_forecast`,
                 STRUCT(90 AS horizon, 0.9 AS confidence_level))
GROUP BY month
ORDER BY month;


-- 8b (optional). Daily forecast with 90% prediction interval
CREATE OR REPLACE TABLE `ecommerce.forecast_daily` AS
SELECT
  DATE(forecast_timestamp)        AS day,
  forecast_value                  AS forecast,
  prediction_interval_lower_bound AS lower_90,
  prediction_interval_upper_bound AS upper_90
FROM ML.FORECAST(MODEL `ecommerce.revenue_forecast`,
                 STRUCT(90 AS horizon, 0.9 AS confidence_level));
