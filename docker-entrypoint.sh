#!/bin/bash
set -e
#set -x

source ${OWNCLOUD_BUILD_DIR}/env-defaults
source ${OWNCLOUD_BUILD_DIR}/functions

# Create folder for empty volume mount
mkdir -p "/owncloud_data/config" "/owncloud_data/data"

# Set permission
chown -R www-data /owncloud_data

# Config owncloud
occ_init_basic

exec "$@"
