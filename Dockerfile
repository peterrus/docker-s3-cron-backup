FROM alpine:latest

RUN apk -Uuv add busybox-suid less aws-cli curl && \
	rm /var/cache/apk/*

COPY entrypoint.sh /
COPY dobackup.sh /

RUN chmod +x /entrypoint.sh /dobackup.sh

RUN adduser -D backup

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "crond", "-f", "-d", "8" ]
