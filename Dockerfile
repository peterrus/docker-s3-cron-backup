FROM alpine:latest

COPY entrypoint.sh /
COPY dobackup.sh /

RUN \
	mkdir -p /aws && \
	apk -Uuv add groff less python3 py3-pip && \
	pip3 install awscli && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/* && \
	chmod +x /entrypoint.sh /dobackup.sh


ENTRYPOINT /entrypoint.sh
