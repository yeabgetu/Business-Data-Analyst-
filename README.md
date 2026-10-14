# Yeab Getu — Data Analyst

Economics graduate turning business data into decisions. I combine SQL, Python and Power BI with the econometrics training from my degree, so I can build a dashboard and also test whether a pattern actually holds.

**Core:** SQL (PostgreSQL · CTEs · window functions) · Python (pandas, statsmodels, matplotlib) · Power BI (data modeling, DAX)
**Also use:** Excel · Tableau · Stata · SPSS · Git

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

---

## Certifications
See [Certifications](./Certifications).

## Contact
[LinkedIn](https://www.linkedin.com/in/yeab-getu-963394214/) · [Email](mailto:you@example.com)
