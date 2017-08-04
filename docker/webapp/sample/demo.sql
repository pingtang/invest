--docker exec -it postgres psql -U postgres -d postgres -f ./var/lib/postgresql/data/demo.sql
--vi /gpfs/postgres/prod/data/unusual-options-activity-stocks-07-26-2017.csv
--vi /gpfs/postgres/prod/data/candidate.csv
--vi /gpfs/postgres/prod/data/results.json
copy (select row_to_json(t) from ( select * from tab1) t) to '/var/lib/postgresql/data/tab1.json';

drop table candidate;
create table candidate (symbol char(6));
copy candidate from '/var/lib/postgresql/data/candidate.csv' DELIMITER ',' CSV;

drop table uohistory;
create table uohistory( Symbol char(6), Price numeric, Type char(4), Strike numeric, ExpDate date, DTE int, Bid numeric,  Midpoint numeric, Ask numeric, Last numeric, Volume int, OpenInterest int, Ratio numeric, IV char(10), Time date);
truncate uohistory;
--select * from uohistory;
copy uohistory from '/var/lib/postgresql/data/unusual-options-activity-stocks-07-26-2017.csv' DELIMITER ',' CSV;
select * from uohistory a, candidate b where a.Symbol = b.Symbol and a.ratio >= 10 ORDER by a.symbol, a.ratio DESC;
--copy (select row_to_json(t) from 
copy (select array_to_json(array_agg(t)) from
     (select * from uohistory a, candidate b where a.Symbol = b.Symbol and a.ratio >= 10 ORDER by a.symbol, a.ratio DESC)
     t ) to '/var/lib/postgresql/data/results.json';

npm install json-table
npm uninstall json-table
npm list
node /Users/ptang/node_Projects/MySite/app.js
