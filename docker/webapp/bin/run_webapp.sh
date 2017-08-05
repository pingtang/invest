#!/bin/bash

__SCRIPT="${__COMMAND:-${0}}"
__BIN="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
__WEBAPP_ROOT="$(dirname "${__BIN}")"
printf "${__SCRIPT}\n"
printf "${__BIN}\n"
printf "${__WEBAPP_ROOT}\n"

python "${__WEBAPP_ROOT}/fileserver/genFile.py"
python "${__WEBAPP_ROOT}/fileserver/webScraper.py"

printf "Re-building 'local/invest-webapp:latest' Docker image...\n"

#echo DEBUG: __WEBAPP_ROOT=${__WEBAPP_ROOT}
#docker build --pull --force-rm -t local/invest-webapp:latest "${__WEBAPP_ROOT}" 
#__ERR_CODE="${PIPESTATUS[0]}"
#if [ "${__ERR_CODE}" -ne 0 ]
#then
#    printf >&2 "There was an error (${__ERR_CODE}) running 'docker build --pull --force-rm -t local/invest-webapp:latest \"${__WEBAPP_ROOT}\"'.\n"
#    exit 4
#fi

printf "Re-building 'local/invest-fileserver:latest' Docker image...\n"

docker build --pull --force-rm -t local/invest-fileserver:latest "${__WEBAPP_ROOT}/fileserver" 
__ERR_CODE="${PIPESTATUS[0]}"
if [ "${__ERR_CODE}" -ne 0 ]
then 
    printf >&2 "There was an error (${__ERR_CODE}) running 'docker build --pull --force-rm -t local/invest-fileserver:latest \"${__WEBAPP_ROOT}/fileserver\"'.\n"
    exit 5
fi

printf "Running 'docker-compose -f \"${__WEBAPP_ROOT}/docker-compose.yaml\" up -d'...\n"

docker-compose -f "${__WEBAPP_ROOT}/docker-compose.yaml" up --remove-orphans  -d  2>&1 
__ERR_CODE="${PIPESTATUS[0]}"
if [ "${__ERR_CODE}" -ne 0 ]
then
    printf >&2 "There was an error (${__ERR_CODE}) running 'docker-compose -f \"${__WEBAPP_ROOT}/docker-compose.yaml\" up -d'.\n"
    exit 6
fi

__UID=`id -u`
if [ "${__UID}" -eq 1000 ]
then
    printf "AWS"
    printf "Install wordpress plugin: DbTable to DataTable"
    sudo chown root:root /invest/postgres/data
    sudo chmod 777 /invest/postgres/data
    sudo chown root:root /invest/mysql/
    sudo chmod 777 /invest/mysql/

fi

cp /invest/archive/*.csv /invest/mysql/
cp ${__WEBAPP_ROOT}/sample/* /invest/postgres/data/
cp ${__WEBAPP_ROOT}/sample/* /invest/mysql/
docker exec -it postgres psql -U postgres -d postgres -f ./var/lib/postgresql/data/demo.sql
docker exec -i mysql mysql -u root -pexample --force < /invest/mysql/demo_mysql.sql

#load all tickers to database
TICKERS=`cat ../fileserver/tickerlist`
for TICKER in $TICKERS; do
   echo "$TICKER"
   docker exec -i mysql mysql -u root -pexample --force < /invest/mysql/${TICKER}_demo_load.sql
done

printf "Done! Check out http:// to see your running webapp.\n"

