--uising UNION to combine the 2 tables into a single temp table


SELECT * INTO combined_licenses
FROM cleaned_barber
	UNION
SELECT * FROM cleaned_cosmo

SELECT * FROM combined_licenses;
--309,850 total rows in combined table. saved results to csv.
--Will load saved results into Tableau to visualize map of licenses.
