#!/bin/bash
#set -x

source ${OWNCLOUD_BUILD_DIR}/env-defaults
source ${OWNCLOUD_BUILD_DIR}/functions

# Set permission
chown -R www-data ${OWNCLOUD_DATA_DIR}

# Config owncloud
occ_init

exec "$@"
