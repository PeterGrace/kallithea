FROM python:2.7
MAINTAINER Peter Grace <pete.grace@gmail.com>

RUN apt-get -y update
RUN apt-get -y install apache2 libapache2-mod-wsgi
RUN virtualenv /opt/kallithea
ENV PATH=/opt/kallithea/bin:$PATH
ENV VIRTUAL_ENV=/opt/kallithea
RUN pip install kallithea
RUN a2dissite 000-default

RUN mkdir /opt/kallithea/data
RUN mkdir /opt/kallithea/repos
ADD docker/kallithea.conf /etc/apache2/sites-available/kallithea.conf
ADD docker/production.ini /opt/kallithea/production.ini
ADD docker/dispatch.wsgi /opt/kallithea/dispatch.wsgi
ADD docker/kallithea.db /opt/kallithea/data/kallithea.db
RUN a2ensite kallithea
RUN chown www-data.www-data -R /opt/kallithea

VOLUME ["/opt/kallithea/repos","/opt/kallithea/data"]
EXPOSE 80

CMD ["/usr/sbin/apache2ctl","-D", "FOREGROUND"]

