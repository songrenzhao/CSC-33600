--Songren Zhao
--CSC 33600 Database
--7/8/2018

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- Part 1
CREATE TEMP TABLE partitioned_dates AS
SELECT 
	tdate, 
	row_number() over (partition by date_trunc('year', tdate) 
		order by tdate desc) as num 
from prices; 
--where symbol like 'A%';

create temp table year_ends as
select tdate as year_ends from partitioned_dates where num = 1 order by tdate 
desc;

--select * from year_ends;

create temp table year_end_prices as
select symbol, tdate, close from prices where tdate in (select * from year_ends)
order by symbol, tdate desc;

--select * from year_end_prices;

--select *, lead(close) over (partition by symbol order by tdate desc) as last_yr_close from year_end_prices limit 20;

create temp table annual_returns as 
select 
	symbol, tdate, close,
	lead(close) over (partition by symbol order by tdate desc) as last_yr_close,
	((close/(lead(close) over(partition by symbol order by tdate desc)))::numeric(10,4) - 1)* 100 as pct_return 
from year_end_prices;

create temp table selected_companies as
select *, extract(YEAR from tdate) as year from annual_returns where pct_return is not null order by pct_return desc limit 70 offset 10;

--select * from selected_companies where extract(year from tdate) <> 2016;

--select * from fundamentals a inner join selected_companies b on a.symbol = b.symbol and a.year_ending = b.tdate;

create temp table temp_fund as 
select b.*, lag(a.year) over(partition by a.symbol order by year_ending) as pre_year from fundamentals a left join selected_companies b on a.symbol = b.symbol and a.year_ending = b.tdate;

create temp table potential_candiates as
select * from temp_fund where close is not null and pre_year is not null order by pct_return;

--select * from potential_candiates;
--\echo '\n1. Net Worth\n'
--select b.id, a.symbol, a.year, a.pre_year,b.netincome, b.total_asset, b.total_lia, (b.total_asset - b.total_lia) as net_worth from potential_candiates a inner join fundamentals b on a.symbol = b.symbol and a.pre_year = b.year;
--\echo '\n2. Net Income Growth Year-Over-Year\n'
--select id, symbol, year, netincome, lag(year) over(partition by symbol order by year_ending) as pre_year, lag(netincome) over(partition by symbol order by year_ending) as pre_netincome, (netincome - lag(netincome) over(partition by symbol order by year_ending)) as year_to_year_netincome, (netincome/lag(netincome) over(partition by symbol order by year_ending) - 1) as growth_rate from fundamentals where symbol in (select symbol from potential_candiates);
--\echo '\n3. Revenue Growth Year-Over-Year\n'
--select id, symbol, year, total_revenue, lag(year) over(partition by symbol order by year_ending) as pre_year, lag(total_revenue) over(partition by symbol order by year_ending) as pre_revenue, (total_revenue - lag(total_revenue) over(partition by symbol order by year_ending)) as net_revenue, (total_revenue / lag(total_revenue) over(partition by symbol order by year_ending)) - 1 as growth_rate from fundamentals where symbol in (select symbol from potential_candiates);
--\echo '\n4. Earnings per Share Growth\n'
--select id, symbol, year, earnings_per_share, lag(year) over(partition by symbol order by year_ending) as pre_year, lag(earnings_per_share) over(partition by symbol order by year_ending) as pre_earnings_per_share,(earnings_per_share / lag(earnings_per_share) over(partition by symbol order by year_ending)) - 1 as growth_rate from fundamentals where symbol in (select symbol from potential_candiates);
--\echo '\n5. Price-to-Earnings Ratio\n'
--select * from potential_candiates;

create temp table temp_table as
select a.symbol, b.earnings_per_share from potential_candiates a inner join fundamentals b on a.symbol = b.symbol and a.year = b.year;

create temp table price_to_earning_all_time as 
select a.*, tdate, close as closing_price from temp_table a inner join prices b on a.symbol = b.symbol where tdate in (select * from year_ends);

--select *, (closing_price / earnings_per_share) as price_to_earnings_ratio from price_to_earning_all_time;
--\echo '\n6. Amount of Cash vs Total Liabilities\n'
--select symbol, year, cash_equivalent, total_lia, (cash_equivalent/total_lia) as cash_liability_relationship from fundamentals where symbol in (select symbol from potential_candiates);
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- Part 2
create temp table high_netincome as
select id, symbol, year, netincome, lag(year) over(partition by symbol order by year_ending) as pre_year, lag(netincome) over(partition by symbol order by year_ending) as pre_netincome, (netincome - lag(netincome) over(partition by symbol order by year_ending)) as year_to_year_netincome, (netincome/lag(netincome) over(partition by symbol order by year_ending) - 1) as growth_rate from fundamentals;

--select * from high_netincome where growth_rate is not null order by growth_rate desc;

create temp table high_revenue_growth as
select id, symbol, year, total_revenue, lag(year) over(partition by symbol order by year_ending) as pre_year, lag(total_revenue) over(partition by symbol order by year_ending) as pre_revenue, (total_revenue - lag(total_revenue) over(partition by symbol order by year_ending)) as net_revenue, (total_revenue / lag(total_revenue) over(partition by symbol order by year_ending)) - 1 as growth_rate from fundamentals;

--select * from high_revenue_growth where growth_rate is not null order by growth_rate desc;

create temp table compare_netincome_revenue as 
select a.symbol, a.year, a.growth_rate as netincome_growth_rate, b.growth_rate as revenue_growth, (a.growth_rate/b.growth_rate) as relationship_factor from high_netincome a inner join high_revenue_growth b on a.symbol = b.symbol and a.year = b.year where (a.growth_rate/b.growth_rate) is not null and a.year = 2016 order by (a.growth_rate/b.growth_rate) desc;

create temp table potential_choices as
select * from compare_netincome_revenue limit 40;

--\echo 'Potential Candidates'
--select * from potential_choices;
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- Part 3
create temp table temp_part3 as
--I have set restriction on netIncome growth rate because i dont want to include companies that are losing money.
select a.symbol, b.company, b.sector,a.netincome_growth_rate, a.revenue_growth, a.relationship_factor, row_number() over(partition by sector order by relationship_factor desc) as num from potential_choices a inner join securities b using(symbol) where a.netincome_growth_rate > 0;

create temp table good_companies as
select * from temp_part3 where num between 1 and 2;

--select * from good_companies;

create temp table part3 as
select * from good_companies;

create temp table part3_dup as
select * from good_companies;

create temp table part3_final as 
select a.symbol as a_symbol, a.sector as a_sector, a.relationship_factor as a_factor, b.symbol as b_symbol, b.sector as b_sector, b.relationship_factor as b_factor from part3 a cross join part3_dup b where a.symbol <> b.symbol; 

create temp table final as
select a_symbol, a_sector, a_factor, b_symbol, b_sector, b_factor from part3_final;

create temp table assn_six as
select *, (a_factor / b_factor) as corre from final where (a_factor/b_factor) > 0 order by corre limit 10;
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- Assignment 6
create temp table temp_view as
select a.id, a.symbol, c.tdate, a.netincome, a.total_asset, a.earnings_per_share, c.open, c.close, c.low, c.high, c.volume from fundamentals a inner join good_companies b on a.symbol = b.symbol 
						           inner join prices c on a.symbol = c.symbol
					                   where year = 2016 and tdate = '2016-12-30'order by tdate desc; 
create view csv_file as
select * from temp_view;

select * from csv_file;
--create temp table prices_temp as 
--select a.id, a.symbol, a.year_ending, b* from fundamentals_temp a inner join prices b on a.symbol and 

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
