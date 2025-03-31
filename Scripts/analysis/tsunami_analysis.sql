-- ===========================================================================
-- Tsunami Data Analysis
-- Source: NOAA Global Historical Tsunami Database
-- Purpose: Comprehensive analysis of tsunami patterns, impacts and trends
-- Author: Cole McNabb
-- Date: March 20th, 2025
-- ===========================================================================

USE earthquake_;

-- =======================
-- 1. Time Based Analysis
-- =======================

-- 1.1 Annual Tsunami Statistics

SELECT
	YEAR(event_date) AS Year,
	COUNT(*) AS tsunami_count
FROM TsunamiData
WHERE tsunami_event_validity > 2 -- Anything over 2 indicates probable tsunami
AND event_date IS NOT NULL
GROUP BY YEAR(event_date)
ORDER BY Year;

-- 1.2 Monthly Distribution

SELECT month, monthly_count
FROM (
	SELECT
		MONTHNAME(event_date) AS month,
		MONTH(event_date) AS month_number,
		COUNT(*) AS monthly_count
	FROM TsunamiData
	WHERE event_date IS NOT NULL
	AND tsunami_event_validity > 2
	GROUP BY MONTHNAME(event_date), MONTH(event_date)
) AS sub_q
ORDER BY month_number ASC;

-- 1.3 Tsunami Cause Code Total

SELECT tsunami_cause_code,
	COUNT(*) AS code_total
FROM TsunamiData
WHERE event_date IS NOT NULL
GROUP BY tsunami_cause_code
ORDER BY code_total DESC;

-- 1.4 Detailed Tsunami Cause Code Statistics 

SELECT 
	tsunami_cause_code, 
	COUNT(*) AS event_total,
	SUM(total_deaths) AS deaths_per_code,
	CEILING(AVG(total_deaths)) AS avg_deaths_per_code
FROM TsunamiData
WHERE event_date IS NOT NULL
AND total_deaths IS NOT NULL
GROUP BY tsunami_cause_code
ORDER BY deaths_per_code DESC;

-- =========================
-- 2. Geographical Analysis
-- =========================

-- 2.1 Highly Affected Areas

SELECT country,
	COUNT(*) AS event_count,
	SUM(total_deaths) as deaths_per_country,
	CEILING(AVG(total_deaths)) AS avg_deaths_per_country
FROM TsunamiData
WHERE event_date IS NOT NULL 
AND total_deaths IS NOT NULL
GROUP BY country
ORDER BY event_count DESC, avg_deaths_per_country DESC; 

-- 2.2 Wave Height Statistics

SELECT
	YEAR(event_date) AS Year,
	ROUND(AVG(maximum_water_height),2) AS avg_water_height, ## Measured in Metres
	MAX(maximum_water_height) AS max_water_height,
	MIN(maximum_water_height) AS min_water_height
FROM TsunamiData
WHERE maximum_water_height IS NOT NULL
AND event_date IS NOT NULL
GROUP BY YEAR(event_date)
ORDER BY Year ASC;

-- ===================
-- 3. Impact Analysis
-- ===================

-- 3.1 Impact by Tsunami Cause Code

SELECT tsunami_cause_code, 
	SUM(total_deaths) AS deaths_by_code
FROM TsunamiData
WHERE total_deaths IS NOT NULL
GROUP BY tsunami_cause_code
ORDER BY deaths_by_code DESC;

-- 3.2 Most Significant Tsunamis

SELECT country, location_name, total_deaths, event_date, event_time, latitude, longitude
FROM TsunamiData
WHERE total_deaths IS NOT NULL
ORDER BY total_deaths DESC
LIMIT 10;

-- 3.3 Impact by Tsunami Category

SELECT
	CASE
		WHEN maximum_water_height < 3 THEN 'small_tsunami'
		WHEN maximum_water_height BETWEEN 3 AND 10 THEN 'destructive_tsunami'
		WHEN maximum_water_height > 10 THEN 'mega_tsunami'
	END as tsunami_category,
	SUM(total_deaths) AS deaths_per_type,
	COUNT(*) AS tsunami_count
FROM TsunamiData
WHERE maximum_water_height IS NOT NULL
AND total_deaths IS NOT NULL
GROUP BY tsunami_category 
ORDER BY deaths_per_type DESC;


