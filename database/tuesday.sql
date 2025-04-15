.table

-- There are lots of "dot-commands" in DuckDB
.help
.help show
.show
-- .exit witll exit DuckDB, or ctrl-D
-- terminal uses DuckDB directly

-- Start with SQL
SELECT * FROM Site;
-- SQL is case-insensitive, but uppercase is the tradition
select * from Site;

-- a multi-line statement
SELECT *
    FROM Site;
-- select the whole statement when running in vscode

-- can be combined with OFFSET clause
SELECT * FROM Site
    LIMIT 3
    OFFSET 3;

-- selecting distinct items
SELECT * FROM Bird_nests LIMIT 1;
SELECT Species FROM Bird_nests;
SELECT distinct Species FROM Bird_nests;

-- distinct combos of species and observer
SELECT distinct Species, Observer FROM Bird_nests;

-- add ordering 
SELECT distinct Species, Observer 
    FROM Bird_nests
    ORDER BY Species;

SELECT distinct Species, Observer 
    FROM Bird_nests
    ORDER BY Species, Observer DESC;

-- look at site table
SELECT * FROM Site;

-- Select distinct locations from the Site table
-- Are they returned in order? if not, order them
SELECT distinct Location
    FROM Site
    ORDER BY Location;

-- Add a LIMIT clause to return just 3 results
-- Q: Was the LIMIT applies before the results were ordered, or after?
SELECT distinct Location
    FROM Site
    ORDER BY Location
    LIMIT 3;


