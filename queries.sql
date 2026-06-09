-- ============================================
-- E-Commerce Retail SQL Analysis
-- Dataset: UCI Online Retail II (Kaggle)
-- ============================================

-- 1. Data Validation — confirm dataset loaded correctly
SELECT * FROM online_retail_II LIMIT 10;

-- 2. Revenue by Country — top 10 markets by total revenue
SELECT Country,
       ROUND(SUM(CAST(Quantity AS REAL) * CAST(Price AS REAL)), 2) AS Total_Revenue
FROM online_retail_II
WHERE CAST(Quantity AS REAL) > 0 AND CAST(Price AS REAL) > 0
GROUP BY Country
ORDER BY Total_Revenue DESC
LIMIT 10;

-- 3. Monthly Order Volume — order count trend over time
SELECT SUBSTR(InvoiceDate, 1, 7) AS Month,
       COUNT(DISTINCT Invoice) AS Total_Orders
FROM online_retail_II
GROUP BY SUBSTR(InvoiceDate, 1, 7)
ORDER BY Month;

-- 4. Average Order Value by Country — top 10 highest spending markets
SELECT Country,
       ROUND(AVG(CAST(Quantity AS REAL) * CAST(Price AS REAL)), 2) AS Avg_Order_Value,
       COUNT(DISTINCT Invoice) AS Total_Orders
FROM online_retail_II
WHERE CAST(Quantity AS REAL) > 0 AND CAST(Price AS REAL) > 0
GROUP BY Country
ORDER BY Avg_Order_Value DESC
LIMIT 10;

-- 5. Top 10 Best Selling Products — by total quantity sold
SELECT Description,
       SUM(CAST(Quantity AS REAL)) AS Total_Quantity_Sold
FROM online_retail_II
WHERE CAST(Quantity AS REAL) > 0
AND Description IS NOT NULL
AND Description != ''
GROUP BY Description
ORDER BY Total_Quantity_Sold DESC
LIMIT 10;

-- 6. Top 10 Revenue Generating Products — by total revenue
-- Note: Postage entries appear in results and should be excluded
-- from product-level analysis in production reporting
SELECT Description,
       ROUND(SUM(CAST(Quantity AS REAL) * CAST(Price AS REAL)), 2) AS Total_Revenue
FROM online_retail_II
WHERE CAST(Quantity AS REAL) > 0 AND CAST(Price AS REAL) > 0
AND Description IS NOT NULL
GROUP BY Description
ORDER BY Total_Revenue DESC
LIMIT 10;

-- 7. Monthly Revenue Trend — revenue and order volume over time
SELECT SUBSTR(InvoiceDate, 1, 7) AS Month,
       ROUND(SUM(CAST(Quantity AS REAL) * CAST(Price AS REAL)), 2) AS Monthly_Revenue,
       COUNT(DISTINCT Invoice) AS Total_Orders
FROM online_retail_II
WHERE CAST(Quantity AS REAL) > 0 AND CAST(Price AS REAL) > 0
GROUP BY SUBSTR(InvoiceDate, 1, 7)
ORDER BY Month;

-- 8. Cancellation Rate — proportion of orders cancelled
-- Cancelled orders identified by Invoice prefix 'C'
SELECT 
    COUNT(DISTINCT CASE WHEN Invoice LIKE 'C%' THEN Invoice END) AS Cancelled_Orders,
    COUNT(DISTINCT CASE WHEN Invoice NOT LIKE 'C%' THEN Invoice END) AS Completed_Orders,
    ROUND(COUNT(DISTINCT CASE WHEN Invoice LIKE 'C%' THEN Invoice END) * 100.0 / 
    COUNT(DISTINCT Invoice), 2) AS Cancellation_Rate_Pct
FROM online_retail_II;
