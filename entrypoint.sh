#!/bin/bash
if [ ! -f "/opt/kallithea/production.ini" ]
then
    paster make-config Kallithea /opt/kallithea/production.ini
    sed -i 's#127.0.0.1#0.0.0.0#g' /opt/kallithea/production.ini
fi
if [ ! -f "/opt/kallithea/data/kallithea.db" ]
then
    paster setup-db -q --user=admin --email=admin@admin.com --password=Administrator --repos=/opt/kallithea/repos --force-yes /opt/kallithea/production.ini
fi
paster serve /opt/kallithea/production.ini
