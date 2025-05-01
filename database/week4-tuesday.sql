.table

-- We can nest queries
SELECT Scientific_name, Nest_count FROM
    (SELECT Species, COUNT(*) AS Nest_count FROM Bird_nests
        ORDER BY Species
        LIMIT 2) JOIN Species
        ordering

-- Outer joins
CREATE TEMP TABLE a (
    cola INTEGER,
    common INTEGER
);
INSERT INTO a VALUES (1,1), (2,2), (3,3);
SELECT * FROM a;
CREATE TEMP TABLE b (
    common INTEGER,
    colb INTEGER
);
INSERT INTO b values (2,2), (3,3), (4,4), (5,5);
SELECT * FROM b;

-- The joins we've been doing so far have been "inner" joins
SELECT * FROM a JOIN b USING (common);
SELECT * FROM a JOIN b ON a.common = b.common;

-- By doing an "outer" join --- either "left" or "right" --- we'll add certain missing rows
SELECT * FROM a LEFT JOIN b ON a.common = b.common;
SELECT * FROM a RIGHT JOIN b ON a.common = b.common;

-- A running example: What species do *not* have any nest data?
SELECT COUNT(*) FROM Species;
SELECT COUNT(DISTINCT Species) FROM Bird_nests;

-- METHOD 1 
-- (more efficient): went through entire table and found list of 19, and then went to the bird nest table and asked if it was in the list of 19 species
SELECT Code FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);
-- (less efficient): compared each species against whole list
SELECT Code FROM Species
    WHERE Code NOT IN (SELECT Species FROM Bird_nests);

-- METHOD 2
-- Get every row in the species table whether or not there is a bird nest. Can see that there are NULL values at end
SELECT Code, Species FROM Species LEFT JOIN Bird_nests
    ON Code = Species;
-- gives rows that are NULL only
SELECT Code, Species FROM Species LEFT JOIN Bird_nests
    ON Code = Species
    WHERE Species IS NULL;

-- It's also possible to join a table with itself, a so-called "self-join"

-- Understanding a limitation of duckdb

-- imagine that we want to count the number of bird eggs in each nest
-- grouped the bird nest table with the bird eggs table, goruped by nest
-- count* counts the number of rows, which would be the number of eggs
SELECT Nest_ID, COUNT(*) AS Num_eggs
    FROM Bird_nests JOIN Bird_eggs
    USING (Nest_ID)
    WHERE Nest_ID LIKE '13B%'
    GROUP BY Nest_ID;

-- Let's add in Observer: this will give an error that says observer must appear in the GROUP BY clause
SELECT Nest_ID, Observer, COUNT(*) AS Num_eggs
    FROM Bird_nests JOIN Bird_eggs
    USING (Nest_ID)
    WHERE Nest_ID LIKE '13B%' -- limiting to anything that starts with "13B"
    GROUP BY Nest_ID;

-- SQL will join first and then do the grouping 
SELECT * FROM Bird_nests JOIN Bird_eggs
    USING (Nest_ID)
    WHERE Nest_ID LIKE '13B%';
-- output of this - first 4 rows will form a group since they all have the same Nest_ID
-- Nest_ID is special because it's a primary key
-- we grouped by the primary key

-- duckdb solution #1:
SELECT Nest_ID, Observer, COUNT(*) AS Num_eggs
    FROM Bird_nests JOIN Bird_eggs
    USING (Nest_ID)
    WHERE Nest_ID LIKE '13B%'
    GROUP BY Nest_ID, Observer;

-- duckdb solution #2: just ask for any value from Observer since they're all the same
SELECT Nest_ID, ANY_VALUE(Observer) AS Observer, COUNT(*) AS Num_eggs -- rename column from 'any_value(Observer)' to 'Observer' 
    FROM Bird_nests JOIN Bird_eggs
    USING (Nest_ID)
    WHERE Nest_ID LIKE '13B%'
    GROUP BY Nest_ID;

-- Create a view
CREATE VIEW my_nests AS 
    SELECT Nest_ID, ANY_VALUE(Observer) AS Observer, COUNT(*) AS Num_eggs
    FROM Bird_nests JOIN Bird_eggs
    USING (Nest_ID)
    WHERE Nest_ID LIKE '13B%'
    GROUP BY Nest_ID;

.table

SELECT * FROM my_nests;
SELECT Nest_ID, Name, Num_eggs
    FROM my_nests JOIN Personnel
    ON Observer = Abbreviation;

-- Views vs. temp tables
-- views are always virtual, temp tables are actually made
-- if something is really computationally expensive and you want to cache the results, then create a temp table
-- views are good for convienience/cleaning
CREATE TEMP TABLE my_nests_temp_table AS
    SELECT Nest_ID, ANY_VALUE(Observer) AS Observer, COUNT(*) AS Num_eggs
    FROM Bird_nests JOIN Bird_eggs
    USING (Nest_ID)
    WHERE Nest_ID LIKE '13B%'
    GROUP BY Nest_ID;

.table

-- What about modifications (inserts, updates, deletes) on a view? Possible?
-- It depends:
--- Whether it's theoretically possible
--- How smart the database is

-- last topi: set operations
-- UNION, UNION ALL, INTERSECT, EXCEPT

-- imagine a scenario where the observer accidentally recorded egg dimensions in inches instead of mm for this subset
SELECT * FROM Bird_eggs LIMIT 5;

-- adjust measurements where book page is b14
SELECT Book_page, Year, Site, Nest_ID, Egg_num, Length*25.4 AS Length, Width*25.4 AS Width 
    FROM Bird_eggs
    WHERE Book_page LIKE 'b14%'
UNION
SELECT Book_page, Year, Site, Nest_ID, Egg_num, Length, Width
    FROM Bird_eggs
    WHERE Book_page NOT LIKE 'b14%'; -- keep same where pages aren't b14

-- METHOD 3
-- running example of species not in bird nest table
SELECT Code FROM Species
EXCEPT
SELECT DISTINCT Species FROM Bird_nests;
