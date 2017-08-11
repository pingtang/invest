#!/bin/bash

__SCRIPT="${__COMMAND:-${0}}"
__BIN="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
__WEBAPP_ROOT="$(dirname "${__BIN}")"
printf "${__SCRIPT}\n"
printf "${__BIN}\n"
printf "${__WEBAPP_ROOT}\n"

python "${__WEBAPP_ROOT}/fileserver/genFile.py"
python "${__WEBAPP_ROOT}/fileserver/webScraper.py"

cp /invest/archive/*.csv /invest/mysql/
cp ${__WEBAPP_ROOT}/sample/* /invest/postgres/data/
cp ${__WEBAPP_ROOT}/sample/* /invest/mysql/
cp ${__WEBAPP_ROOT}/sample/unusual_optioual-options-activity-stocks.csv /invest/mysql/
cp ${__WEBAPP_ROOT}/sample/*.iim /invest/imacros/Macros

#docker exec -it postgres psql -U postgres -d postgres -f ./var/lib/postgresql/data/demo.sql
docker exec -i mysql mysql -u root -pexample --force < /invest/mysql/demo_mysql.sql

#load all tickers to database
TICKERS=`cat ../fileserver/tickerlist`
for TICKER in $TICKERS; do
   echo "$TICKER"
   docker exec -i mysql mysql -u root -pexample --force < /invest/mysql/${TICKER}_demo_load.sql
done


