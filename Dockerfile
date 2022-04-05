FROM alpine:3.15


RUN \
	mkdir -p /aws && \
	apk -Uuv add groff less python3 py3-pip curl && \
	pip3 install --no-cache-dir awscli==1.22.54 && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/*

COPY entrypoint.sh /
COPY dobackup.sh /

RUN chmod +x /entrypoint.sh /dobackup.sh

ENTRYPOINT /entrypoint.sh
