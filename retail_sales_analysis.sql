CREATE DATABASE retail_analysis;

USE retail_analysis;

CREATE TABLE retail_sales (
    Order_ID VARCHAR(20),
    Order_Date DATE,
    Customer_ID VARCHAR(20),
    Customer_Name VARCHAR(100),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Product VARCHAR(100),
    Region VARCHAR(50),
    City VARCHAR(50),
    Quantity INT,
    Unit_Price DECIMAL(12,2),
    Discount DECIMAL(5,2),
    Sales DECIMAL(12,2),
    Cost DECIMAL(12,2),
    Profit DECIMAL(12,2),
    Revenue_Before_Discount DECIMAL(12,2),
    Profit_Margin DECIMAL(10,2),
    Month VARCHAR(20),
    Year INT
);

SELECT COUNT(*) AS Total_Rows
FROM retail_sales;

SELECT *
FROM retail_sales
LIMIT 10;

SELECT
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Quantity) AS Total_Quantity
FROM retail_sales;

SELECT
    Category,
    SUM(Sales) AS Total_Sales
FROM retail_sales
GROUP BY Category
ORDER BY Total_Sales DESC;

SELECT
    Category,
    SUM(Profit) AS Total_Profit
FROM retail_sales
GROUP BY Category
ORDER BY Total_Profit DESC;

SELECT
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin
FROM retail_sales
GROUP BY Category
ORDER BY Profit_Margin DESC;

SELECT
    Region,
    SUM(Sales) AS Total_Sales
FROM retail_sales
GROUP BY Region
ORDER BY Total_Sales DESC;

SELECT
    Region,
    SUM(Profit) AS Total_Profit
FROM retail_sales
GROUP BY Region
ORDER BY Total_Profit DESC;

SELECT
    Region,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin
FROM retail_sales
GROUP BY Region
ORDER BY Profit_Margin DESC;

SELECT
    Product,
    SUM(Sales) AS Total_Sales
FROM retail_sales
GROUP BY Product
ORDER BY Total_Sales DESC
LIMIT 10;

SELECT
    Product,
    SUM(Profit) AS Total_Profit
FROM retail_sales
GROUP BY Product
ORDER BY Total_Profit DESC
LIMIT 10;

SELECT
    Product,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM retail_sales
GROUP BY Product
HAVING SUM(Profit) < 5000
ORDER BY Total_Profit;

SELECT
    Customer_ID,
    Customer_Name,
    SUM(Sales) AS Total_Spending
FROM retail_sales
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Spending DESC
LIMIT 10;

SELECT
    Customer_ID,
    Customer_Name,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM retail_sales
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Orders DESC;

SELECT
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month,
    SUM(Sales) AS Total_Sales
FROM retail_sales
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Year, Month;

SELECT
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month,
    SUM(Profit) AS Total_Profit
FROM retail_sales
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Year, Month;

SELECT
    Discount,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin
FROM retail_sales
GROUP BY Discount
ORDER BY Discount;


SELECT
    Order_ID,
    Sales,
    Profit,
    CASE
        WHEN Profit >= 10000 THEN 'High Profit'
        WHEN Profit >= 5000 THEN 'Medium Profit'
        ELSE 'Low Profit'
    END AS Profit_Category
FROM retail_sales;


SELECT
    Category,
    SUM(Profit) AS Total_Profit
FROM retail_sales
GROUP BY Category
HAVING SUM(Profit) > 10000
ORDER BY Total_Profit DESC;


SELECT
    Product,
    SUM(Sales) AS Total_Sales
FROM retail_sales
GROUP BY Product
HAVING SUM(Sales) > (
    SELECT AVG(Product_Sales)
    FROM (
        SELECT
            Product,
            SUM(Sales) AS Product_Sales
        FROM retail_sales
        GROUP BY Product
    ) AS Product_Data
)
ORDER BY Total_Sales DESC;


WITH Category_Performance AS (
    SELECT
        Category,
        SUM(Sales) AS Total_Sales,
        SUM(Profit) AS Total_Profit
    FROM retail_sales
    GROUP BY Category
)
SELECT
    Category,
    Total_Sales,
    Total_Profit,
    ROUND(Total_Profit / Total_Sales * 100, 2) AS Profit_Margin
FROM Category_Performance
ORDER BY Profit_Margin DESC;


WITH Product_Sales AS (
    SELECT
        Product,
        SUM(Sales) AS Total_Sales
    FROM retail_sales
    GROUP BY Product
)
SELECT
    Product,
    Total_Sales,
    RANK() OVER (ORDER BY Total_Sales DESC) AS Sales_Rank
FROM Product_Sales
ORDER BY Sales_Rank;


WITH Monthly_Sales AS (
    SELECT
        YEAR(Order_Date) AS Year,
        MONTH(Order_Date) AS Month,
        SUM(Sales) AS Total_Sales
    FROM retail_sales
    GROUP BY YEAR(Order_Date), MONTH(Order_Date)
)
SELECT
    Year,
    Month,
    Total_Sales,
    LAG(Total_Sales) OVER (
        ORDER BY Year, Month
    ) AS Previous_Month_Sales
FROM Monthly_Sales
ORDER BY Year, Month;


WITH Product_Sales AS (
    SELECT
        Category,
        Product,
        SUM(Sales) AS Total_Sales
    FROM retail_sales
    GROUP BY Category, Product
),
Ranked_Products AS (
    SELECT
        Category,
        Product,
        Total_Sales,
        RANK() OVER (
            PARTITION BY Category
            ORDER BY Total_Sales DESC
        ) AS Product_Rank
    FROM Product_Sales
)
SELECT
    Category,
    Product,
    Total_Sales,
    Product_Rank
FROM Ranked_Products
WHERE Product_Rank <= 3
ORDER BY Category, Product_Rank;