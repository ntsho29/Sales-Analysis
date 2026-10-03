-- Databricks notebook source
SELECT *
FROM sales_analysis.default.sales_case_study_raw_data;

--- Calculating the Sales per unit column
SELECT 
    `Date`,
    `Sales`,
    `Cost Of Sales`,
    `Quantity Sold`,
    `Sales` / `Quantity Sold` AS Sales_Price_Per_Unit
FROM sales_analysis.default.sales_case_study_raw_data;


---- Checking the duplicates
SELECT
    `Date`,
    `Sales`,
    `Cost Of Sales`,
    `Quantity Sold`,
    COUNT(*) AS  Duplicate_Count
FROM sales_analysis.default.sales_case_study_raw_data
GROUP BY `Date`,
        `Sales`,
    `Cost Of Sales`,
    `Quantity Sold`
HAVING COUNT(*) > 1;

--- Checking Missing Values
SELECT
    COUNT(*) AS Total_Rows,
    COUNT(Date) AS Date_Values,
    COUNT(Sales) AS Sales_Values,
    COUNT(`Cost Of Sales`) AS Cost_Values,
    COUNT(`Quantity Sold`) AS Quantity_Values
FROM sales_analysis.default.sales_case_study_raw_data;

---- Check whether Cost of Sales exceeds Sales
SELECT *
FROM sales_analysis.default.sales_case_study_raw_data
WHERE `Cost Of Sales` > Sales;

-- Checking the type of data on the table

DESCRIBE TABLE sales_analysis.default.sales_case_study_raw_data;

-- Checking for invalid numbers

SELECT*
FROM sales_analysis.default.sales_case_study_raw_data
WHERE `Sales` < 0 
AND `Cost Of Sales` < 0 
AND `Quantity Sold` <= 0;


----Calculating the Cost Per Unit into 2 decimal
SELECT ROUND(
    CAST(
        REPLACE(CAST(`Cost Of Sales` AS STRING), ',', '.') AS DECIMAL(10,2)
    ) / `Quantity Sold`,
    2
) AS Cost_Per_Unit
FROM sales_analysis.default.sales_case_study_raw_data;

----Calculating the Sale Per Unit into 2 decimal
SELECT ROUND(
    CAST(
        REPLACE(CAST(`Sales` AS STRING), ',', '.') AS DECIMAL(10,2)
    ) / `Quantity Sold`,
    2
) AS Sale_Per_Unit
FROM sales_analysis.default.sales_case_study_raw_data;

----Calculating the Gross_Pofit into 2 decimal
SELECT ROUND(
    CAST(
        REPLACE(CAST(`Sales` AS STRING), ',', '.') AS DECIMAL(10,2)
    ) - `Cost Of Sales`,
    2
) AS Gross_Profit
FROM sales_analysis.default.sales_case_study_raw_data;

----Calculating the Gross Per Unit Percentage into 2 decimal
SELECT ROUND(
    CAST(
        REPLACE(CAST((`Sales` - `Cost Of Sales`) AS STRING), ',', '.') AS DECIMAL(10,2)
    ) / `Sales`,
    2
) AS Gross_Profit_Percentage
FROM sales_analysis.default.sales_case_study_raw_data;


SELECT
    Cast(`Date` AS DATE) AS Date
FROM sales_analysis.default.sales_case_study_raw_data;

