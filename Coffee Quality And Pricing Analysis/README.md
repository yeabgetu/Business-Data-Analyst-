# Coffee Quality & Pricing Intelligence

## Project Overview

This project analyzes 35,000 coffee lots to investigate the factors associated with coffee quality and market pricing and to identify potential value opportunities for coffee sourcing and pricing decisions.

The analysis combines data cleaning, exploratory data analysis, correlation analysis, multivariable regression, and a model-based pricing benchmark using Python and Pandas.

The project focuses on understanding how coffee origin, processing method, certification, buyer segment, sensory characteristics, and production attributes relate to coffee quality and price.

---

## Business Questions

This analysis aims to answer:

- How strongly is coffee quality associated with market price?
- Which coffee origins have the highest quality and price levels?
- How do processing methods affect quality and price?
- How do certification categories differ in quality and pricing?
- How large is the pricing difference between commodity, premium, and specialty coffee?
- Which sensory and production characteristics are most strongly associated with coffee quality?
- Can observable coffee characteristics be used to create a pricing benchmark?
- Which high-quality coffee lots appear to be priced below their model-based benchmark?

---

## Dataset

The dataset contains coffee quality, production, processing, sensory, and commercial information.

### Key Variables

**Production & Environment**
- Country of origin
- Farm type
- Farm size
- Tree age
- Altitude
- Average temperature
- Annual rainfall
- Humidity

**Processing & Storage**
- Processing method
- Drying method
- Drying duration
- Storage months
- Storage conditions

**Bean Characteristics**
- Bean size
- Moisture
- Bean density
- Defect rate
- Traceability level

**Commercial Characteristics**
- Certification
- Intended buyer segment
- Lot size
- Roast level

**Sensory Characteristics**
- Acidity
- Sweetness
- Body
- Aroma
- Flavor

**Outcomes**
- Coffee quality score
- Quality grade
- Price per kg

---

## Data Preparation

The original dataset contained 35,700 records.

During data cleaning:

- Removed 350 exact duplicate records.
- Resolved 350 measurement revisions by retaining the revised records.
- Final dataset contains **35,000 unique coffee lots**.
- Missing numerical values for humidity, rainfall, bean density, and moisture were imputed using country-level medians.
- Missing certification values were labeled **"Not Recorded"** rather than assuming that the coffee was uncertified.
- Checked categorical consistency and potential outliers.
- Retained plausible extreme observations rather than removing them automatically.

---

## Exploratory Analysis

### Quality and Price

Coffee quality and price showed a **moderate positive relationship**:

- Pearson correlation: **r = 0.336**
- Approximately **11.3% of price variation** is explained by quality alone through a simple linear relationship.

This indicates that coffee quality is associated with price, but quality alone does not explain most pricing differences.

### Quality by Origin

Average quality scores differed across origins:

| Country | Average Quality |
|---|---:|
| Kenya | 81.33 |
| Colombia | 81.08 |
| Ethiopia | 80.76 |
| Honduras | 80.28 |
| Brazil   | 77.32 |
| Indonesia | 73.85 |
| Vietnam   | 72.92 |

### Price by Origin

Average prices also varied substantially:

| Country | Average Price/kg |
|---|---:|
| Kenya | $6.85 |
| Ethiopia | $6.06 |
| Colombia | $5.64 |
| Honduras | $4.86 |
| Brazil | $4.42 |
| Indonesia | $4.18 |
| Vietnam | $3.68 |

---

## Processing Method

Average quality and price differed by processing method.

### Quality

| Processing Method | Average Quality |
|---|---:|
| Anaerobic | 79.16 |
| Washed | 78.14 |
| Honey | 77.65 |
| Natural | 76.83 |

### Price

| Processing Method | Average Price/kg |
|---|---:|
| Anaerobic | $5.76 |
| Honey | $5.05 |
| Washed | $4.89 |
| Natural | $4.62 |

---

## Buyer Segment Analysis

Buyer segment showed one of the strongest differences in market pricing.

| Buyer Segment | Average Quality | Average Price/kg |
|---|---:|---:|
| Commodity | 76.83 | $3.88 |
| Premium | 78.58 | $5.49 |
| Specialty | 80.78 | $9.97 |

Specialty coffee had a much higher average price than commodity coffee, while the difference in average quality was comparatively smaller.

This suggests that market positioning and buyer segment may play an important role in price beyond quality alone.

---

## Sensory Analysis

The strongest correlations with the overall coffee quality score were:

| Sensory Attribute | Correlation with Quality |
|---|---:|
| Flavor | 0.730 |
| Acidity | 0.700 |
| Aroma | 0.670 |
| Sweetness | 0.660 |
| Body | 0.065 |

Flavor, acidity, aroma, and sweetness showed strong positive associations with the overall quality score, while body showed a very weak relationship in this dataset.

---

## Quality Regression Analysis

A multivariable regression model was used to examine the relationship between coffee quality and production/environmental characteristics.

The reduced model achieved:

- **R² = 0.854**
- **Adjusted R² = 0.854**
- **35,000 observations**

The strongest positive coefficient was associated with bean density, while defect rate showed a strong negative association with quality.

The model was also checked for multicollinearity and heteroscedasticity. Variance inflation factors were reduced to acceptable levels after removing highly collinear predictors.

A Breusch-Pagan test indicated heteroscedasticity, so robust HC3 standard errors were used for inference.

> These results describe statistical associations in the dataset and should not be interpreted as causal effects.

---

# Pricing Benchmark

To identify potentially underpriced high-quality coffee, a pricing benchmark was created using observable characteristics:

- Coffee quality score
- Country of origin
- Processing method
- Certification
- Intended buyer segment

The benchmark model achieved:

- **R² = 0.787**
- **Adjusted R² = 0.787**
- **35,000 observations**

The model was then used to estimate an expected price for each coffee lot.

### Price Gap

The price gap was calculated as:

**Observed Price − Expected Price**

A negative price gap indicates that the observed price is below the model-based benchmark.

These gaps represent **potential pricing opportunities**, not proof of mispricing.

---

## Value Opportunity Analysis

The top 25% quality threshold was:

**81.32**

This identified:

**8,761 high-quality coffee lots**

Among these:

**2,578 lots (29.43%)** were priced at least **10% below their model-based benchmark**.

These lots represent potential sourcing or pricing opportunities for further investigation.

### Opportunity Rate by Origin

| Country | High-Quality Lots | Strong Opportunities | Opportunity Rate |
|---|---:|---:|---:|
| Kenya | 1,227 | 409 | **33.33%** |
| Ethiopia | 1,534 | 478 | **31.16%** |
| Indonesia | 232 | 70 | **30.17%** |
| Colombia | 2,464 | 743 | **30.15%** |
| Vietnam | 130 | 37 | **28.46%** |
| Brazil | 2,141 | 573 | **26.76%** |
| Honduras | 1,033 | 268 | **25.94%** |

Kenya and Ethiopia had the highest rates of potential pricing opportunities among the origins analyzed.

---

## Key Findings

### 1. Quality matters, but does not determine price alone

The quality-price correlation was moderate (**r = 0.336**), showing that market price is influenced by factors beyond quality.

### 2. Origin is strongly associated with both quality and price

Kenya, Colombia, and Ethiopia recorded the highest average quality scores, while Kenya and Ethiopia also had some of the highest average prices.

### 3. Buyer segment has a major pricing relationship

Specialty coffee commanded substantially higher prices than premium and commodity coffee, despite a relatively smaller difference in average quality.

### 4. Sensory characteristics are strongly associated with quality

Flavor, acidity, aroma, and sweetness showed strong relationships with overall quality.

### 5. Production characteristics are important

Bean density, altitude, defect rate, and several environmental/processing variables showed meaningful relationships with quality in the regression analysis.

### 6. Potential value opportunities exist

2,578 high-quality lots were priced at least 10% below their model-based benchmark.

Kenya and Ethiopia had the highest potential opportunity rates at **33.3%** and **31.2%**, respectively.

---

## Business Implications

The analysis suggests that coffee pricing is influenced by a combination of:

- Quality
- Origin
- Processing method
- Certification
- Buyer segment
- Other observable and unobservable market factors

A model-based benchmark can therefore be used as a **screening tool** to identify high-quality lots whose observed prices appear low relative to comparable characteristics.

For coffee sourcing and procurement, this type of analysis could support:

- Supplier screening
- Price negotiation
- Sourcing prioritization
- Market comparison
- Identification of potential value opportunities

---

## Limitations

- The dataset is observational, so the analysis identifies associations rather than causal effects.
- "Not Recorded" certification represents missing information and should not be interpreted as "not certified."
- The pricing benchmark uses only observable variables available in the dataset.
- A negative price gap does not prove that a coffee lot is mispriced.
- Actual market prices may also reflect factors such as contracts, relationships, market timing, logistics, buyer preferences, and other variables not included in the dataset.
- Sensory attributes may overlap with the construction of the overall quality score.
- Regression performance reported in the analysis is based on the available dataset and should not be interpreted as out-of-sample predictive performance.

---

## Tools & Technologies

- **Python**
- **Pandas**
- **NumPy**
- **Matplotlib**
- **Statsmodels**
- **Jupyter Notebook**
- **Statistical Analysis**
- **Regression Modeling**
- **Data Cleaning**
- **Exploratory Data Analysis**

---

## Project Structure

```text
coffee-quality-pricing-analysis/
│
├── data/
│   ├── coffee_value_benchmark.csv
│   ├── coffee_record_metadata.csv
│   ├── coffee_benchmark_splits.csv
│   └── feature_dictionary.csv
│
├── python/
│   └── 01_data_cleaning.ipynb
│
├── insights/
│   └── business_insights.md
│
└── README.md
