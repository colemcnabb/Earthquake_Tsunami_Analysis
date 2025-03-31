-- ===========================================================================
-- Earthquake Data Analysis
-- Source: NOAA Global Significant Earthquake Database
-- Purpose: Comprehensive analysis of earthquake patterns, impacts and trends
-- Author: Cole McNabb
-- Date: March 20th, 2025
-- ===========================================================================

USE earthquake_;

SELECT * FROM QuakeData;

-- =======================
-- 1. Time Based Analysis
-- =======================

-- 1.1 Annual Earthquake Statistics

SELECT YEAR(event_date) as Year,
	COUNT(*) AS earthquake_count,
	COUNT(CASE WHEN mag >= 7 THEN 1 END) AS major_earthquakes,
	COUNT(CASE WHEN mag BETWEEN 5 AND 6.9 THEN 1 END) AS moderate_earthquakes
FROM QuakeData
WHERE event_date IS NOT NULL
	AND mag IS NOT NULL
GROUP BY YEAR(event_date)
ORDER BY Year;

-- 1.2 Monthly Distribution

SELECT month, monthly_count, avg_mag
FROM (
	SELECT
		MONTHNAME(event_date) AS month,
		MONTH(event_date) AS month_number,
		ROUND(AVG(mag),1) as avg_mag,
		COUNT(*) AS monthly_count
	FROM QuakeData
	WHERE event_date IS NOT NULL
	GROUP BY MONTHNAME(event_date), MONTH(event_date)
) AS sub_q
ORDER BY month_number ASC;

-- 1.3 Decade Trends

SELECT
	(YEAR(event_date) DIV 10) * 10 AS decade,
	COUNT(*) AS earthquake_count
FROM QuakeData
WHERE event_date IS NOT NULL
GROUP BY decade
ORDER BY decade;

-- =========================
-- 2. Geographical Analysis
-- =========================

-- 2.1 High-magnitude locations

SELECT  event_date, event_time, location_name, mag,
	CASE
		WHEN mag BETWEEN 7 AND 7.9 THEN 'Major'
		WHEN mag >= 8 THEN 'Great'
		ELSE 'Other'
	END AS quake_level, 
	latitude, longitude
FROM QuakeData
WHERE mag >= 7
ORDER BY event_date;

-- ===================
-- 3. Impact Analysis
-- ===================

-- 3.1 Magnitude-Impact Correlation

SELECT mag, SUM(total_deaths) as total_deaths
FROM QuakeData
WHERE mag IS NOT NULL
	AND total_deaths IS NOT NULL
GROUP BY mag
ORDER BY mag DESC, total_deaths DESC;

-- 3.2 Average Impact by Magnitude

SELECT mag, CEILING(AVG(total_deaths)) AS avg_deaths,
	COUNT(*) AS quake_count
FROM QuakeData
WHERE mag IS NOT NULL 
	AND total_deaths IS NOT NULL
GROUP BY mag
ORDER BY mag DESC, avg_deaths DESC;

-- 3.3 Most Significant Earthquakes

SELECT total_deaths,location_name, mag, event_date, event_time, latitude, longitude
FROM QuakeData
WHERE total_deaths IS NOT NULL
ORDER BY total_deaths DESC
LIMIT 10;

-- 3.4 Annual Impact Assessment

SELECT 
	YEAR(event_date) AS Year, 
	SUM(total_deaths) AS death_count,
	COUNT(*) AS earthquake_count
FROM QuakeData
WHERE total_deaths IS NOT NULL
AND event_date IS NOT NULL
GROUP BY YEAR(event_date)
ORDER BY death_count DESC;

