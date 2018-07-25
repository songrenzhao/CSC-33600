\echo '\nSongren Zhao\nCSC 336 Database\n7/24/2018\n\n'

drop table if exists companies;
create table companies(
	id integer,
	ind_risk text,
	man_risk text,
	fin_risk text,
	cred text,
	comp text,
	oper_risk text,
	class text
);

\copy companies from './ids.csv' with (format csv);
\pset footer off

create temp table temp_1 as
select *, (case when ind_risk = 'N' then 1 else 0 end +
          case when man_risk = 'N' then 1 else 0 end +
	  case when fin_risk = 'N' then 1 else 0 end +
          case when cred = 'N' then 1 else 0 end +
          case when comp = 'N' then 1 else 0 end +
          case when oper_risk = 'N' then 1 else 0 end) as counter from companies;

create temp table temp_2 as
select *, case when counter <= 2 then 'Low' 
	       when counter  < 4 then 'Medium'
	       when counter < 5 then 'Med-High'
	       when counter >= 5 then 'High'
	       end as risk_level from temp_1;

create temp table bankrupt as
	with temp as (
		select * from temp_2 where class = 'B'
	)	
select risk_level, count(risk_level) as num_companies from temp group by risk_level having risk_level is not null order by count(risk_level) desc;

\echo 'Bankrupt Company Breakdown: \n'
select * from bankrupt;

create temp table non_bankrupt as
	with temp as (
		select * from temp_2 where class = 'NB'
	)	
select risk_level, count(risk_level) as num_companies from temp group by risk_level having risk_level is not null order by count(risk_level) desc;

\echo 'Non-Bankrupt Company Breakdown: \n'
select * from non_bankrupt;

\echo 'Non-Bankrupt Companies that are at Medium Risk Level: \n'
select id, counter as risk_score, class, risk_level from temp_2 where class = 'NB' and risk_level = 'Medium';
