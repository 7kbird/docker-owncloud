#!/bin/bash
source ${OWNCLOUD_BUILD_DIR}/env-defaults
source ${OWNCLOUD_BUILD_DIR}/functions

# Create folder for empty volume mount
mkdir -p "${OWNCLOUD_DATA_DIR}"
if ! [[ -d "${OWNCLOUD_STORE_DIR}/config" ]]; then
    cp -r "${OWNCLOUD_ROOT_DIR}/config_back" "${OWNCLOUD_STORE_DIR}/config"
fi

# Set permission
chown -R www-data "${OWNCLOUD_STORE_DIR}"

# Config owncloud
occ_init_config

exec "$@"
