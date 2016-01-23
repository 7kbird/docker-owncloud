#!/bin/bash
set -e
set -x

if [ ! -e '/var/www/html/version.php' ]; then
  tar cf - --one-file-system -C /usr/src/owncloud . | tar xf -
  chown -R www-data /var/www/html
fi

occ_cmd() {
    sudo -u www-data php /var/www/html/occ "$@"
}

# $1 config parent. e.g. system
# $2 config key. e.g. db_name
# $3 value
occ_config_set(){
    local value=${3}
    if [[ -z "${value}" ]]; then
	occ_cmd config:${1}:delete ${2}
    else
	occ_cmd config:${1}:set ${2} --value=${value}
    fi
}

# $1 config parent. e.g. system
# $2 config key. e.g. db_name
occ_config_get(){
    occ_cmd config:${1}:get ${2}
}

# install according to
# https://doc.owncloud.org/server/8.2/admin_manual/configuration_server/occ_command.html
if [[ -n "${MYSQL_PORT_3306_TCP_ADDR}" ]]; then
  DB_TYPE=${DB_TYPE:-mysql}
  DB_HOST=${DB_HOST:-mysql}
elif [[ -n "${POSTGRESQL_PORT_5432_TCP_ADDR}" ]]; then
  DB_TYPE=${DB_TYPE:-pgsql}
  DB_HOST=${DB_HOST:-postgresql}
else
  DB_TYPE=${DB_TYPE:-sqlite}
  DB_HOST=${DB_HOST:-localhost}
fi

DB_NAME=${DB_NAME:-owncloud}
DB_USER=${DB_USER:-owncloud}
DB_PASS=${DB_PASS:-}

ADMIN_USER=${ADMIN_USER:-admin}
if [[ -z "${ADMIN_PASS}" ]]; then
    echo "Admin password empty.Please set environment ADMIN_PASS"
    exit -2
fi

DATA_DIR="/var/www/html/data"

if [[ -n "$(occ_cmd help maintenance:install | grep 'not installed')" ]]; then
    echo "Start fresh install"
    sudo -u www-data php /var/www/html/occ maintenance:install \
	--database="$DB_TYPE" \
	--database-host="${DB_HOST}" \
	--database-name="${DB_NAME}" \
	--database-user="${DB_USER}" \
	--database-pass="${DB_PASS}" \
	--admin-user="${ADMIN_USER}" \
	--admin-pass="${ADMIN_PASS}" \
	--data-dir="${DATA_DIR}" \
	--no-interaction
else
    #[[ "${DB_TYPE}" == "sqlite" ]] && DB_TYPE="sqlite3"
    occ_config_set system dbtype "${DB_TYPE}"   # TODO: db:convert-type
    occ_config_set system dbhost "${DB_HOST}"
    occ_config_set system dbname "${DB_NAME}"
    occ_config_set system dbuser "${DB_USER}"
    occ_config_set system dbpassword "${DB_PASS}"
    occ_config_set system datadirectory "${DATA_DIR}"
fi

#APPSTORE_ENABLED=${APPSTORE_ENABLED:-false}
#APPSTORE_URL=${APPSTORE_URL:-https://api.owncloud.com/v1}

#occ_config_set system appstoreenabled "${APPSTORE_ENABLED}"
#occ_config_set system appstoreurl "${APPSTORE_URL}"

exec "$@"
