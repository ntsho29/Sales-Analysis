-- Databricks notebook source
-- FINAL CODE

CREATE OR REPLACE TABLE sales_analysis.default.sales_case_study_processed AS

WITH Raw_Data AS (
    SELECT 
        `Date`,
        `Sales`,
        `Cost Of Sales`,
        `Quantity Sold`

    FROM sales_analysis.default.sales_case_study_raw_data
),

Cleaned_Data AS (
    SELECT
    -----Date Columns---
    TO_DATE(`Date`) AS Sales_Date,
    DAYNAME(TO_DATE(`Date`)) AS Day_Name,
    DAY(TO_DATE(`Date`)) AS Day_Number,
    MONTHNAME(TO_DATE(`Date`)) AS Month_Name,
    MONTH(TO_DATE(`Date`)) AS Month_Number,
    YEAR(TO_DATE(`Date`)) AS Sale_Year,

    ---Original Sales Data---

    CAST(
        REPLACE(CAST(`Sales` AS STRING), ',','.')
        AS DECIMAL(18,2)
    )AS Sales,

    CAST(
        REPLACE(CAST(`Cost Of Sales` AS STRING), ',','.')
        AS DECIMAL(18,2)   
    ) AS Cost_Of_Sales,

    CAST(`Quantity Sold` AS INT) AS Quantity_Sold

    FROM Raw_Data
    ),
Calculated_Data AS (

    SELECT
        Sales_Date,
        Day_Name,
        Day_Number,
        Month_Name,
        Month_Number,
        Sale_Year,
        Sales,
        Cost_Of_Sales,
        Quantity_Sold,

    ---Sales Price Per Unit---

        CAST(
            ROUND(
                Sales / NULLIF(Quantity_Sold, 0),
                2
            )
            AS DECIMAL(18,2)
        ) AS Sales_Price_Per_Unit,

        -- =========================
        -- COST PER UNIT
        -- =========================

        CAST(
            ROUND(
                Cost_Of_Sales / NULLIF(Quantity_Sold, 0),
                2
            )
            AS DECIMAL(18,2)
        ) AS Cost_Per_Unit,

        -- =========================
        -- GROSS PROFIT
        -- =========================

        CAST(
            ROUND(
                Sales - Cost_Of_Sales,
                2
            )
            AS DECIMAL(18,2)
        ) AS Gross_Profit,

        -- =========================
        -- GROSS PROFIT %
        -- =========================

        CAST(
            ROUND(
                ((Sales - Cost_Of_Sales) / NULLIF(Sales, 0)) * 100,
                2
            )
            AS DECIMAL(18,2)
        ) AS Gross_Profit_Percentage,

        -- =========================
        -- GROSS PROFIT PER UNIT
        -- =========================

        CAST(
            ROUND(
                (Sales - Cost_Of_Sales)
                / NULLIF(Quantity_Sold, 0),
                2
            )
            AS DECIMAL(18,2)
        ) AS Gross_Profit_Per_Unit,

        -- =========================
        -- GROSS PROFIT % PER UNIT
        -- =========================

        CAST(
            ROUND(
                (
                    (
                        (Sales - Cost_Of_Sales)
                        / NULLIF(Quantity_Sold, 0)
                    )
                    /
                    (Sales / NULLIF(Quantity_Sold, 0))
                ) * 100,
                2
            )
            AS DECIMAL(18,2)
        ) AS Gross_Profit_Per_Unit_Percentage

    FROM Cleaned_Data
)


SELECT *
FROM Calculated_Data;

SELECT *
FROM sales_analysis.default.sales_case_study_processed
ORDER BY Sales_Date;

SELECT COUNT(*) AS Row_Count
FROM sales_analysis.default.sales_case_study_processed;

SELECT
    COUNT(*) AS row_count,
    SUM(Sales) AS total_sales,
    SUM(Cost_Of_Sales) AS total_cost,
    SUM(Quantity_Sold) AS total_quantity
FROM sales_analysis.default.sales_case_study_processed;
