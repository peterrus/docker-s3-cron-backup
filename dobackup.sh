#!/bin/sh
tar -zcvf /tmp/$BACKUP_NAME-`date "+%y-%m-%d_%H-%M-%S"`.tar.gz /data
aws s3 cp /tmp/*.tar.gz $S3_BUCKET_URL
rm /tmp/*.tar.gz
