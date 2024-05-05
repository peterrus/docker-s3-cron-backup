#!/usr/bin/env sh

set -e

cat << EOF > /home/backup/.env
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
export BACKUP_NAME=${BACKUP_NAME}
export TARGET=${TARGET}
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
export S3_BUCKET_URL=${S3_BUCKET_URL}
export S3_STORAGE_CLASS=${S3_STORAGE_CLASS}
export S3_ENDPOINT=${S3_ENDPOINT}
EOF

echo "creating crontab"
printf "${CRON_SCHEDULE} su - backup -c /dobackup.sh\n" > /tmp/crontab
crontab - < /tmp/crontab

echo "starting $@"
exec "$@"
