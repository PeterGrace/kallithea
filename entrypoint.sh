#!/bin/bash

CFG_FILE=/opt/kallithea/production.ini

if [ ! -f "${CFG_FILE}" ]
then
    kallithea-cli config-create ${CFG_FILE} host=0.0.0.0
fi
if [ ! -f "/opt/kallithea/kallithea.db" ]
then
    kallithea-cli db-create \
      --user=admin --email=admin@admin.com --password=Administrator \
      --repos=/opt/kallithea/repos --force-yes \
      -c ${CFG_FILE}
    kallithea-cli front-end-build
fi
getent >/dev/null passwd kallithea || adduser \
    --system --uid 119 --disabled-password --disabled-login --ingroup www-data kallithea
chown kallithea:www-data /opt/kallithea/
chown kallithea:www-data /opt/kallithea/kallithea.db
chown -R kallithea:www-data /opt/kallithea/repos
chown -R kallithea:www-data /opt/kallithea/data
chown -R kallithea:www-data /opt/kallithea/cfg
chmod -R o-rx /opt/kallithea/cfg

# start web-server
gearbox serve -c ${CFG_FILE} --user=kallithea
