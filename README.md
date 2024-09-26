# US Household Income Data Processing and Analysis

This project involves cleaning and analyzing the US Household Income dataset using SQL queries. The operations include renaming columns, identifying and deleting duplicates, and performing exploratory data analysis on household income data.

## Table of Contents
- [Data Cleaning](#data-cleaning)
  - [Renaming Columns](#renaming-columns)
  - [Identifying Duplicates](#identifying-duplicates)
  - [Deleting Duplicates](#deleting-duplicates)
- [Exploratory Data Analysis](#exploratory-data-analysis)
  - [Top 10 Regions by Land and Water](#top-10-regions-by-land-and-water)
  - [Household Income Statistics](#household-income-statistics)

---

## Data Cleaning

### 1. Renaming Columns

The first step in cleaning the dataset is renaming the column with incorrect encoding:

```sql    
    ALTER TABLE us_household_income_statistics 
    RENAME COLUMN `ï»¿id` TO `id`;
```

### 2. Identifying Duplicates

We check for any duplicate records in the `us_household_income` table by counting how many times each `id` appears:

```sql
    SELECT id, COUNT(id)
    FROM us_household_income
    GROUP BY id
    HAVING COUNT(id) > 1;
```

### 3. Deleting Duplicates

To remove duplicates, we delete rows based on their `row_id`, keeping only the first occurrence for each `id`:

```sql
    DELETE FROM us_household_income
    WHERE row_id IN (
        SELECT row_id 
        FROM (
            SELECT row_id, id,
            ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
            FROM us_household_income
        ) AS duplicates
        WHERE row_num > 1
    );
```

---

## Exploratory Data Analysis

### 1. Top 10 Regions by Land and Water

This query retrieves the top 10 states by total land and water area, grouped by state and sorted by area:

```sql
    SELECT State_Name, Country, City, SUM(ALand), SUM(AWater)
    FROM us_household_income
    GROUP BY State_Name
    ORDER BY 2 DESC
    LIMIT 10;
```

### 2. Household Income Statistics

This query identifies the lowest and highest average household income per state, based on mean and median values:

```sql
    SELECT u.State_Name, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
    FROM us_household_income u
    INNER JOIN us_household_income_statistics us
        ON u.id = us.id
    WHERE Mean <> 0
    GROUP BY u.State_Name
    ORDER BY 2;
```
