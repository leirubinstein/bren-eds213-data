-- EXPORTING data from a database

-- the whole database
EXPORT DATABASE 'export_adsn'; ALTER

-- one table
COPY Species TO 'species_test.csv' (HEADER, DELIMITER ',');

-- specific query
COPY (SELECT COUNT(*) FROM Species) TO 'species_count.csv' (HEADER, DELIMITER ',');

-- could also export parquet files

