#!/bin/bash

CFG_FILE=/opt/kallithea/production.ini
[ -z ${DB_TYPE} ] && DB_TYPE=sqlite

if [ ! -f "${CFG_FILE}" ]
then
    kallithea-cli config-create ${CFG_FILE} host=0.0.0.0 database_engine=${DB_TYPE}
    case ${DB_TYPE} in
      sqlite)
        export DB_NAME=/opt/kallithea/data/kallithea.db
        sed -i "s#^sqlalchemy\.url = .*#sqlalchemy.url = sqlite://${DB_NAME}?timeout=60#g" ${CFG_FILE}
        ;;
      postgres)
        sed -i "s#^sqlalchemy\.url = .*#sqlalchemy.url = postgresql://${DB_USER}:${DB_PASS}@${DB_HOST}:${DB_PORT:-5432}/${DB_NAME}#g" ${CFG_FILE}
        ;;
      mysql)
        echo >&2 TODO: mysql database setup
        exit 1
        ;;
    esac
fi
if [ ${DB_TYPE} = sqlite ] && [ ! -f "${DB_NAME}" ]
then
    kallithea-cli db-create \
      --user=admin --email=admin@admin.com --password=Administrator \
      --repos=/opt/kallithea/repos --force-yes \
      -c ${CFG_FILE}
fi
[ -f /opt/kallithea/stamp_frontend-built ] || { kallithea-cli front-end-build; touch /opt/kallithea/stamp_frontend-built; }
getent >/dev/null passwd kallithea || adduser \
    --system --no-create-home --uid 119 --disabled-password --disabled-login --ingroup www-data kallithea
chown kallithea:www-data /opt/kallithea/
chown -R kallithea:www-data /opt/kallithea/repos
chown -R kallithea:www-data /opt/kallithea/data
chown -R kallithea:www-data /opt/kallithea/cfg
chmod -R o-rx /opt/kallithea/cfg

# start web-server
gearbox serve -c ${CFG_FILE} --user=kallithea
