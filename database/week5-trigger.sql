-- SQLite looks a lot like duckdb
.schema
.tables
SELECT * FROM Species;
.nullvalue -NULL-

-- The porblem we're going to try to fix:
INSERT INTO Species VALUES ('abcd', 'thing1', '', 'Study Species');
SELECT * FROM Species;

-- Time to create out trigger!
CREATE TRIGGER Fix_up_species
AFTER INSERT ON Species
FOR EACH ROW
BEGIN
    UPDATE Species
        SET Scientific_name = NULL
        WHERE Code = new.Code AND Scientific_name = '';
END;

-- Let's test it!
-- converts empty scientific name into -null-
INSERT INTO Species
    VALUES('efgh', 'thing2', '', 'Study species');
SELECT * FROM Species;
.schema