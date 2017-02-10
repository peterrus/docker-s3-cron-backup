#!/bin/sh
echo "creating crontab"
echo "$CRON_SCHEDULE /dobackup.sh" > /etc/crontabs/root
echo "starting crond"
crond -f
