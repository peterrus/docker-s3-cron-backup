#!/bin/sh
echo "$CRON_SCHEDULE /dobackup.sh" > /etc/crontabs/root
crond -f
