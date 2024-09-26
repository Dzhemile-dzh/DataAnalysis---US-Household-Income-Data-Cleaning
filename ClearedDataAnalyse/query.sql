#US Household Income Data Cleaning

## Rename column
ALTER TABLE us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;

## Identify the duplicates
SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1;

##Delete the duplicates
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

#US Household Exploratory Data Analysis

## TOP 10, The first and the least on water by lands, filtering by states
SELECT State_Name, Country, City, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;

## Household statistics, lowest and haighest average household income 
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_household_income u 
INNER JOIN us_household_income_statistics us
	ON u.id  = us.id
WHERE Mean <> 0 
GROUP BY u.State_Name
ORDER BY 2
;
    