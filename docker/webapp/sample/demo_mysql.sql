--docker exec -it postgres psql -U postgres -d postgres -f ./var/lib/postgresql/data/demo.sql
--vi /gpfs/postgres/prod/data/unusual-options-activity-stocks-07-26-2017.csv
--vi /gpfs/postgres/prod/data/candidate.csv
--vi /gpfs/postgres/prod/data/results.json
--copy (select row_to_json(t) from ( select * from tab1) t) to '/var/lib/postgresql/data/tab1.json';

use wordpress;
drop table candidate;
create table candidate (symbol char(6));
LOAD DATA LOCAL INFILE '/var/lib/mysql/tickerlist.csv'  INTO TABLE candidate  FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

drop table uohistory;
create table uohistory( Symbol char(6), Price numeric, Type char(4), Strike numeric, ExpDate varchar(12), DTE int, Bid float,  Midpoint float, Ask float, Last float, Volume int, OpenInterest int, Ratio numeric, IV char(10), Time varchar(12));
truncate uohistory;
--select * from uohistory;
LOAD DATA LOCAL INFILE '/var/lib/mysql/unusual-options-activity-stocks.csv'  INTO TABLE uohistory FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
--UPDATE table SET ExpDate = str_to_date(ExpDate, '%m/%d/%Y');

drop table results;
create table results( Symbol char(6), Price numeric, Type char(4), Strike numeric, ExpDate char(12), DTE int, Bid float,  Midpoint float, Ask float, Last float, Volume int, OpenInterest int, Ratio numeric, IV char(10), Time char(12));
insert into results
select a.* from uohistory a, candidate b where a.Symbol = b.Symbol and a.ratio >= 10 ORDER by a.symbol, a.ratio DESC; 
--INTO OUTFILE "/var/lib/mysql/results.json"
--FIELDS TERMINATED BY ','
--ENCLOSED BY '"'
--LINES TERMINATED BY '\n';
