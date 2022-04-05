#!/bin/sh -e

# default storage class to standard if not provided
S3_STORAGE_CLASS=${S3_STORAGE_CLASS:-STANDARD}

# generate file name for tar
FILE_NAME=/tmp/$BACKUP_NAME-`date "+%Y-%m-%d_%H-%M-%S"`.tar.gz

# Check if TARGET variable is set
if [[ -z ${TARGET} ]];
then
    echo "TARGET env var is not set so we use the default value (/data)"
    TARGET=/data
else
    echo "TARGET env var is set"
fi

if [ -z "${S3_ENDPOINT}" ]; then
  AWS_ARGS=""
else
  AWS_ARGS="--endpoint-url ${S3_ENDPOINT}"
fi

echo "creating archive"
tar -zcvf $FILE_NAME $TARGET
echo "uploading archive to S3 [$FILE_NAME, storage class - $S3_STORAGE_CLASS]"
aws s3 $AWS_ARGS cp --storage-class $S3_STORAGE_CLASS $FILE_NAME $S3_BUCKET_URL
echo "removing local archive"
rm $FILE_NAME
echo "done"

if [ -n "$WEBHOOK_URL" ]; then
    echo "notifying ${WEBHOOK_URL}"
    curl -m 10 --retry 5 $WEBHOOK_URL
fi
