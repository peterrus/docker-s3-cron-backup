FROM alpine:latest

RUN apk -Uuv add less aws-cli curl && \
	rm /var/cache/apk/*

COPY entrypoint.sh /
COPY dobackup.sh /

RUN chmod +x /entrypoint.sh /dobackup.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "crond", "-f" ]
