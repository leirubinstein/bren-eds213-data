-- Exploring why grouping by Scientific_name is not quite correct
SELECT * FROM Species LIMIT 3;

-- are there duplicate scientific names? (yes)
SELECT COUNT(*) FROM Species;
SELECT COUNT(DISTINCT Scientific_name) FROM Species;
SELECT Scientific_name, COUNT(*) AS Num_name_occurances
    FROM Species
    GROUP BY Scientific_name
    HAVING Num_name_occurances > 1;

CREATE TEMP TABLE t as (
    SELECT Scientific_name, COUNT(*) AS Num_name_occurances
        FROM Species
        GROUP BY Scientific_name
        HAVING Num_name_occurances > 1
);

SELECT * FROM t;

-- join our species table
SELECT * FROM Species s JOIN t
    ON s.Scientific_name = t.Scientific_name
    OR (s.Scientific_name IS NULL AND t.Scientific_name IS NULL);

-- inserting data

-- fragile statement (relies on a particular order to the columns)
INSERT INTO Species VALUES ('abcd', 'thing', 'scientific_name', NULL);
SELECT * FROM SPECIES;

-- you can explicilty label columns
-- more robust because we're explicity linking the things inserted to the columns
INSERT INTO Species
    (Common_name, Scientific_name, Code, Relevance)
    VALUES
    ('thing2', 'another scientific name', 'efgh', NULL);
SELECT (*) FROM Species;

-- can take advantage of default values
INSERT INTO Species
    (Common_name, Code)
    VALUES
    ('thing 3', 'ijkl');
SELECT (*) FROM Species;

-- UPDATEs and DELETEs will demolish the entire table unless limited by WHERE
-- !! Careful!! DELETE FROM Bird_eggs !!!


-- Doing a SELECT first
CREATE TABLE nest_temp AS (SELECT (*) FROM Bird_nests);
DELETE FROM nest_temp WHERE Site = 'chur';

-- other ideas
xDELETE FROM ... WHERE ...;