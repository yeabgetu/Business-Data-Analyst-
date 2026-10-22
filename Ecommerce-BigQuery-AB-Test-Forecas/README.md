# E-commerce Analysis: BigQuery, A/B Testing & Revenue Forecasting

An extension of my PostgreSQL + Power BI e-commerce project. I migrated the data to Google BigQuery,
validated the migration, statistically tested whether mobile checkout underperforms desktop,
quantified the revenue impact, and forecast monthly revenue with BigQuery ML.

<img width="1187" height="650" alt="dashboard_ab_page png" src="https://github.com/user-attachments/assets/22e46822-f068-41e1-8b7a-46d3433485fd" />


---

## Business question

On another project I showed that mobile shoppers appeared to convert less often than desktop shoppers.
This project asks:

1. **Is the mobile checkout gap real, or could it be chance?**
2. **Is it caused by the mobile experience or by differences in where mobile traffic comes from?**
3. **What is it worth, and what should the business prioritize?**
4. **What revenue should we expect next quarter?**

---

## Data

| Table | Grain | Rows | Key fields |
|---|---|---|---|
| `websession` | One row per session | 25,000 | device, channel, added_to_cart, purchased |
| `orders` | One row per order | 3,037 | category, discount_applied, order_value, units |

Period: **1 January – 31 December 2025** · Devices: Mobile, Desktop ·
Channels: Organic, Paid Search, Paid Social, Email, Affiliate

**Validation:** row counts and date ranges matched PostgreSQL; 0 duplicate sessions;
0 mismatches between purchase flags and the orders table; 0 purchases without a cart.

---

## Tools

**BigQuery** (SQL, BigQuery ML) · **Python** (statsmodels, scipy, pandas, matplotlib) ·
**Power BI** · **PostgreSQL**

---

## Approach

1. Exported tables from PostgreSQL and loaded them into the BigQuery sandbox
2. Ran data-quality checks (row counts, grain, cross-table consistency)
3. Rebuilt KPIs in BigQuery SQL (funnel, revenue trend, categories, discounts)
4. Framed an A/B comparison: mobile vs desktop cart-to-purchase conversion
5. Ran a power analysis, a two-proportion z-test, per-channel tests with Bonferroni correction,
   and a Cochran–Mantel–Haenszel test to adjust for channel
6. Compared revenue per carted session (Welch's t-test) and average order value
7. Estimated the revenue impact of the gap
8. Forecast daily revenue with BigQuery ML ARIMA_PLUS, backtested against a naive baseline
9. Built a Power BI page combining the test results and forecast

---

## Key results

### Funnel

| | Sessions | Add-to-cart | Cart → purchase | Abandonment | Session conversion |
|---|---|---|---|---|---|
| Desktop | 12,087 | 36.0% | 37.2% | 62.8% | 13.4% |
| Mobile | 12,913 | 32.0% | 34.3% | 65.7% | 11.0% |
| **Total** | **25,000** | **34.0%** | **35.8%** | **64.2%** | **12.1%** |

### A/B test: mobile vs desktop checkout

- **Hypothesis:** H₀: mobile cart-to-purchase rate = desktop rate; H₁: they differ (α = 0.05, power = 80%)
- **Sample size:** ~2,600 carts per group needed to detect a 10% relative drop; actual 4,136 mobile / 4,356 desktop
- **Result:** mobile **34.3%** vs desktop **37.2%**, a gap of **−2.9 pts**
  (95% CI −5.0 to −0.9; z = −2.82; **p ≈ 0.005**)
- **Channel-adjusted (CMH):** gap still **−2.9 pts** (p ≈ 0.005), so **not explained by traffic mix**
- **Concentration:** the gap is largest in **Paid Social** (31.8% vs 39.9%, −8.1 pts, p ≈ 0.001,
  significant after Bonferroni correction). Excluding Paid Social, the remaining gap is not significant.

| Channel | Mobile | Desktop | Gap (pts) |
|---|---|---|---|
| Paid Social | 31.8% | 39.9% | −8.1 |
| Email | 34.7% | 38.8% | −4.1 |
| Paid Search | 35.6% | 38.4% | −2.7 |
| Organic | 33.3% | 35.1% | −1.7 |
| Affiliate | 36.8% | 32.8% | +3.9 |

### Revenue

- Revenue per carted session: mobile **22.14** vs desktop **24.57** (t = −3.20, p ≈ 0.001)
- Average order value: mobile 64.62 vs desktop 66.06 (not significant, p ≈ 0.13)
- **The gap comes from fewer orders, not smaller baskets.**

### Business impact

- Checkout gap: ~**121 orders / ~[currency]7,800 per year** (~4% of revenue); closing half ≈ [currency]325/month
- About half of that loss comes from Paid Social mobile traffic
- **Larger opportunity:** mobile add-to-cart is 32.0% vs 36.0% (p < 0.001). The full-funnel mobile
  gap is worth ~314 orders / ~[currency]20,300 per year

### Forecast (BigQuery ML ARIMA_PLUS)

| Month | Forecast revenue |
|---|---|
| January 2026 | 16,858 |
| February 2026 | 15,238 |
| March 2026 | 16,870 |

- Backtest (Nov–Dec 2025): **MAPE 2.9%** vs 3.2% for a naive average-daily-revenue baseline
- Revenue showed no meaningful trend or seasonality in 2025, so the forecast is effectively a stable
  run-rate of ~16,300 per month

<img width="1188" height="659" alt="forecast_chart png" src="https://github.com/user-attachments/assets/f01fda2c-64ad-49ba-a289-4fabb7414a05" />


### Other findings

- Total 2025 revenue: 198,586 · Average order value: 65.39
- Discounted orders (36.6%) average 61.82 vs 67.44 at full price
- Apparel is the top category (29% of revenue)

---

## Recommendations

1. **Investigate the Paid Social mobile checkout journey.** One hypothesis: social apps open links in
   in-app browsers where saved logins and payment methods are unavailable.
2. **Prioritize mobile product pages.** Mobile's add-to-cart gap is worth roughly three times the checkout gap.
3. **Validate with a randomized A/B test** of a redesigned mobile checkout before full rollout.
4. **Review the discount strategy.** Discounts are not associated with larger baskets.

---

## Limitations

- **Observational, not randomized:** users choose their device. Channel was adjusted for, but other
  differences between mobile and desktop users may remain.
- **One year of data:** too short to detect yearly seasonality in the forecast.
- **Forecast adds little over a naive baseline** because revenue was stable.
- Per-channel results are based on smaller samples.
