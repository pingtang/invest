#!/bin/bash

__SCRIPT="${__COMMAND:-${0}}"
__BIN="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
__WEBAPP_ROOT="$(dirname "${__BIN}")"

printf "Running 'docker-compose -f \"${__WEBAPP_ROOT}/docker-compose.yaml\" down'...\n"

docker-compose -f "${__WEBAPP_ROOT}/docker-compose.yaml" down | sed 's/^/    /g'
__ERR_CODE="${PIPESTATUS[0]}"
if [ "${__ERR_CODE}" -ne 0 ]
then
    printf >&2 "There was an error (${__ERR_CODE}) running 'docker-compose down'.\n"
    exit 9
fi

