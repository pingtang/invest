#!/bin/bash

__SCRIPT="${__COMMAND:-${0}}"
__BIN="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
__WEBAPP_ROOT="$(dirname "${__BIN}")"
printf "${__SCRIPT}\n"
printf "${__BIN}\n"
printf "${__WEBAPP_ROOT}\n"

rm -rf /invest/imacros/Downloads/unusual-options-activity-stocks-*.csv
docker exec -it imacros /usr/bin/firefox imacros://run/?m=login.iim
cp /invest/imacros/Downloads/unusual-options-activity-stocks-*.csv ${__WEBAPP_ROOT}/sample/unusual_option/unusual-options-activity-stocks.csv
