--Next, I will clean the Cosmetology file. Will follow many of the same steps as barber.
ALTER TABLE dbo.ltcosmos
	ADD category VARCHAR;

--Setting all records in this column to value 'c' for cosmetologist (planning to eventually combine table to barber table)
UPDATE dbo.ltcosmos
	SET category = 'c' WHERE category IS NULL;

--reviewing current table, result: 285,668 rows total
SELECT * FROM dbo.ltcosmos;

--Checking key columns for NULLs, checking for duplicates
SELECT * FROM dbo.ltcosmos
	WHERE LICENSE_TYPE IS NULL;
	--No results for null license type
SELECT * FROM dbo.ltcosmos
	WHERE LICENSE_NUMBER IS NULL;
	--No results for null license num
SELECT * FROM dbo.ltcosmos
	WHERE COUNTY IS NULL
	AND BUSINESS_COUNTY IS NULL;
	--1,029 rows with null county and null business county. 

SELECT 
	LICENSE_NUMBER,
	COUNT(LICENSE_NUMBER)
FROM dbo.ltcosmos
GROUP BY 
	LICENSE_NUMBER
HAVING 
	COUNT (LICENSE_NUMBER) > 1;
	--result: only 1 row - will review this lic# closer 
--Select the lines for the license # in prev results.
SELECT * FROM dbo.ltcosmos
	WHERE LICENSE_NUMBER = 1801418;
	--I can see this individual clearly has 2 different licence types (Cos Operator & Cos Esthetician) associated with the same #. Not true duplicates, will not remove anything.

--Creating New Temp Table with only columns I care to keep for future combined table
	--Will attempt to fill in Missing County when Business County is present
	SELECT
		category,
		LICENSE_NUMBER AS license_number,
		LICENSE_TYPE AS license_type,
		LICENSE_SUBTYPE AS license_subtype,
		LICENSE_EXPIRATION_DATE AS license_expiration_date,
		CONTINUING_EDUCATION_FLAG AS continuing_education_flag,
		COALESCE (COUNTY, BUSINESS_COUNTY) AS county
	INTO cleaned_cosmo
	FROM dbo.ltcosmos;

--review temp table:
SELECT * FROM cleaned_cosmo;
--saved results to file