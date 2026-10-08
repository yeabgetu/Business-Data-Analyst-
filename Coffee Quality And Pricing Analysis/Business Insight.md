# Coffee Quality & Pricing Intelligence — Business Insights

## Executive Summary

This analysis examined 35,000 coffee lots to understand the relationship between coffee quality and market pricing and to identify potential value opportunities.

The analysis found that coffee quality is positively associated with price, but quality alone does not explain market pricing. Origin, processing method, certification, and buyer segment also show important relationships with price.

A model-based pricing benchmark identified 2,578 high-quality lots (29.43%) priced at least 10% below their estimated benchmark, providing potential opportunities for further sourcing and pricing investigation.

---

## Key Findings

### 1. Quality and Price

Coffee quality and price have a moderate positive relationship:

- Pearson correlation: **0.336**
- Quality alone explains approximately **11.3%** of price variation in the simple linear relationship.

**Business implication:**  
Higher-quality coffee tends to command higher prices, but other market and commercial factors play a substantial role in determining price.

---

### 2. Coffee Origin Matters

Average quality varied considerably across origins.

| Origin | Avg. Quality | Avg. Price/kg |
|---|---:|---:|
| Kenya | 81.33 | $6.85 |
| Colombia | 81.08 | $5.64 |
| Ethiopia | 80.76 | $6.06 |
| Honduras | 80.28 | $4.86 |
| Brazil | 77.32 | $4.42 |
| Indonesia | 73.85 | $4.18 |
| Vietnam | 72.92 | $3.68 |

**Business implication:**  
Origin is associated with both quality and pricing, suggesting that sourcing strategies should consider origin-specific market positioning rather than relying on quality score alone.

---

### 3. Buyer Segment Has a Strong Pricing Relationship

| Buyer Segment | Avg. Quality | Avg. Price/kg |
|---|---:|---:|
| Commodity | 76.83 | $3.88 |
| Premium | 78.58 | $5.49 |
| Specialty | 80.78 | $9.97 |

Specialty coffee had a substantially higher average price while showing a smaller difference in average quality compared with the price difference.

**Business implication:**  
Market positioning and buyer segment appear to contribute significantly to price, creating potential opportunities to improve value capture through appropriate market positioning.

---

### 4. Processing Method Differences

| Processing Method | Avg. Quality | Avg. Price/kg |
|---|---:|---:|
| Anaerobic | 79.16 | $5.76 |
| Washed | 78.14 | $4.89 |
| Honey | 77.65 | $5.05 |
| Natural | 76.83 | $4.62 |

Anaerobic coffee had the highest average quality and price among the processing methods in the dataset.

**Business implication:**  
Processing method may influence both quality and market value and can be considered when evaluating sourcing opportunities.

---

### 5. Sensory Characteristics

The strongest relationships with overall quality were:

| Attribute | Correlation |
|---|---:|
| Flavor | 0.730 |
| Acidity | 0.700 |
| Aroma | 0.670 |
| Sweetness | 0.660 |
| Body | 0.065 |

**Business implication:**  
Flavor, acidity, aroma, and sweetness were strongly associated with the overall quality score, while body showed little relationship in this dataset.

---

### 6. Quality Regression

A multivariable regression model explained approximately **85.4%** of the variation in coffee quality.

Important associations included:

- Bean density → strong positive association
- Defect rate → strong negative association
- Altitude → statistically significant association
- Drying duration → statistically significant association
- Storage duration → statistically significant association

The model used robust HC3 standard errors because the Breusch-Pagan test indicated heteroscedasticity.

**Important:** These findings represent statistical associations and should not be interpreted as causal effects.

---

## Pricing Benchmark

A separate regression model was developed to estimate benchmark prices using:

- Coffee quality score
- Country of origin
- Processing method
- Certification
- Intended buyer segment

The model explained approximately **78.7%** of observed price variation.

Each lot was assigned an estimated benchmark price and a price gap:

> **Price Gap = Observed Price − Expected Price**

A negative gap indicates that the observed price was below the model-based benchmark.

---

## Value Opportunity

The top 25% quality threshold was **81.32**.

This identified:

- **8,761 high-quality lots**
- **2,578 strong potential opportunities**
- **29.43%** of high-quality lots were at least **10% below their benchmark price**

### Opportunity Rate by Origin

| Origin | Opportunity Rate |
|---|---:|
| Kenya | **33.33%** |
| Ethiopia | **31.16%** |
| Indonesia | **30.17%** |
| Colombia | **30.15%** |
| Vietnam | **28.46%** |
| Brazil | **26.76%** |
| Honduras | **25.94%** |

Kenya and Ethiopia had the highest rates of potential pricing opportunities among the origins analyzed.

---

## Recommended Business Actions

Based on these findings, a coffee sourcing or procurement team could:

1. **Prioritize high-quality lots with large negative price gaps** for further investigation.
2. **Pay closer attention to Kenya and Ethiopia**, which showed the highest potential opportunity rates.
3. **Consider buyer segment and market positioning** when evaluating pricing potential.
4. **Use the pricing benchmark as a screening tool** during supplier evaluation and price negotiation.
5. **Combine quality assessment with commercial information** rather than using quality score alone to evaluate value.

---

## Important Caveats

These opportunities should be treated as **screening signals, not confirmed mispricing**.

The analysis is observational and based only on variables available in the dataset. Actual market prices may also depend on factors such as contracts, timing, relationships, logistics, buyer preferences, and other unobserved factors.

"Not Recorded" certification represents missing information and should not be interpreted as lack of certification.

The pricing benchmark is intended to support further investigation rather than replace expert sourcing or market judgment.
