--Cleaning the barbers table, adding cat column

ALTER TABLE dbo.ltbarber
	ADD category VARCHAR;

--Setting all records in this column to value 'b' for barber (planning to eventually join table to cosmo table)
UPDATE dbo.ltbarber
	SET category = 'b' WHERE category IS NULL;
	
--reviewing current table, result: 24,182 rows total
SELECT * FROM dbo.ltbarber;

--Checking key columns for NULLs, checking for duplicates
SELECT * FROM dbo.ltbarber
	WHERE LICENSE_TYPE IS NULL;
	--No results for null license type
SELECT * FROM dbo.ltbarber
	WHERE LICENSE_NUMBER IS NULL;
	--No results for null license num
SELECT * FROM dbo.ltbarber
	WHERE COUNTY IS NULL;
	--41 rows with null county. All also have null bus. county but a few have bus. county code
SELECT * FROM dbo.ltbarber
	WHERE BUSINESS_COUNTY IS NULL;
	--62 rows with null bus county. some have county or county code 
SELECT 
	LICENSE_NUMBER,
	COUNT(LICENSE_NUMBER)
FROM dbo.ltbarber
GROUP BY 
	LICENSE_NUMBER
HAVING 
	COUNT (LICENSE_NUMBER) > 1;
	--result: 76 rows, meaning 76 license numbers are listed in 2 or more rows. 
	--This is more than expected, so I will take a closer look to see if they are true duplicates or if an individual can use same L# for multiple licenses.
--Select the lines for one of the license # in prev results.
SELECT * FROM dbo.ltbarber
	WHERE LICENSE_NUMBER = 236416;
	--I can see this individual clearly has 2 different licence types (Instructor and Class A) associated with the same #. Not true duplicates, will not remove anything.
--back to counties - I want to input a county name where there is only a county code.
SELECT * FROM dbo.ltbarber
	WHERE COUNTY IS NULL
	AND BUSINESS_COUNTY IS NULL
	AND BUSINESS_COUNTY_CODE IS NOT NULL;
	--5 results. County codes are 998 for all results.
	--https://comptroller.texas.gov/taxes/resources/county-codes.php to identify county from codes.
	--Can't find this county code on this website - must have different meaning.
	--Will abandon plan to use this number to fill in results.

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
	INTO cleaned_barber
	FROM dbo.ltbarber;

--review temp table:
SELECT * FROM cleaned_barber;
--saved results to file

