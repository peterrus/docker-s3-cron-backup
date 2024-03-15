#!/usr/bin/env sh

set -e

echo "creating crontab"
echo -e "$CRON_SCHEDULE /dobackup.sh\n" > /etc/crontabs/root

echo "starting $@"
exec "$@"
