#!/bin/sh
# echo "creating archive"
# tar -zcvf /tmp/$BACKUP_NAME-`date "+%Y-%m-%d_%H-%M-%S"`.tar.gz /data
# echo "uploading archive to S3"
# aws s3 cp /tmp/*.tar.gz $S3_BUCKET_URL
# echo "removing local archive"
# rm /tmp/*.tar.gz
echo "synchronising files to S3"
s3cmd sync /data/ $S3_BUCKET_URL
echo "done"
