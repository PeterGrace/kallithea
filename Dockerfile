FROM alpine:latest
MAINTAINER Peter Grace <pete.grace@gmail.com>

RUN apk --update add apache2 apache2-mod-wsgi python2 py-pip bash git mercurial \
    && apk add -t builddev python2-dev build-base \
    && pip install --upgrade pip \
    && pip install PasteScript \
    && pip install --trusted-host pypi.python.org kallithea \
    && apk del builddev \
    && mkdir -p /opt/kallithea/data \
    && mkdir -p /opt/kallithea/repos

ADD ./entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
VOLUME ["/opt/kallithea/repos","/opt/kallithea/data"]
EXPOSE 5000
