# Docker S3 Cron Backup

[:star: Docker Hub](https://hub.docker.com/r/peterrus/s3-cron-backup/)
[:star: Github](https://github.com/peterrus/docker-s3-cron-backup)

## What is it?
A modest little container image that periodically backups any volume mounted to `/data` to S3-compatible storage in the form of a timestamped, gzipped, tarball. By default this container is configured to work with Amazon S3 but it should work with most S3-backends.

## Great, but how does it work?
An Alpine Linux instance runs nothing more than crond with a crontab that contains nothing more than one single entry that triggers the backup script. When this script is run, the volume mounted at `/data` gets tarred, gzipped and uploaded to a S3 bucket. Afterwards the archive gets deleted from the container. The mounted volume, of course, will be left untouched.

I invite you to check out the source of this image, it's rather simple and should be easy to understand. If this isn't the case, feel free to open an issue on [github](https://github.com/peterrus/docker-s3-cron-backup)

*Pull requests welcome*

## Now, how do I use it?
The container is configured via a set of required environment variables:
- `AWS_ACCESS_KEY_ID`: Get this from Amazon IAM
- `AWS_SECRET_ACCESS_KEY`: Get this from Amazon IAM, **you should keep this a secret**
- `S3_BUCKET_URL`: in most cases this should be `s3://name-of-your-bucket/`
- `AWS_DEFAULT_REGION`: The AWS region your bucket resides in
- `CRON_SCHEDULE`: Check out [crontab.guru](https://crontab.guru/) for some examples:
- `BACKUP_NAME`: A name to identify your backup among the other files in your bucket, it will be postfixed with the current timestamp (date and time)

And the following optional environment variables:
- `S3_ENDPOINT`: (Optional, defaults to whatever aws-cli provides) configurable S3 endpoint URL for non-Amazon services (e.g. [Wasabi](https://wasabi.com/) or [Minio](https://min.io/))
- `S3_STORAGE_CLASS`: (Optional, defaults to `STANDARD`) S3 storage class, see [aws cli documentation](https://docs.aws.amazon.com/cli/latest/reference/s3/cp.html) for options
- `TARGET`: (Optional, defaults to `/data`) Specifies the target location to backup. Useful for sidecar containers and to filter files.
  - Example with multiple targets: `TARGET="/var/log/*.log /var/lib/mysql/*.dmp"` (Arguments will be passed to `tar`).
- `WEBHOOK_URL`: (Optional) URL to ping after successful backup, e.g. [StatusCake push monitoring](https://www.statuscake.com/kb/knowledge-base/what-is-push-monitoring/) or [healthchecks.io](https://healthchecks.io)


### Directly via Docker
```
docker run \
  -e AWS_ACCESS_KEY_ID=SOME8AWS3ACCESS9KEY \
  -e AWS_SECRET_ACCESS_KEY=sUp3rS3cr3tK3y0fgr34ts3cr3cy \
  -e S3_BUCKET_URL=s3://name-of-your-bucket/ \
  -e AWS_DEFAULT_REGION=your-aws-region \
  -e CRON_SCHEDULE="0 * * * *" \
  -e BACKUP_NAME=make-something-up \
  -v /your/awesome/data:/data:ro \
  peterrus/s3-cron-backup
```

### Docker-compose
```
# docker-compose.yml
version: '3.8'

services:
  my-backup-unit:
    image: peterrus/s3-cron-backup
    environment:
      - AWS_ACCESS_KEY_ID=SOME8AWS3ACCESS9KEY
      - AWS_SECRET_ACCESS_KEY=sUp3rS3cr3tK3y0fgr34ts3cr3cy
      - S3_BUCKET_URL=s3://name-of-your-bucket/
      - AWS_DEFAULT_REGION=your-aws-region
      - CRON_SCHEDULE=0 * * * * # run every hour
      - BACKUP_NAME=make-something-up
    volumes:
      - /your/awesome/data:/data:ro #use ro to make sure the volume gets mounted read-only
    restart: always
```

### S3 Bucket Policy Example
From a security perspective it is often preferable to create a dedicated IAM user that only has access to the specific bucket it needs for placing the archive in. The following IAM policy can then be attached to that user to give the minimum amount of required access.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
            ],
            "Resource": "arn:aws:s3:::docker-s3-cron-backup-test/*"
        }
    ]
}
```

## It doesn't do X or Y!

Let this container serve as a starting point and an inspiration! Feel free to modify it and even open a PR if you feel others can benefit from these changes.

## Contributors
- [jayesh100](https://github.com/jayesh100)
- [ifolarin](https://github.com/ifolarin)
- [stex79](https://github.com/stex79)
- [f213](https://github.com/f213)
