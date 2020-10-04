#!/bin/sh

# default storage class to standard if not provided
S3_STORAGE_CLASS=${S3_STORAGE_CLASS:-STANDARD}

# generate file name for tar
FILE_NAME=/tmp/$BACKUP_NAME-`date "+%Y-%m-%d_%H-%M-%S"`.tar.gz

echo "creating archive"
tar -zcvf $FILE_NAME /data
echo "uploading archive to S3 [$FILE_NAME, storage class - $S3_STORAGE_CLASS]"
aws s3 cp --storage-class $S3_STORAGE_CLASS $FILE_NAME $S3_BUCKET_URL
echo "removing local archive"
rm $FILE_NAME
echo "done"
