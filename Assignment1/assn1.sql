-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%% Finish the rest by answering these questions  %%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%% Most are SQL - some are conceptual            %%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%%   short answers are fine for conceptual.      %%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-- Table Creation by Songren Zhao
-- CSC 33600 Database Summer 2018 at CCNY
-- Professor Gordon

drop table if exists passengers;
create table passengers(
  id integer not null,
  lname text,
  fname text,
  class text,
  age float,
  sex text,
  survived integer,
  code integer
);

--Data Loading
\Copy passengers FROM './titanic.csv' with (FORMAT csv);
\pset footer off
\echo '\nSongren Zhao Summer 2018\n'

-- 1.  What percent survived? (total)
SELECT
    (SUM(CASE WHEN survived = 1 THEN 1.0 ELSE 0.0 END) / CAST(COUNT(*) AS FLOAT))*100 as percent_survived
FROM passengers
;

-- 2.  Percentage of females that survived?
SELECT
    (SUM(CASE WHEN sex = 'female' and survived = 1 THEN 1.0 ELSE 0.0 END) / SUM(CASE WHEN sex = 'female' THEN 1.0 ELSE 0.0 END))*100 as Percentage_of_females_that_survived
FROM passengers
;

-- 3.  Percentage of males that survived?
SELECT
    (SUM(CASE WHEN sex = 'male' and survived = 1 THEN 1.0 ELSE 0.0 END) / SUM(CASE WHEN sex = 'male' THEN 1.0 ELSE 0.0 END))*100 as Percentage_of_males_that_survived
FROM passengers
;

-- 4.  How many people total were in First class, Second class, Third, or unknown ?
select
    count(*) as first_class_passengers
from passengers
where class = '1st'
;
select
    count(*) as second_class_passengers
from passengers
where class = '2nd'
;
select
    count(*) as thrid_class_passengers
from passengers
where class = '3rd'
;
select
    count(*) as unknown_class_passengers
from passengers
where class IS NULL
;

-- 5.  What is the total number of people in First and Second class ?
select
  (sum(case when class = '1st' or class = '2nd' then 1.0 else 0.0 end)) as passengers_first_and_second_class
from passengers
;

-- 6.  What are the survival percentages of the different classes? (3).
select
    (sum(case when class = '1st' and survived = 1.0 then 1.0 else 0.0 end) / sum(case when class = '1st' then 1.0 else 0.0 end)) * 100 as first_survival_percentages
from passengers
;
select
    (sum(case when class = '2nd' and survived = 1.0 then 1.0 else 0.0 end) / sum(case when class = '2nd' then 1.0 else 0.0 end)) * 100 as second_survival_percentages
from passengers
;
select
    (sum(case when class = '3rd' and survived = 1.0 then 1.0 else 0.0 end) / sum(case when class = '3rd' then 1.0 else 0.0 end)) * 100 as third_survival_percentages
from passengers
;

-- 7.  Can you think of other interesting questions about this dataset?
--      I.e., is there anything interesting we can learn from it?  
--      Try to come up with at least two new questions we could ask.

/*
 Questions: 1. What is the percentage of female survival rate in first class?
            2. What is the percentage of male survival rate in first class?
 */



-- 8.  How would we answer those questions if we did think of some?
--      Are you able to write the query to find the answer now?
--       %%% Yes %%%
--      Or - do we need more data to find out - is this data set sufficient?
--       %%% Data is sufficient %%%
--      Do you posess the SQL knowledge now to answer these questions using the dataset?
--       %%% Yes %%%
--          If not, what else might we need to learn in order to do it?
select
    (sum(case when sex = 'female' and class = '1st' and survived = 1.0 then 1.0 else 0.0 end) / sum(case when sex = 'female' and class = '1st' then 1.0 else 0.0 end)) * 100 as female_survival_rate_in_first_class
from passengers
;

select
    (sum(case when sex = 'male' and class = '1st' and survived = 1.0 then 1.0 else 0.0 end) / sum(case when sex = 'male' and class = '1st' then 1.0 else 0.0 end)) * 100 as male_survival_rate_in_first_class
from passengers
;

--      If you did answer some questions about the data, 
--          how would you justify or defend your results if someone challenged them?
--          -- Did the query make sense?  Are your methods good ?
--    Base on the data, I found that Male survival rate in first class is 32.96% and female survival rate in first class is 93.71%
--    Although first class survival rate has the highest percentage about 59.9%, male only had a percentage of 32.96% while female had a percentage of 93.71%.
--    This shows "ladies first" as a chivalrous custom was deeply implemented in people's minds.
