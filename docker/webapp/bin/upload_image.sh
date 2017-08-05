#!/bin/bash

__SCRIPT="${__COMMAND:-${0}}"
__BIN="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
__WEBAPP_ROOT="$(dirname "${__BIN}")"
printf "${__SCRIPT}\n"
printf "${__BIN}\n"
printf "${__WEBAPP_ROOT}\n"

docker commit -m "update imacros docker image" -a "ping" imacros ptang83/firefox-imacros
docker push ptang83/firefox-imacros


