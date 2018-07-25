--Songren Zhao
--CSC 33600 Database
--7/23/2018

drop table if exists census; 
create table census(
	zipcode integer,
	total_population integer,
	median_age float,
	total_males integer,
	total_females integer,
	total_households integer,
	avg_size float
);
\copy census from './census.csv' with (format csv);
\pset footer off


create temp table default_zipcode as
select zipcode as a_zipcode, total_population as a_pop, median_age as a_med_age, (total_males::numeric(10,4) / ((total_males) + (total_females)))::numeric(10,3) as a_male_pct, avg_size as a_avg_hm_size from census where zipcode = 93591;

--select * from default_zipcode;

create temp table others_zipcode as
select zipcode as b_zipcode, total_population as b_pop, median_age as b_med_age, (total_males::numeric(10,4) / ((total_males) + (total_females)))::numeric(10,3) as b_male_pct, avg_size as b_avg_hm_size from census where total_males <> 0 and total_females <> 0;

create temp table cross_join as
select a.*, b.* from default_zipcode a cross join others_zipcode b;

--select * from cross_join;

create temp table final as
select a_zipcode, b_zipcode as zipcode, b_pop as pop, b_med_age as med_age, b_male_pct as male_pct, b_avg_hm_size as avg_hm_size,
(|/(((a_male_pct - b_male_pct) ^ 2) + ((a_med_age - b_med_age) ^ 2) + ((a_avg_hm_size - b_avg_hm_size) ^ 2)))::numeric(10,3) as distance from cross_join;

create view answer as
select row_number() over(partition by a_zipcode order by distance) as num, zipcode, pop, med_age, male_pct, avg_hm_size, distance from final limit 11;

select * from answer;
