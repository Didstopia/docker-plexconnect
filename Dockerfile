FROM alpine:latest
MAINTAINER Alex Varju

RUN apk add --update \
	git \
	python && \
	rm -rf /var/cache/apk/*

ADD start-plexconnect.sh /opt/
ADD ip-self-external.patch /opt/

RUN cd /opt && \
  git clone https://github.com/iBaa/PlexConnect.git && \
  cd PlexConnect && \
  git apply /opt/ip-self-external.patch

# persistent storage for ssl certificates
VOLUME /plexconnect

ENTRYPOINT /opt/start-plexconnect.sh
