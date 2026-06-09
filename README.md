# E-Commerce Retail SQL Analysis

## Overview
SQL analysis of the UCI Online Retail II dataset covering 500,000+ transactions from a UK-based online retailer (2010–2011). The analysis explores revenue performance, customer behaviour across markets, product trends, and order quality — mirroring the kind of commercial analytics work done in e-commerce data science roles.

**Tools used:** SQL (SQLite), Excel  
**Dataset:** [UCI Online Retail II — Kaggle](https://www.kaggle.com/datasets/mashlyn/online-retail-ii-uci)  
**Records analysed:** 541,910 transactions across 38 countries

---

## Business Questions Answered

### 1. Which countries generate the most revenue?
**Finding:** The UK dominates total revenue as the home market. Netherlands and EIRE (Ireland) are the strongest international markets by total revenue.

```sql
SELECT Country,
       ROUND(SUM(CAST(Quantity AS REAL) * CAST(Price AS REAL)), 2) AS Total_Revenue
FROM online_retail_II
WHERE CAST(Quantity AS REAL) > 0 AND CAST(Price AS REAL) > 0
GROUP BY Country
ORDER BY Total_Revenue DESC
LIMIT 10
```

---

### 2. Which countries have the highest average order value?
**Finding:** Netherlands, Australia, and Japan have the highest AOV despite not all appearing in the top revenue countries — indicating small but high-spending international markets with strong monetisation potential.

```sql
SELECT Country,
       ROUND(AVG(CAST(Quantity AS REAL) * CAST(Price AS REAL)), 2) AS Avg_Order_Value,
       COUNT(DISTINCT Invoice) AS Total_Orders
FROM online_retail_II
WHERE CAST(Quantity AS REAL) > 0 AND CAST(Price AS REAL) > 0
GROUP BY Country
ORDER BY Avg_Order_Value DESC
LIMIT 10
```

---

### 3. What are the top 10 best selling products by volume?
**Finding:** Paper Craft Little Birdie and Medium Ceramic Top Storage Jar lead by volume — high frequency, low unit price items driving transaction count.

```sql
SELECT Description,
       SUM(CAST(Quantity AS REAL)) AS Total_Quantity_Sold
FROM online_retail_II
WHERE CAST(Quantity AS REAL) > 0
AND Description IS NOT NULL
AND Description != ''
GROUP BY Description
ORDER BY Total_Quantity_Sold DESC
LIMIT 10
```

---

### 4. What are the top 10 products by revenue?
**Finding:** The volume and revenue lists tell different stories. Regency Cakestand 3 Tier generates £174k revenue without appearing in the volume top 10 — a high unit price product. Paper Craft Little Birdie appears in both lists, making it the strongest overall product. Postage entries appear in the revenue list and should be excluded from product-level analysis — a data quality consideration.

```sql
SELECT Description,
       ROUND(SUM(CAST(Quantity AS REAL) * CAST(Price AS REAL)), 2) AS Total_Revenue
FROM online_retail_II
WHERE CAST(Quantity AS REAL) > 0 AND CAST(Price AS REAL) > 0
AND Description IS NOT NULL
GROUP BY Description
ORDER BY Total_Revenue DESC
LIMIT 10
```

---

### 5. What is the order cancellation rate?
**Finding:** 14.81% cancellation rate — 3,836 cancelled orders out of 25,900 total. Nearly 1 in 7 orders is cancelled, which is high for e-commerce and would warrant further investigation into cancellation drivers, repeat cancellers, and product-level cancellation patterns.

```sql
SELECT 
    COUNT(DISTINCT CASE WHEN Invoice LIKE 'C%' THEN Invoice END) AS Cancelled_Orders,
    COUNT(DISTINCT CASE WHEN Invoice NOT LIKE 'C%' THEN Invoice END) AS Completed_Orders,
    ROUND(COUNT(DISTINCT CASE WHEN Invoice LIKE 'C%' THEN Invoice END) * 100.0 / 
    COUNT(DISTINCT Invoice), 2) AS Cancellation_Rate_Pct
FROM online_retail_II
```

---

## Key Insights Summary

| Finding | Detail |
|---|---|
| UK dominates revenue | Home market accounts for the majority of total revenue |
| Netherlands is a standout market | Appears in both top revenue AND top AOV — high value and high spending |
| Australia and Japan | High AOV despite low order volume — untapped high-value markets |
| Volume ≠ Revenue | Top selling products by quantity are not the same as top revenue generators |
| Paper Craft Little Birdie | Only product appearing in both top volume and top revenue lists — strongest overall performer |
| 14.81% cancellation rate | Significantly high — commercial risk requiring investigation |
| Postage in revenue data | Non-product entries inflate revenue figures — data cleaning required before reporting |

---

## Data Quality Notes
- Postage and shipping charges appear as product descriptions and should be excluded from product-level analysis
- InvoiceDate format required handling for time-series grouping
- Cancelled orders identified via Invoice prefix "C" — negative quantities confirm reversals

---

## Next Steps
- Power BI dashboard visualising revenue by country, product performance, and monthly trends
- Cancellation deep-dive — which products, countries, and customer segments have highest cancellation rates
- Customer segmentation using RFM analysis (Recency, Frequency, Monetary value)
