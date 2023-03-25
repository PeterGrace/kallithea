#!/bin/bash
if [ ! -f "/opt/kallithea/production.ini" ]
then
    kallithea-cli config-create /opt/kallithea/production.ini host=0.0.0.0
fi
if [ ! -f "/opt/kallithea/kallithea.db" ]
then
    kallithea-cli db-create \
      --user=admin --email=admin@admin.com --password=Administrator \
      --repos=/opt/kallithea/repos --force-yes \
      -c /opt/kallithea/production.ini
    kallithea-cli front-end-build
fi
gearbox serve -c /opt/kallithea/production.ini
