-- =======================================================
-- Earthquake Data Cleaning Script
-- Source: NOAA Global Significant Earthquake Database
-- Purpose: Clean and prepare earthquake data for analysis
-- Author: Cole McNabb
-- Date: March 15th, 2025
-- =======================================================

USE earthquake_;

-- =====================
-- Create backup table
-- =====================

CREATE TABLE EarthquakeData_Raw
LIKE EarthquakeData;

INSERT EarthquakeData_Raw
SELECT *
FROM EarthquakeData;

SELECT *
FROM EarthquakeData_Raw;

-- ==========================
-- Drop Unnecessary Column
-- ==========================
ALTER TABLE EarthquakeData
DROP COLUMN `Search Parameters`;


-- Fix Column names with spaces
SELECT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA  = DATABASE()
AND COLUMN_NAME LIKE '% %';


-- ==============================
-- Renaming Columns to Fix Space
-- ==============================

ALTER TABLE EarthquakeData 
	RENAME COLUMN `Damage ($Mil)` TO `Damage_Price`,
	RENAME COLUMN `Damage Description` TO `Damage_Description`,
	RENAME COLUMN `Death Description` TO `Death_Description`,
	RENAME COLUMN `Focal Depth (km)` TO `Focal_Depth_(km)`,
	RENAME COLUMN `Houses Damaged` TO `Houses_Damaged`,
	RENAME COLUMN `Houses Damaged Description` TO `Houses_Damaged_Description`,
	RENAME COLUMN `Houses Destroyed` TO `Houses_Destroyed`,
	RENAME COLUMN `Houses Destroyed Description` TO `Houses_Destroyed_Description`,
	RENAME COLUMN `Injuries Description` TO `Injuries_Description`,
	RENAME COLUMN `Location Name` TO `Location_Name`,
	RENAME COLUMN `Missing Description` TO `Missing_Description`,
	RENAME COLUMN `MMI Int` TO `MMI_Int`,
	RENAME COLUMN `Total Damage ($Mil)` TO `Total_Damage_Price`,
	RENAME COLUMN `Total Damage Description` TO `Total_Damage_Description`,
	RENAME COLUMN `Total Death Description` TO `Total_Death_Description`,
	RENAME COLUMN `Total Deaths` TO `Total_Deaths`,
	RENAME COLUMN `Total Houses Damaged` TO `Total_Houses_Damaged`,
	RENAME COLUMN `Total Houses Damaged Description` TO `Total_Houses_Damaged_Description`,
	RENAME COLUMN `Total Houses Destroyed` TO `Total_Houses_Destroyed`,
	RENAME COLUMN `Total Houses Destroyed Description` TO `Total_Houses_Destroyed_Description`,
	RENAME COLUMN `Total Injuries` TO `Total_Injuries`,
	RENAME COLUMN `Total Injuries Description` TO `Total_Injuries_Description`,
	RENAME COLUMN `Total Missing` TO `Total_Missing`,
	RENAME COLUMN `Total Missing Description` TO `Total_Missing_Description`;


-- =================================================
-- Realizing I want to convert columns to lowercase
-- =================================================

ALTER TABLE EarthquakeData 
	RENAME COLUMN Damage_Description TO damage_description,
	RENAME COLUMN Damage_Price TO damage_price,
	RENAME COLUMN Death_Description TO death_description,
	RENAME COLUMN Deaths TO deaths,
	RENAME COLUMN Dy TO dy,
	RENAME COLUMN `Focal_Depth_(km)` TO focal_depth,
	RENAME COLUMN Houses_Damaged TO houses_damaged,
	RENAME COLUMN Houses_Damaged_Description TO houses_damaged_description,
	RENAME COLUMN Houses_Destroyed TO houses_destroyed,
	RENAME COLUMN Houses_Destroyed_Description TO houses_destroyed_description,
	RENAME COLUMN Hr TO hr,
	RENAME COLUMN Injuries TO injuries,
	RENAME COLUMN Injuries_Description TO injuries_description,
	RENAME COLUMN Latitude TO latitude,
	RENAME COLUMN Location_Name TO location_name,
	RENAME COLUMN Longitude TO longitude,
	RENAME COLUMN Mag TO mag,
	RENAME COLUMN Missing TO missing,
	RENAME COLUMN Missing_Description TO missing_description,
	RENAME COLUMN MMI_Int TO mmi_int,
	RENAME COLUMN Mn TO mn,
	RENAME COLUMN Mo TO mo,
	RENAME COLUMN Sec TO sec,
	RENAME COLUMN Total_Damage_Description TO total_damage_description,
	RENAME COLUMN Total_Damage_Price TO total_damage_price,
	RENAME COLUMN Total_Death_Description TO total_death_description,
	RENAME COLUMN Total_Deaths TO total_deaths,
	RENAME COLUMN Total_Houses_Damaged TO total_houses_damaged,
	RENAME COLUMN Total_Houses_Damaged_Description TO total_houses_damaged_description,
	RENAME COLUMN Total_Houses_Destroyed TO total_houses_destroyed,
	RENAME COLUMN Total_Houses_Destroyed_Description TO total_houses_destroyed_description,
	RENAME COLUMN Total_Injuries TO total_injuries,
	RENAME COLUMN Total_Injuries_Description TO total_injuries_description,
	RENAME COLUMN Total_Missing TO total_missing,
	RENAME COLUMN Total_Missing_Description TO total_missing_description,
	RENAME COLUMN Tsu TO tsu,
	RENAME COLUMN Vol TO vol,
	RENAME COLUMN Year TO year;

-- Deleting first row of all NULL values
DELETE FROM EarthquakeData 
WHERE year IS NULL;

-- =======================
-- Drop Redundant Columns 
-- =======================
SELECT death_description, missing_description, 
	injuries_description, damage_description, 
	houses_destroyed_description, houses_damaged_description,
	total_death_description, total_missing_description,
	total_injuries_description, total_damage_description,
	total_houses_destroyed_description, total_houses_damaged_description
FROM EarthquakeData;


ALTER TABLE EarthquakeData
	DROP COLUMN death_description,
	DROP COLUMN missing_description, 
	DROP COLUMN  injuries_description,
	DROP COLUMN damage_description, 
	DROP COLUMN houses_destroyed_description, 
	DROP COLUMN houses_damaged_description,
	DROP COLUMN total_death_description, 
	DROP COLUMN  total_missing_description,
	DROP COLUMN  total_injuries_description,
	DROP COLUMN total_damage_description,
	DROP COLUMN  total_houses_destroyed_description,
	DROP COLUMN total_houses_damaged_description;

-- Forgot to drop these columns that originally linked to external webpages

ALTER TABLE EarthquakeData
	DROP COLUMN tsu,
	DROP COLUMN vol;

-- Double Check data types
SHOW FIELDS FROM EarthquakeData FROM earthquake_;

-- =============================
-- Adding Date and Time Columns
-- =============================
ALTER TABLE EarthquakeData
		ADD event_date DATE,
		ADD event_time TIME;

-- ============================
-- Update Date and Time Values
-- ============================

UPDATE EarthquakeData
SET event_time = TIME(CONCAT(hr, ":", mn, ":", sec));

UPDATE EarthquakeData
SET event_date = STR_TO_DATE(CONCAT(year, "-", mo, "-", dy), "%Y-%m-%d");

-- Adjusting the layout of table 

ALTER TABLE EarthquakeData
MODIFY event_date DATE FIRST;

ALTER TABLE EarthquakeData
MODIFY event_time TIME AFTER event_date;


-- Backup before dropping some columns

CREATE TABLE Earthquake_backup AS
SELECT *
FROM EarthquakeData;


-- Determining other columns to drop based on percentage of NULL entries

SELECT (
	(SELECT COUNT(*)
	FROM EarthquakeData WHERE missing IS NULL) *100 / 
	(SELECT COUNT(*) FROM EarthquakeData))
	as null_percentage; ## 99.22% 

SELECT (
	(SELECT COUNT(*)
	FROM EarthquakeData WHERE injuries IS NULL) *100 / 
	(SELECT COUNT(*) FROM EarthquakeData))
	as null_percentage; ## 56.37%

SELECT (
	(SELECT COUNT(*)
	FROM EarthquakeData WHERE damage_price IS NULL) *100 / 
	(SELECT COUNT(*) FROM EarthquakeData))
	as null_percentage; ## 80.67%

SELECT (
	(SELECT COUNT(*)
	FROM EarthquakeData WHERE houses_destroyed IS NULL) *100 / 
	(SELECT COUNT(*) FROM EarthquakeData))
	as null_percentage; ## 77.55%

SELECT (
	(SELECT COUNT(*)
	FROM EarthquakeData WHERE houses_damaged IS NULL) *100 / 
	(SELECT COUNT(*) FROM EarthquakeData))
	as null_percentage; ## 81.48%

SELECT (
	(SELECT COUNT(*)
	FROM EarthquakeData WHERE total_missing IS NULL) *100 / 
	(SELECT COUNT(*) FROM EarthquakeData))
	as null_percentage; ## 99.16%
	
SELECT (
	(SELECT COUNT(*)
	FROM EarthquakeData WHERE total_injuries IS NULL) *100 / 
	(SELECT COUNT(*) FROM EarthquakeData))
	as null_percentage; ## 56.02%

SELECT (
	(SELECT COUNT(*)
	FROM EarthquakeData WHERE total_damage_price IS NULL) *100 / 
	(SELECT COUNT(*) FROM EarthquakeData))
	as null_percentage; ## 80.95%

SELECT (
	(SELECT COUNT(*)
	FROM EarthquakeData WHERE total_houses_destroyed IS NULL) *100 / 
	(SELECT COUNT(*) FROM EarthquakeData))
	as null_percentage; ## 77.24%

SELECT (
	(SELECT COUNT(*)
	FROM EarthquakeData WHERE total_houses_damaged IS NULL) *100 / 
	(SELECT COUNT(*) FROM EarthquakeData))
	as null_percentage; ## 82.78%

-- ===================================================
-- Drop More Redundant and Null-Filled Columns (~75%)
-- ===================================================

ALTER TABLE EarthquakeData
	DROP COLUMN year,
	DROP COLUMN mo,
	DROP COLUMN dy,
	DROP COLUMN hr,
	DROP COLUMN mn,
	DROP COLUMN sec,
	DROP COLUMN missing,
	DROP COLUMN damage_price,
	DROP COLUMN houses_destroyed,
	DROP COLUMN houses_damaged,
	DROP COLUMN total_missing,
	DROP COLUMN total_houses_destroyed,
	DROP COLUMN total_houses_damaged,
	DROP COLUMN total_damage_price;
	

SELECT 
	event_date,
	event_time,
	location_name,
	COUNT(*) AS duplicate_search
FROM EarthquakeData
GROUP BY event_date, event_time, location_name 
HAVING COUNT(*) > 1;
	
SELECT *
FROM Earthquake_backup
WHERE event_date = '1970-05-14'
AND location_name LIKE "RUSSIA: %";

-- Realized I made a mistake adding the event_time and it set to NULL if any of the hr, mn, sec columns were NULL
-- Recreating table from Earthquake_backup then go through process agian

CREATE TABLE QuakeData AS
SELECT *
FROM Earthquake_backup;

-- Fix event_time

UPDATE QuakeData
SET event_time = 
	CASE 
		WHEN hr IS NOT NULL THEN TIME(
			CONCAT(hr, ":", IFNULL(mn,"00"), ":", IFNULL(sec,"00"))
		)
		ELSE NULL
END;

-- double check 
SELECT *
FROM QuakeData
WHERE event_date = '1970-05-14'
AND location_name LIKE "RUSSIA: %";

SELECT 
	event_date,
	event_time,
	location_name,
	COUNT(*) AS duplicate_search
FROM QuakeData
GROUP BY event_date, event_time, location_name 
HAVING COUNT(*) > 1;

DROP TABLE EarthquakeData;

-- Drop the columns again in new table


ALTER TABLE QuakeData
	DROP COLUMN year,
	DROP COLUMN mo,
	DROP COLUMN dy,
	DROP COLUMN hr,
	DROP COLUMN mn,
	DROP COLUMN sec,
	DROP COLUMN missing,
	DROP COLUMN damage_price,
	DROP COLUMN houses_destroyed,
	DROP COLUMN houses_damaged,
	DROP COLUMN total_missing,
	DROP COLUMN total_houses_destroyed,
	DROP COLUMN total_houses_damaged,
	DROP COLUMN total_damage_price;

SHOW FIELDS FROM QuakeData FROM earthquake_;

SELECT DISTINCT location_name
FROM QuakeData;

-- =================================
-- Final Cleanup and Quality Checks
-- =================================


SELECT event_date, event_time, location_name, COUNT(*) as count 
FROM QuakeData 
GROUP BY event_date, event_time, location_name 
HAVING count > 1;

-- double check for NULL values in critical columns 

SELECT 
    COUNT(*) as total_rows,
    SUM(CASE WHEN event_date IS NULL THEN 1 ELSE 0 END) as null_dates,
    SUM(CASE WHEN event_time IS NULL THEN 1 ELSE 0 END) as null_times,
    SUM(CASE WHEN latitude IS NULL THEN 1 ELSE 0 END) as null_latitudes,
    SUM(CASE WHEN longitude IS NULL THEN 1 ELSE 0 END) as null_longitudes,
    SUM(CASE WHEN mag IS NULL THEN 1 ELSE 0 END) as null_magnitudes
FROM QuakeData;

-- Looking for inconsistent entries between these columns

SELECT *
FROM QuakeData
WHERE deaths > total_deaths
   OR injuries > total_injuries;

-- Dropping the deaths and injuries column, keeping the max value from each column ( fixing 4 entries )

UPDATE QuakeData
SET 
    total_deaths = deaths,
    total_injuries = injuries
WHERE 
    deaths > total_deaths 
OR injuries > total_injuries;

ALTER TABLE QuakeData
DROP COLUMN deaths,
DROP COLUMN injuries;

SELECT DATA_TYPE, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'QuakeData';
