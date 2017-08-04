#!/bin/bash

__SCRIPT="${__COMMAND:-${0}}"
__BIN="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
__WEBAPP_ROOT="$(dirname "${__BIN}")"
printf "${__SCRIPT}\n"
printf "${__BIN}\n"
printf "${__WEBAPP_ROOT}\n"

python "${__WEBAPP_ROOT}/fileserver/genFile.py"

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

docker-compose -f "${__WEBAPP_ROOT}/docker-compose.yaml" up -d 2>&1 
__ERR_CODE="${PIPESTATUS[0]}"
if [ "${__ERR_CODE}" -ne 0 ]
then
    printf >&2 "There was an error (${__ERR_CODE}) running 'docker-compose -f \"${__WEBAPP_ROOT}/docker-compose.yaml\" up -d'.\n"
    exit 6
fi

printf "Done! Check out http:// to see your running webapp.\n"

