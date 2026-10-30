CREATE DATABASE Regional_Growth_Analysis;
USE Regional_Growth_Analysis;

SELECT DB_NAME() AS Current_Database;

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

SELECT TOP 10 *
FROM dbo.[Sample - Superstore];

SELECT COUNT(*) AS Total_Records
FROM dbo.[Sample - Superstore];

SELECT
    Region,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    COUNT(*) AS Total_Orders
FROM dbo.[Sample - Superstore]
GROUP BY Region
ORDER BY Total_Sales DESC;

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Sample - Superstore'
ORDER BY ORDINAL_POSITION;

SELECT
    Region,
    YEAR(Order_Date) AS Sales_Year,
    MONTH(Order_Date) AS Sales_Month,
    SUM(Sales) AS Monthly_Sales
FROM dbo.[Sample - Superstore]
GROUP BY
    Region,
    YEAR(Order_Date),
    MONTH(Order_Date)
ORDER BY
    Sales_Year,
    Sales_Month,
    Region;

WITH MonthlySales AS
(
    SELECT
        Region,
        DATEFROMPARTS(
            YEAR(Order_Date),
            MONTH(Order_Date),
            1
        ) AS Sales_Month,
        SUM(Sales) AS Monthly_Sales
    FROM dbo.[Sample - Superstore]
    GROUP BY
        Region,
        YEAR(Order_Date),
        MONTH(Order_Date)
),
GrowthAnalysis AS
(
    SELECT
        Region,
        Sales_Month,
        Monthly_Sales,
        LAG(Monthly_Sales) OVER
        (
            PARTITION BY Region
            ORDER BY Sales_Month
        ) AS Previous_Month_Sales
    FROM MonthlySales
)
SELECT
    Region,
    Sales_Month,
    Monthly_Sales,
    Previous_Month_Sales,
    ROUND(
        (Monthly_Sales - Previous_Month_Sales)
        * 100.0 / NULLIF(Previous_Month_Sales, 0),
        2
    ) AS Growth_Percentage
FROM GrowthAnalysis
ORDER BY Region, Sales_Month;

SELECT
    Region,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM dbo.[Sample - Superstore]
GROUP BY Region
ORDER BY Total_Sales DESC;

