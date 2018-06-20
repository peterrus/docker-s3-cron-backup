# Docker S3 Cron Backup

[:star: Docker Hub](https://hub.docker.com/r/peterrus/s3-cron-backup/)
[:star: Github](https://github.com/peterrus/docker-s3-cron-backup)

## What is it?
A container image that periodically backs up volume at `/data` to Amazon S3 using s3cmd sync

## Great, but how does it work?
An Alpine Linux instance runs nothing more than crond with a crontab that contains nothing more than one single entry that triggers the backup script. When this script is run, the volume mounted at `/data` synced to a S3 bucket. The mounted volume, of course, will be left untouched.

This is forked from an earlier image by [peterrus](https://github.com/peterrus/docker-s3-cron-backup).

*Pull requests welcome*

## Now, how do I use it?
The container is configured via a set of environment variables:
- AWS_ACCESS_KEY: Get this from amazon IAM
- AWS_SECRET_ACCESS_KEY: Get this from amazon IAM, **you should keep this a secret**
- S3_BUCKET_URL: in most cases this should be s3://name-of-your-bucket/
- AWS_DEFAULT_REGION: The AWS region your bucket resides in
- CRON_SCHEDULE: Check out [crontab.guru](https://crontab.guru/) for some examples:

All environment variables prefixed with 'AWS_' are directly used by [s3cmd](http://s3tools.org/s3cmd-sync) that this image heavily relies on.

### Directly via Docker
```
docker run \
  -e AWS_ACCESS_KEY_ID=SOME8AWS3ACCESS9KEY \
  -e AWS_SECRET_ACCESS_KEY=sUp3rS3cr3tK3y0fgr34ts3cr3cy \
  -e S3_BUCKET_URL=s3://name-of-your-bucket/ \
  -e AWS_DEFAULT_REGION=your-aws-region \
  -e CRON_SCHEDULE="0 * * * *" \
  -v /your/awesome/data:/data:ro \
  chrisbrownie/s3-cron-backup
```

### Docker-compose
```
# docker-compose.yml
version: '2'

services:
  my-backup-unit:
    image: chrisbrownie/s3-cron-backup
    environment:
      - AWS_ACCESS_KEY_ID=SOME8AWS3ACCESS9KEY
      - AWS_SECRET_ACCESS_KEY=sUp3rS3cr3tK3y0fgr34ts3cr3cy
      - S3_BUCKET_URL=s3://name-of-your-bucket/
      - AWS_DEFAULT_REGION=your-aws-region
      - CRON_SCHEDULE=0 * * * * # run every hour
    volumes:
      - /your/awesome/data:/data:ro #use ro to make sure the volume gets mounted read-only
    restart: always
```
