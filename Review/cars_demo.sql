-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%%%%%%%%% Demo:  un-comment lines (or blocks) to run: %%%%%%%%%%%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* Example schema: */
-- Car;MPG;Cylinders;Displacement;Horsepower;Weight;Acceleration;Model;Origin
-- STRING;DOUBLE;INT;DOUBLE;DOUBLE;DOUBLE;DOUBLE;INT;TEXT

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\pset footer off
\echo

/*
-- Create the table:
DROP TABLE cars;  -- Revisions, etc.

CREATE TABLE cars (
    model TEXT,
    mpg FLOAT,
    cylinders INTEGER,
    displacement FLOAT,
    horsepower FLOAT,
    weight FLOAT,
    accel FLOAT,
    year INTEGER,
    origin TEXT
);

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--  Get the data into the table: 
\COPY cars FROM './cars.csv' DELIMITER ';' CSV;
*/

-- SELECT * FROM cars LIMIT 10;

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* 
   Warm-up Questions:
   Which car has highest mpg? horsepower? accel?  Which is the heaviest?
   Let's list the top 5 and bottom 5 for each of the above.
*/

/* Default is order is Ascending.  - does not need to be specified (still a good idea, though).  */

-- Top 5 best MPG:
-- SELECT * FROM cars ORDER BY mpg LIMIT 5;
-- SELECT * FROM cars WHERE mpg <> 0 ORDER BY mpg DESC limit 5;
-- SELECT * FROM cars ORDER BY horsepower DESC limit 5;

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*  Tougher: */
/*  Which car has the best horsepower to weight ratio? */
/*
SELECT 
    *, 
    horsepower / weight AS ratio 
FROM 
    cars
;
*/

/*
SELECT 
    model, 
    (horsepower / weight)::NUMERIC(10, 4) AS hp_to_weight_ratio, 
    horsepower, 
    weight
FROM 
    cars 
ORDER BY 
    hp_to_weight_ratio DESC
LIMIT 
    10 
;
*/

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* MPG/Horsepower */
/*
SELECT 
    model,
    mpg,
    displacement,
    horsepower,
    weight,
    (mpg / horsepower)::NUMERIC(10, 4) AS mpg_ratio
FROM 
    cars 
WHERE 
    horsepower != 0 
    AND mpg <> 0 
ORDER BY 
    mpg / horsepower DESC 
LIMIT 10
;
*/

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*  Whose design is most efficient?  power/displacement   */
/*
SELECT
    *,
    (horsepower / displacement)::numeric(10, 4) AS efficiency_ratio
FROM 
    cars 
WHERE 
    displacement <> 0 
ORDER BY 
    horsepower / displacement DESC 
LIMIT 
    20
;
*/

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Average mpg & hp: */
/*
SELECT
    AVG(mpg)::numeric(10, 2) AS avg_mpg,
    MAX(mpg)::numeric(10, 2) AS max_mpg,
    MIN(mpg)::numeric(10, 2) AS min_mpg
FROM
    cars
WHERE
    mpg <> 0
;
*/

/*
SELECT
    avg(horsepower)::numeric(10, 2) AS avg_hp,
    max(horsepower)::numeric(10, 2) AS max_hp,
    min(horsepower)::numeric(10, 2) AS min_hp,
    stddev(horsepower)::numeric(10, 2) AS hp_stddev
FROM
    cars
WHERE
    mpg <> 0
    AND horsepower <> 0
;

*/

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- More powerful than 95% of cars: (presuming Std Normal Distribution - Bell curve).

/* Common Table Expression - Subquery - we will get back to this later: */


/*
SELECT 
    CAST(AVG(horsepower) + 2 * STDDEV(horsepower) AS NUMERIC(10, 2)) AS top_5_pct 
FROM 
    cars
;

SELECT 
    model, 
    horsepower 
FROM 
    cars 
WHERE 
    horsepower > (185) 
ORDER BY 
    horsepower;


-- More powerful than 95$:  Put it together:
SELECT
    model, 
    horsepower 
FROM 
    cars 
WHERE 
    horsepower > (

        SELECT 
            AVG(horsepower) + 2*STDDEV(horsepower) AS top_5_pct 
        FROM 
            cars

    ) 
ORDER BY horsepower;
*/

/*
\echo 'model,mpg,weight,horsepower'
SELECT model, mpg, weight, horsepower 
    FROM cars 
    WHERE horsepower > (SELECT AVG(horsepower) + 2*STDDEV(horsepower) FROM cars) 
    ORDER BY horsepower DESC;
*/


/*
-- CTE:
WITH threshold_table AS (
    SELECT 
        AVG(horsepower) + 2*STDDEV(horsepower) AS threshold_column
    FROM 
        cars
)

SELECT 
    model,
    horsepower
FROM
    cars 
WHERE 
    horsepower > (SELECT threshold_column FROM threshold_table) 
ORDER BY 
    horsepower --DESC
;
*/

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Fuzzy string matching: */
/*
SELECT 
    * 
FROM 
    cars 
WHERE 
    model LIKE 'chev% Impala'
;

SELECT 
    * 
FROM 
    cars 
WHERE 
    model ILIKE 'chev% Impala';  -- case insensitive 'ega'; 'Ford%';
*/

-- Are there any powerful Fords I can buy?
/*
SELECT 
    * 
FROM 
    cars 
WHERE 
    model LIKE 'Ford%' 
    AND horsepower > 180
;
*/

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* 'between' */
/*
SELECT 
    * 
FROM 
    cars 
WHERE 
    year BETWEEN 79 AND 80 
    AND horsepower BETWEEN 100 AND 130
;
*/



/* 'in' */
-- EXPLAIN
/*
SELECT 
    * 
FROM 
    cars 
WHERE 
    -- year=72 OR year=82 OR year=79
    year IN (72, 82)
    -- AND horsepower BETWEEN 190 AND 210
ORDER BY year DESC
;
*/

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* 'or' - logical operators */
/*
SELECT 
    * 
FROM 
    cars 
WHERE 
    model LIKE 'Ford%' 
    OR model LIKE 'Chevy%'
;
*/

/*
SELECT
    * 
FROM 
    cars 
WHERE 
    mpg > 15 
    AND horsepower > 200    -- Whaaaa?  We got a hit?!
;
*/


-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Correlation: - relationships.  Can you guess ? */

SELECT
    CORR(horsepower, mpg)::NUMERIC(10, 4) AS power_mpg_correlation
FROM 
    cars
;


SELECT 
    CORR(displacement, horsepower)::NUMERIC(10, 4) AS displ_power_correlation 
FROM 
    cars
;



-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*  Command-line utilities (NOT SQL !) */
/* pg_dump: Backup your databases (in SQL or text or whatever) */
-- pg_dump -d classwork -t cars -U postgres > cars_backup.sql

/* gpg encrypt (foobar) */
-- gpg --output cars_backup.sql.gpg --symmetric cars_backup.sql 

/* gpg decrypt (foobar) */
-- gpg --output cars_backup.sql --decrypt cars_backup.sql.gpg
