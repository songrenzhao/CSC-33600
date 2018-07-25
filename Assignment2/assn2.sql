-- Songren Zhao
-- Assignent 2
-- CCNY 33600 Database
-- 6/19/2018

/*
*********************************************************************************************
			 PART 1: The Schema           	Problem	2
*********************************************************************************************
This database is in First Normal Form, because each column has no array data, which means
each column has atomic data. Also, repeating groups in individual tables have been 
eliminated. 

This database is also in Second Normal Form since every column is depending
on primary key, which means that each column can describe what the primary key identifies.
This database provides ID as PK in City table, columns in City are "features" of ID. 
Also in table Country, all columns are related to the description of PK, which is Code. 
Further more, columns in table Country Language are characteristics of Country Code(PK).

However, this table is not in Third Normal Form since government form in table Country is 
not unique and we can careate another table with government_form inside. 

Thus, this table is in 1NF and 2NF but not 3NF.
*********************************************************************************************
*/





set client_encoding to 'UTF8';
\echo '\nSongren Zhao\nAssignment 2\nCCNY 33600 Database\n6/19/2018\n\n'
--  1. Top ten countries by economic activity
\echo '1. Top ten countries by economic activity'
select * from country order by gnp desc limit 10;

-- 2. Top ten countries by GNP per capita
\echo '2. Top ten countries by GNP per capita'
select name,gnp,capital,(gnp/capital)::numeric(10,4) as gnp_per_cap from country where capital <> 0 order by gnp_per_cap desc limit 10;

-- 3. a)Ten most densely populated countries
\echo '3a. Ten most densely populated countries'
select name, (population/surfacearea)::numeric(10,4) as density from country where capital <> 0 and surfacearea <> 0 order by density desc limit 10;

--    b)Ten least densly populated countries 
\echo '3b. Ten least densly populated countries'
select name, (population/surfacearea)::numeric(10,4) as density from country where capital <> 0 and surfacearea <> 0 order by density limit 10;

-- 4. a)Different forms of government
\echo '4a. Different forms of government'
select distinct governmentform from country;

--    b)Frequent forms of government
\echo '4b. Frequent forms of government'
select governmentform, count(*) from country group by governmentform;

-- 5. Highest life expectancy
\echo '5. Ten highest life expectancy countries'
select name, lifeexpectancy as life_expectancy from country where lifeexpectancy is not null order by lifeexpectancy DESC limit 10;

-- 6. Top ten countries by total population and official language
\echo '6. Top ten countries by total population and official language'
select name, population, language from country inner join countrylanguage on country.code = countrylanguage.countrycode where isofficial = 't' order by population desc limit 10;

-- 7. Top ten most populated cities
\echo '7. Top ten populated cities along with countries and continents they are in'
select (city.name) as city, countrycode, city.population, (country.name) as country, continent from city inner join country on city.countrycode = country.code order by city.population desc limit 10;

-- 8. Official language of the top ten cities 
\echo '8. Official language of the top ten cities'
select (city.name) as city, city.population, (country.name) as country, continent, language from city inner join country on city.countrycode = country.code
												      inner join countrylanguage on country.code = countrylanguage.countrycode
												where isofficial = 't' order by city.population desc limit 10;

-- 9. Cities are capitals of their country
\echo '9. Capital of their country'
with temp_table as(
	select city.id as id, city.name as city, city.population as city_population, country.name as country, continent from city inner join country on city.countrycode = country.code order by city.population desc limit 10 
)
select temp_table.city,temp_table.country from temp_table inner join country on temp_table.id = country.capital;

-- 10. Percentage of the country's population
\echo '10. Percentage of their country'
with temp_table as(
	select city.name as city, city.population as city_population, country.population as country_population from city inner join country on city.countrycode = country.code order by city.population desc limit 10
)
select temp_table.city,temp_table.city_population,temp_table.country_population,((cast(temp_table.city_population as float) / cast(temp_table.country_population as float)) * 100)::numeric(10,4) as percentage from temp_table;
