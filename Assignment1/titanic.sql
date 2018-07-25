/*
    CSC 336 - Database Systems - Assn 1:

%%%%%%%%%% Overview: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Passengers on the Titanic:
        1,503 people died on the Titanic.
        - around 900 were passnegers,
        - the rest were crew members.

    This is a list of what we know about the passengers.
    Some lists show 1,317 passengers,
        some show 1,313 - so these numbers are not exact,
        but they will be close enough that we can spot trends and correlations.

    Lets' answer some questions about the passengers' survival data:


%%%%%%%%%% Techical Help: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    How to create a database (if we don't already have one).

        For PostgreSQL: (from within psql).

            $ psql -U postgres
            # CREATE DATABASE <database_name>;

        For SQLite:  (from command line - outside of sqlite3).
            $ touch titanic.db

    Running SQL Scripts:

        Put your .csv file in the current working directory.
        Open and edit your .sql file in the SAME directory.
        Navigate to that directory from the command-line
            via "cd .."  until you're there.

        Run the following:

            For PostgreSQL:

                $ psql -U postgres -f titanic.sql
                    Or:
                $ psql -U postgres < titanic.sql
                    Or:
                $ psql -U postgres --quiet < titanic.sql
                    (this will suppress all the 'CREATE TABLE' output messages).

            For SQLite:

                $ sqlite3 titanic.db < titanic.sql

    Saving your output to file:

            Just append the following after your commands:  "> results.txt"

            Example:

                $ psql -U postgres -f titanic.sql > resultsfile.txt


    Comparing your results to an answers file (if you're given one).

            $ vimdiff resultsfile.txt answers.txt
                Or:
            $ diff resultsfile.txt answers.txt


    HOW TO DO THIS HOMEWORK:

            Use this file to help you load the data from the titanic.csv
                into a database.

            Test that you can run SQL scripts by running the queries below.
            Open the provided assn1.sql file, and write queries that answer
                questions 1-8 below.

            TEST your assn1.sql file - by running it as a script, and see if
                you're getting the right answers.

            Email me your assn1.sql file before the due date.

        *** ONLY .sql files will be accepted.  Do NOT submit .docx, .pdf, .rtf,
            copied-and-pasted REPL input/output, or anything else.  ***

%%%%%%%%% Table Creation: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

DROP TABLE IF EXISTS PASSENGERS;  -- Later, we will get rid of this.

CREATE TABLE passengers (
    id INTEGER NOT NULL,
    lname TEXT,
    fname TEXT,
    class TEXT,
    age FLOAT,
    sex TEXT,
    survived INTEGER,
    code INTEGER
);


--%%%% Data Loading: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* For PostgreSQL: */
\COPY passengers FROM './titanic.csv' WITH (FORMAT csv);
\pset footer off
\echo '\n We can print messages in PostgreSQL if we want.\n'


/* For SQLite:

    -- Set to read .csv
.separator ","
    -- read .csv
.import titanic.csv passengers
    -- Use fixed-width columns
.mode column
    -- Show column headers.
.headers on
.print 'This is how we print messages in SQLite.'
    -- (newline - for space between results).
.print ''


*/

--%%%%%%%%% Queries: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-- Let's just see if everything loaded ok, and have a look at the data:
SELECT * FROM passengers LIMIT 5;


-- 'How many total records (passengers) did we load?:'
SELECT
    COUNT(*) AS total_passengers
FROM passengers
;


-- 'How many passengers survived?'
SELECT
    COUNT(*) AS survived
FROM passengers
WHERE survived=1
;


-- Who were the passengers that survived? (let's just look at 5).
SELECT
    fname,
    lname,
    survived
FROM passengers
WHERE survived=1
LIMIT 5
;


-- 'How many did not survive?'
SELECT
    COUNT(*) AS did_not_survive
FROM passengers
WHERE survived=0
;


-- Who were the passengers that survived?  (again, just 5).
SELECT
    fname,
    lname,
    survived
FROM passengers
WHERE survived=0
LIMIT 5
;


-- How many female passengers?  Male passengers?
SELECT
    COUNT(*) AS total_females
FROM passengers
WHERE sex='female'
;


SELECT
    COUNT(*) AS total_males
FROM passengers
WHERE sex='male'
;


-- How many total females did not survive?  Males?
SELECT
    COUNT(*) AS no_survived_females
FROM passengers
WHERE sex='female'
    AND survived=0
;


SELECT
    COUNT(*) AS no_survived_males
FROM passengers
WHERE sex='male'
    AND survived=0
;


-- Percentage of females of the total?
SELECT
    (SUM(CASE WHEN sex='female' THEN 1.0 ELSE 0.0 END) / CAST(COUNT(*) AS FLOAT))*100 AS tot_pct_female
FROM passengers
;


-- Percentage of males of the total?
SELECT
    (SUM(CASE WHEN sex='male' THEN 1.0 ELSE 0.0 END) / CAST(COUNT(*) AS FLOAT))*100 AS tot_pct_male
FROM passengers
;


