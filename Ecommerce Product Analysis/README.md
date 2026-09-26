# 🛒 E-Commerce Product Analysis

## 📌 Project Overview

This project analyzes e-commerce session and order data to understand **sales performance, product performance, customer conversion, acquisition channels, cart abandonment, and purchasing behavior**.

The analysis was performed using **PostgreSQL** to transform raw data into business insights that can support data-driven decision-making.

---

## 🎯 Business Problem

Limited visibility into e-commerce sales performance, product performance, conversion, and purchasing behavior makes it difficult to identify opportunities for improving revenue and customer conversion.

This project aims to answer questions such as:

- How is the business performing overall?
- Which product categories generate the most revenue?
- Which SKUs contribute most to revenue?
- Which acquisition channels perform best?
- How does conversion differ between devices?
- How significant is cart abandonment?
- How does discount usage relate to order value?
- How does performance change over time?

---

## 🛠️ Tools & Technologies

- **PostgreSQL**
- **SQL**
- **pgAdmin**
- **Git & GitHub**

### SQL Techniques Used

- Aggregations
- `GROUP BY`
- `CASE` statements
- CTEs
- Subqueries
- Window functions
- Date functions
- Conditional aggregation
- Multi-table joins
- Data quality checks

---

## 📊 Dataset

The project contains two datasets:

### `orders`

Contains completed purchasing-session information, including:

- Session ID
- Session date
- Device
- Acquisition channel
- SKU
- Product category
- Discount status
- Order value
- Units purchased

### `websession`

Contains website session and conversion information, including:

- Session ID
- Session date
- Device
- Acquisition channel
- Added to cart
- Purchased

The dataset contains:

- **25,000 web sessions**
- **3,037 purchasing sessions**
- **400 SKUs**

A data-quality check confirmed that each purchasing session contains a maximum of one product row in this dataset.

---

## 📈 Key Performance Indicators

| KPI | Result |
|---|---:|
| Total Sessions | 25,000 |
| Purchasing Sessions | 3,037 |
| Units Sold | 6,081 |
| Total Revenue | 198,585.98 |
| Average Order Value | 65.39 |
| Add-to-Cart Rate | 33.97% |
| Overall Conversion Rate | 12.15% |
| Cart Abandonment Rate | 64.24% |

---

## 🔍 Key Insights

### 🛒 1. High Cart Abandonment

The analysis identified a **64.24% cart abandonment rate**.

Of 8,492 cart sessions, **5,455 did not result in a purchase**.

This indicates a significant opportunity to investigate the checkout and purchasing journey.

---

### 📱 2. Mobile Conversion Is Lower Than Desktop

| Device | Conversion Rate |
|---|---:|
| Desktop | 13.40% |
| Mobile | 10.97% |

Mobile conversion was **2.43 percentage points lower** than desktop.

Mobile also recorded a higher cart abandonment rate, suggesting that the mobile purchasing experience warrants further investigation.

---

### 📦 3. Revenue Is Broadly Distributed Across Products

The dataset contains **400 SKUs**.

The top **10% of SKUs generated 17.08% of total revenue**, while approximately **35% of SKUs were required to reach 50% of revenue**.

This indicates that revenue is distributed across a relatively broad product portfolio rather than being concentrated in only a few products.

---

### 📣 4. Paid Search Generated the Highest Revenue

Paid Search generated **58,320.29** in revenue from **899 purchasing sessions**.

Organic generated the highest traffic volume with **7,240 sessions**, but recorded the lowest conversion rate among the analyzed channels at **11.57%**.

This highlights the importance of evaluating both traffic volume and conversion when assessing acquisition-channel performance.

---

## 💰 Additional Findings

### Discount Usage

**36.6%** of purchasing sessions used a discount.

| Purchase Type | Average Order Value |
|---|---:|
| Discounted | 61.82 |
| Non-discounted | 67.44 |

Discounted purchases had a lower observed average order value. This analysis does not establish that discounts caused the difference.

### Order Value

The **50–99** order-value segment represented approximately:

- **62% of purchasing sessions**
- **69% of total revenue**

This makes it the largest order-value segment in the dataset.

---

## 📅 Monthly Performance

Monthly revenue remained relatively stable throughout the year.

- Highest monthly revenue: **18,217.34**
- Lowest monthly revenue: **15,271.67**
- Highest monthly conversion: **12.71%**
- Lowest monthly conversion: **11.00%**

Because the dataset covers only one year, the analysis does not establish a recurring seasonal pattern.

---

## 💡 Potential Business Actions

Based on the analysis, the business could:

1. Investigate the checkout journey to understand the high cart abandonment rate.
2. Review the mobile shopping experience and checkout flow.
3. Evaluate acquisition channels using both traffic and conversion performance.
4. Monitor performance across the broader product catalog.
5. Further analyze discount strategies and their relationship with order value and profitability.

---

## 📁 Project Structure

```text
ecommerce-product-analysis/
│
├── data/
│   ├── orders.csv
│   └── websession.csv
│
├── sql/
│   └── ecommerce_analysis.sql
│
├── insights/
│   └── business_insights.md
│
└── README.md
```

---

## 🚀 Project Outcome

This project demonstrates how **SQL and PostgreSQL can be used to move from raw e-commerce data to structured business analysis**.

The analysis covers sales performance, product contribution, acquisition channels, conversion, cart abandonment, discounts, order value, and monthly trends.

The project also demonstrates practical use of **CTEs, window functions, conditional logic, aggregation, date functions, joins, and data-quality validation**.
