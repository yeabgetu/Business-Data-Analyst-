# E-Commerce Product Analysis — Business Insights

## Business Problem

Limited visibility into e-commerce sales performance, product performance, customer conversion, and purchasing behavior makes it difficult to identify opportunities for improving revenue and conversion.

## Key Insights

### 1. High Cart Abandonment

- The website recorded **25,000 sessions** and **8,492 cart sessions**.
- **5,455 carts were abandoned**, resulting in a **64.24% cart abandonment rate**.
- Only **35.76% of cart sessions resulted in a purchase**.

**Business implication:** A significant portion of users who show purchase intent do not complete their purchases, highlighting an opportunity to investigate the checkout and purchasing journey.

### 2. Mobile Conversion Is Lower Than Desktop

- Desktop conversion rate: **13.40%**
- Mobile conversion rate: **10.97%**
- Difference: **2.43 percentage points**

Mobile also had a higher cart abandonment rate (**65.74%**) than desktop (**62.81%**).

**Business implication:** The mobile purchasing experience may warrant further investigation, particularly around navigation, checkout, page performance, and usability.

### 3. Revenue Is Broadly Distributed Across Products

- The dataset contains **400 SKUs**.
- The top **10% of SKUs generated 17.08% of total revenue**.
- Approximately **35% of SKUs were required to reach 50% of total revenue**.

**Business implication:** Revenue is not heavily dependent on a small number of products, suggesting that performance is distributed across a relatively broad product portfolio.

### 4. Paid Search Generates the Highest Revenue

- Paid Search generated **$58,320.29** in revenue from **899 purchasing sessions**.
- Organic generated the highest traffic volume with **7,240 sessions**, but had the lowest conversion rate among the channels analyzed at **11.57%**.

**Business implication:** Traffic volume and revenue contribution differ across acquisition channels, making both traffic and conversion important when evaluating channel performance.

## Additional Findings

### Discount Usage

- **36.6%** of purchasing sessions used a discount.
- Average order value for discounted purchases: **$61.82**
- Average order value for non-discounted purchases: **$67.44**

This shows an observed difference in order value between discounted and non-discounted purchases. The analysis does **not** establish that discounts caused the difference.

### Order Value Distribution

The **$50–$99** order-value segment generated **$136,793.95**, representing the largest share of both purchasing sessions and revenue.

This segment represents approximately **62% of purchases** and **69% of total revenue**.

### Monthly Performance

Monthly revenue remained relatively stable throughout the year, ranging from approximately **$15.27K to $18.22K**.

January recorded the highest revenue, while September recorded the lowest revenue and lowest monthly conversion rate. With only one year of data, this is not sufficient to establish a recurring seasonal pattern.

## Potential Business Actions

Based on the analysis, the business could:

1. Investigate the checkout journey to understand the high cart abandonment rate.
2. Review the mobile shopping experience because mobile conversion is lower than desktop.
3. Evaluate acquisition channels using both traffic volume and conversion performance.
4. Monitor products across the broader catalog rather than focusing only on a small group of top-selling SKUs.
5. Further analyze discount strategies to understand their relationship with order value and profitability.

## Conclusion

The analysis provides visibility into e-commerce sales, product performance, acquisition channels, conversion, cart abandonment, discounts, and order-value behavior.

The strongest opportunities identified are **reducing cart abandonment, understanding the mobile conversion gap, and improving channel-level performance analysis**.

This project demonstrates the use of **PostgreSQL, aggregation, CTEs, window functions, CASE statements, date functions, and multi-table analysis** to translate raw e-commerce data into actionable business insights.
