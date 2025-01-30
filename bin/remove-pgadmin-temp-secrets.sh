#!/bin/bash

pushd $(git rev-parse --show-toplevel) > /dev/null

CONFIG="${1}"

if [[ ! -f "${CONFIG}" ]]; then
    echo "Add config file name"
    exit 1
fi

source ${CONFIG}

aws secretsmanager delete-secret --force-delete-without-recovery --secret-id "${APP_PREFIX}-cf-pgadmin-default-password"
aws secretsmanager delete-secret --force-delete-without-recovery --secret-id "${APP_PREFIX}-cf-pgadmin-default-username"
