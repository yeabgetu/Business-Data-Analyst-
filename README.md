# Yeab Getu — Data Analyst

Economics graduate turning business data into decisions. I combine SQL, Python and Power BI with the econometrics training from my degree, so I can build a dashboard and also test whether a pattern actually holds: from hypothesis tests and power analysis to controlling for confounders and forecasting.

**Core:** SQL (PostgreSQL · BigQuery · CTEs · window functions) · Python (pandas, statsmodels, scipy, matplotlib) · Power BI (data modeling, DAX)
**Analytics:** A/B testing · hypothesis testing · time-series forecasting (BigQuery ML) · funnel analysis
**Also use:** Excel · Tableau · Stata · SPSS · Git · Google Colab

---

## Projects

### ☕ Coffee Quality & Pricing Intelligence
**Python · pandas · statsmodels · regression**

**Question:** What drives coffee price, and which high-quality lots look underpriced?

- Cleaned 35,700 records down to 35,000 unique lots (deduplication, revision handling, country-level imputation)
- **Quality alone explains only ~11% of price** (r = 0.34). Buyer segment matters more: specialty lots average $9.97/kg vs $3.88 for commodity, with only a 4-point quality gap.
- Built a pricing benchmark from quality, origin, processing, certification and buyer segment (R² = 0.79)
- **Flagged 2,578 high-quality lots (29%) priced ≥10% below benchmark.** Kenya (33%) and Ethiopia (31%) had the highest opportunity rates.
- Quality model (R² = 0.85) with VIF checks and HC3 robust errors after a Breusch-Pagan test

**Use case:** a screening tool for buyers to prioritize sourcing and negotiation.

→ [View project](./Coffee%20Quality%20And%20Pricing%20Analysis)

### 🛒 E-Commerce Product Analysis
**PostgreSQL · Python · Power BI**

**Question:** Where is the store losing revenue between visit and purchase?

- Analyzed 25,000 sessions, 3,037 orders and 400 SKUs with SQL (CTEs, window functions, conditional aggregation)
- **64% cart abandonment:** 5,455 of 8,492 carts never converted
- **Mobile converts 2.4 points lower than desktop** (11.0% vs 13.4%) and abandons more
- Paid Search drove the most revenue; Organic brought the most traffic but converted worst (11.6%)
- Built an interactive Power BI dashboard covering KPIs, channels, devices and monthly trends

**Use case:** points the team to checkout and mobile UX as the biggest revenue levers.

→ [View project](./Ecommerce%20Product%20Analysis)
<img width="1190" height="655" alt="Ecommerce Analysis Dashboard" src="https://github.com/user-attachments/assets/d9c556ba-ee2c-4127-ad7d-35c3f0a7c79d" />


### 📊 E-Commerce A/B Test & Revenue Forecast
**BigQuery · BigQuery ML · Python · Power BI**

**Question:** Is mobile checkout really converting worse than desktop, and what is it worth?

- Migrated 25,000 sessions and 3,037 orders from PostgreSQL to BigQuery and validated the move (0 duplicates, 0 cross-table mismatches)
- **Mobile checkout converts 2.9 points lower** (34.3% vs 37.2% of carts, p ≈ 0.005, 95% CI −5.0 to −0.9), tested with a two-proportion z-test after a power analysis
- **Not a traffic-mix effect:** the gap is unchanged after adjusting for channel (Cochran–Mantel–Haenszel) and is concentrated in Paid Social (−8.1 points)
- Checkout gap costs ~$7,800/year; mobile's lower add-to-cart rate is a bigger lever (~$20,300/year)
- Forecast Q1 2026 revenue at ~$16,300/month with BigQuery ML ARIMA_PLUS (backtest MAPE 2.9%)

**Use case:** points the team to mobile product pages and the Paid Social checkout journey, with a randomized A/B test to confirm the fix.

→ [View project](./Ecommerce-BigQuery-AB-Test-Forecas)
<img width="1187" height="650" alt="dashboard_ab_page png" src="https://github.com/user-attachments/assets/bbbb2bde-5eeb-4299-8031-f01459c164e8" />


---

## Certifications
See (./Certifications)

## Contact
[LinkedIn](https://www.linkedin.com/in/yeab-getu-963394214/) · [Email](mailto:yeabgetuu@gmail.com)
