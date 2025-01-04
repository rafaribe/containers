#!/bin/bash

# Set environment variables
export PDS_PORT=3000
export NODE_ENV=production
export UV_USE_IO_URING=0
export LOG_ENABLED="true"
export PDS_BLOB_UPLOAD_LIMIT="52428800"
export PDS_DATADIR="/pds"
export PDS_DATA_DIRECTORY="/pds"
export PDS_BLOBSTORE_DISK_LOCATION="${PDS_DATADIR}/blocks"
export PDS_DID_PLC_URL="https://plc.directory"
export PDS_BSKY_APP_VIEW_URL="https://api.bsky.app"
export PDS_BSKY_APP_VIEW_DID="did:web:api.bsky.app"
export PDS_REPORT_SERVICE_URL="https://mod.bsky.app"
export PDS_REPORT_SERVICE_DID="did:plc:ar7c4by46qjdydhdevvrndac"
export PDS_CRAWLERS="https://bsky.network"

# Ensure the data directory exists and has the correct permissions
mkdir -p "${PDS_DATADIR}"
chown -R pds:pds "${PDS_DATADIR}"

main() {
    if [[ -z "${PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX}" ]]; then
        echo "PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX not specified"
        exit 1
    fi

    # if hostname is not the same as the PDS_HOSTNAME then quit
    if [[ "${PDS_HOSTNAME}" != "${HOSTNAME}" ]]; then
        echo "PDS_HOSTNAME does not match the hostname"
        exit 1
    fi

    # create the config if it does not exist
    if [[ ! -f ${CONFIG_FILE} ]]; then
        echo "PDS_JWT_SECRET=${PDS_JWT_SECRET}" >${CONFIG_FILE}
        echo "PDS_ADMIN_PASSWORD=${PDS_ADMIN_PASSWORD}" >>${CONFIG_FILE}
        echo "PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX=${PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX}" >>${CONFIG_FILE}
        echo "PDS_HOSTNAME=${PDS_HOSTNAME}" >>${CONFIG_FILE}
        echo "PDS_CRAWLERS=https://bsky.network" >>${CONFIG_FILE}
    fi

    cat <<STARTED_MESSAGE
========================================================================
Bluesky PDS Started
------------------------------------------------------------------------

HOSTNAME: ${HOSTNAME}
PUBLIC_IP: ${PUBLIC_IP}
PDS_HOSTNAME: ${PDS_HOSTNAME}

========================================================================
STARTED_MESSAGE

    node --enable-source-maps index.js
}

main