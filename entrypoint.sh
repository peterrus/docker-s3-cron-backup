#!/usr/bin/env sh

set -e

echo "creating crontab"
printf "${CRON_SCHEDULE} /dobackup.sh\n" > /etc/crontabs/root

echo "starting $@"
exec "$@"
