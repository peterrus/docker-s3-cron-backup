# Docker S3 Cron Backup

[Docker Hub](https://hub.docker.com/r/peterrus/s3-cron-backup/) |
[Github](https://github.com/peterrus/docker-s3-cron-backup)

## What is it?
A modest little container image that periodically backups any volume mounted to /data to Amazon S3 in the form of a timestamped, gzipped, tarball

## Great, but how does it work?
An Alpine Linux instance runs nothing more than crond with a crontab that contains nothing more than one single entry that triggers the backup script. When this script is run, the volume mounted at /data gets tarred, gzipped and uploaded to a S3 bucket. Afterwards the archive gets deleted from the container. The mounted volume, of course, will be left untouched.

I invite you to check out the source of this image, it's rather simple and should be easy to understand. If this isn't the case, feel free to open an issue on [github](https://github.com/peterrus/docker-s3-cron-backup)

*Pull requests welcome*

## Now, how do I use it?
The container is configured via a set of environment variables:
- AWS_ACCESS_KEY: Get this from amazon IAM
- AWS_SECRET_ACCESS_KEY: Get this from amazon IAM, **you should keep this a secret**
- S3_BUCKET_URL: in most cases this should be s3://name-of-your-bucket/
- AWS_DEFAULT_REGION: The AWS region your bucket resides in
- CRON_SCHEDULE: Check out [crontab.guru](https://crontab.guru/) for some examples:
- BACKUP_NAME: A name to identify your backup among the other files in your bucket, it will be postfixed with the current timestamp (date and time)

### Directly via Docker
[not documented yet]

### Docker-compose
```
# docker-compose.yml
version: '2'

services:
  backup-grafana:
    build: s3-cron-backup
    environment:
      - AWS_ACCESS_KEY_ID=SOME8AWS3ACCESS9KEY
      - AWS_SECRET_ACCESS_KEY=sUp3rS3cr3tK3y0fgr34ts3cr3cy
      - S3_BUCKET_URL=s3://name-of-your-bucket/
      - AWS_DEFAULT_REGION=your-aws-region
      - CRON_SCHEDULE=* 0 * * * # run every hour
      - BACKUP_NAME=make-something-up
    volumes:
      - /your/awesome/data:/data:ro #use ro to make sure the volume gets mounted read-only
    restart: always
```
