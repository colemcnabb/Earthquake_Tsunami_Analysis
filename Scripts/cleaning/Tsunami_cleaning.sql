-- ====================================================
-- Tsunami Data Cleaning Script
-- Source: NOAA Global Significant Tsunami Database
-- Purpose: Clean and prepare tsunami data for analysis
-- Author: Cole McNabb
-- Date: March 15th, 2025
-- ====================================================

USE earthquake_;

-- ========================
-- Drop Unnecessary Column
-- ========================

ALTER TABLE TsunamiData
	DROP COLUMN `Search Parameters`;

DELETE FROM TsunamiData
WHERE Year IS NULL;

-- =======================
-- Drop Redundant Columns 
-- =======================

ALTER TABLE TsunamiData 
	DROP COLUMN `Damage ($Mil)`,
	DROP COLUMN `Damage Description`,
	DROP COLUMN `Death Description`,
	DROP COLUMN `Deposits`,
	DROP COLUMN `Houses Damaged`,
	DROP COLUMN `Houses Damaged Description`,
	DROP COLUMN `Houses Destroyed`,
	DROP COLUMN `Houses Destroyed Description`,
	DROP COLUMN `Injuries Description`,
	DROP COLUMN `Missing Description`,
	DROP COLUMN `More Info`,
	DROP COLUMN `Total Damage ($Mil)`,
	DROP COLUMN `Total Damage Description`,
	DROP COLUMN `Total Death Description`,
	DROP COLUMN `Total Houses Damaged`,
	DROP COLUMN `Total Houses Damaged Description`,
	DROP COLUMN `Total Houses Destroyed`,
	DROP COLUMN `Total Houses Destroyed Description`,
	DROP COLUMN `Total Injuries Description`,
	DROP COLUMN `Total Missing`,
	DROP COLUMN `Total Missing Description`;

ALTER TABLE TsunamiData DROP COLUMN Vol;

-- =============================
-- Adding Date and Time Columns
-- =============================

ALTER TABLE TsunamiData
	ADD event_date DATE,
	ADD event_time TIME;

-- ============================
-- Update Date and Time Values
-- ============================

UPDATE TsunamiData
	SET event_date = STR_TO_DATE(CONCAT(Year, "-", Mo, "-", Dy), "%Y-%m-%d");

UPDATE TsunamiData
SET event_time = 
	CASE 
		WHEN Hr IS NOT NULL THEN TIME(
			CONCAT(Hr, ":", IFNULL(Mn,"00"), ":", IFNULL(Sec,"00"))
		)
		ELSE NULL
END;

ALTER TABLE TsunamiData
	MODIFY event_date DATE FIRST,
	MODIFY event_time TIME AFTER event_date;

-- ====================
-- Create backup table
-- ====================

CREATE TABLE Tsunami_backup AS
SELECT * 
FROM TsunamiData;

-- =================
-- Fix Column Names
-- =================

ALTER TABLE TsunamiData 
	RENAME COLUMN `Country` TO country,
	RENAME COLUMN `Deaths` TO deaths,
	RENAME COLUMN `Dy` TO dy,
	RENAME COLUMN `Earthquake Magnitude` TO earthquake_magnitude,
	RENAME COLUMN `event_date` TO event_date,
	RENAME COLUMN `event_time` TO event_time,
	RENAME COLUMN `Hr` TO hr,
	RENAME COLUMN `Injuries` TO injuries,
	RENAME COLUMN `Latitude` TO latitude,
	RENAME COLUMN `Location Name` TO location_name,
	RENAME COLUMN `Longitude` TO longitude,
	RENAME COLUMN `Maximum Water Height (m)` TO maximum_water_height,
	RENAME COLUMN `Missing` TO missing,
	RENAME COLUMN `Mn` TO mn,
	RENAME COLUMN `Mo` TO mo,
	RENAME COLUMN `Number of Runups` TO number_of_runups,
	RENAME COLUMN `Sec` TO sec,
	RENAME COLUMN `Total Deaths` TO total_deaths,
	RENAME COLUMN `Total Injuries` TO total_injuries,
	RENAME COLUMN `Tsunami Cause Code` TO tsunami_cause_code,
	RENAME COLUMN `Tsunami Event Validity` TO tsunami_event_validity,
	RENAME COLUMN `Tsunami Intensity` TO tsunami_intensity,
	RENAME COLUMN `Tsunami Magnitude (Abe)` TO tsunami_magnitude_abe,
	RENAME COLUMN `Tsunami Magnitude (Iida)` TO tsunami_magnitude_iida,
	RENAME COLUMN `Year` TO year;

-- Determine if any other columns consist of ~75% NULL entries

SELECT (
	(SELECT COUNT(*)
	FROM TsunamiData WHERE missing IS NULL) *100 / 
	(SELECT COUNT(*) FROM TsunamiData))
	as null_percentage; ## 99.38% 

SELECT (
	(SELECT COUNT(*)
	FROM TsunamiData WHERE tsunami_magnitude_iida IS NULL) *100 / 
	(SELECT COUNT(*) FROM TsunamiData))
	as null_percentage; ## 72.00%

SELECT (
	(SELECT COUNT(*)
	FROM TsunamiData WHERE tsunami_magnitude_abe IS NULL) *100 / 
	(SELECT COUNT(*) FROM TsunamiData))
	as null_percentage; ## 99.90%
	
SELECT (
	(SELECT COUNT(*)
	FROM TsunamiData WHERE earthquake_magnitude IS NULL) *100 / 
	(SELECT COUNT(*) FROM TsunamiData))
	as null_percentage; ## 22.48%
	
SELECT (
	(SELECT COUNT(*)
	FROM TsunamiData WHERE deaths IS NULL) *100 / 
	(SELECT COUNT(*) FROM TsunamiData))
	as null_percentage; ## 89.07%

SELECT (
	(SELECT COUNT(*)
	FROM TsunamiData WHERE injuries IS NULL) *100 / 
	(SELECT COUNT(*) FROM TsunamiData))
	as null_percentage; ## 94.79

SELECT (
	(SELECT COUNT(*)
	FROM TsunamiData WHERE total_injuries IS NULL) *100 / 
	(SELECT COUNT(*) FROM TsunamiData))
	as null_percentage; ## 74.82%
	
SELECT (
	(SELECT COUNT(*)
	FROM TsunamiData WHERE total_deaths IS NULL) *100 / 
	(SELECT COUNT(*) FROM TsunamiData))
	as null_percentage; ## 70.76%
	
SELECT (
	(SELECT COUNT(*)
	FROM TsunamiData WHERE tsunami_intensity IS NULL) *100 / 
	(SELECT COUNT(*) FROM TsunamiData))
	as null_percentage; ## 73.26%
	
SHOW FIELDS FROM TsunamiData FROM earthquake_;

CREATE TABLE Tsunami_backup_final AS
SELECT *
FROM TsunamiData;


-- ===================================================
-- Drop More Redundant and Null-Filled Columns (~75%)
-- ===================================================

ALTER TABLE TsunamiData
	DROP COLUMN tsunami_magnitude_abe,
	DROP COLUMN tsunami_magnitude_iida,
	DROP COLUMN tsunami_intensity,
	DROP COLUMN missing,
	DROP COLUMN year,
	DROP COLUMN mo,
	DROP COLUMN dy,
	DROP COLUMN hr,
	DROP COLUMN mn,
	DROP COLUMN sec;

-- Organizing similar to the Earthquake data table

ALTER TABLE TsunamiData
	MODIFY country VARCHAR(50) AFTER event_time,
	MODIFY location_name VARCHAR(50) AFTER country,
	MODIFY latitude DOUBLE AFTER location_name,
	MODIFY longitude DOUBLE AFTER latitude;

-- Checking for duplicates

SELECT event_date, event_time, location_name, COUNT(*) as count 
FROM TsunamiData 
GROUP BY event_date, event_time, location_name 
HAVING count > 1;

-- Null values in important columns 

SELECT 
    COUNT(*) as total_rows,
    SUM(CASE WHEN event_date IS NULL THEN 1 ELSE 0 END) as null_dates,
    SUM(CASE WHEN event_time IS NULL THEN 1 ELSE 0 END) as null_times,
    SUM(CASE WHEN latitude IS NULL THEN 1 ELSE 0 END) as null_latitudes,
    SUM(CASE WHEN longitude IS NULL THEN 1 ELSE 0 END) as null_longitudes,
    SUM(CASE WHEN earthquake_magnitude IS NULL THEN 1 ELSE 0 END) as null_magnitudes
FROM TsunamiData;

-- Checking for same issues as present in earthquake data

SELECT *
FROM TsunamiData
WHERE deaths > total_deaths 
   OR injuries > total_injuries;

-- No inconsistencies here, but dropping columns to keep similarity between datsets

ALTER TABLE TsunamiData
DROP COLUMN deaths,
DROP COLUMN injuries;




	

