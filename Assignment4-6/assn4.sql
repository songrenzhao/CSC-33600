--Songren Zhao
--CSC 33600 Database
--7/8/2018
DROP TABLE IF EXISTS fundamentals cascade;
CREATE TABLE fundamentals(
	id integer not null,
	symbol text,
	year_ending date,
	cash_equivalent float,
	earning_before_tax float,
	gross_margin integer,
	netincome float,
	total_asset float,
	total_lia float,
	total_revenue float,
	year integer,
	earnings_per_share float,
	shares_outstanding float
);
DROP TABLE IF EXISTS prices cascade;
CREATE TABLE prices(
	tdate date,
	symbol text,
	open float,
	close float,
	low float,
	high float,
	volume integer
);
DROP TABLE IF EXISTS securities cascade;
CREATE TABLE securities(
	symbol text,
	company text,
	sector text,
	sub_indus text,
	ini_trade_date date	
);

\copy fundamentals from './fundamentals.csv' with (format csv);
\copy prices from './prices.csv' with (format csv);
\copy securities from 'securities.csv' with (format csv);
\pset footer off


