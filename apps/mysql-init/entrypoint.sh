#!/usr/bin/env bash

# This is most commonly set to the user 'root'
export INIT_MYSQL_SUPER_USER=${INIT_MYSQL_SUPER_USER:-root}
export INIT_MYSQL_PORT=${INIT_MYSQL_PORT:-3306}

printf "\e[1;32m%-6s\e[m\n" "INIT_MYSQL_HOST: ${INIT_MYSQL_HOST}"
printf "\e[1;32m%-6s\e[m\n" "INIT_MYSQL_SUPER_USER: ${INIT_MYSQL_SUPER_USER}"
printf "\e[1;32m%-6s\e[m\n" "INIT_MYSQL_USER: ${INIT_MYSQL_USER}"
printf "\e[1;32m%-6s\e[m\n" "INIT_MYSQL_DBNAME: ${INIT_MYSQL_DBNAME}"

if [[ -z "${INIT_MYSQL_HOST}"       ||
      -z "${INIT_MYSQL_SUPER_PASS}" ||
      -z "${INIT_MYSQL_USER}"       ||
      -z "${INIT_MYSQL_PASS}"       ||
      -z "${INIT_MYSQL_DBNAME}"
]]; then
    printf "\e[1;32m%-6s\e[m\n" "Invalid configuration - missing a required environment variable"
    [[ -z "${INIT_MYSQL_HOST}" ]]       && printf "\e[1;32m%-6s\e[m\n" "INIT_MYSQL_HOST: unset"
    [[ -z "${INIT_MYSQL_SUPER_PASS}" ]] && printf "\e[1;32m%-6s\e[m\n" "INIT_MYSQL_SUPER_PASS: unset"
    [[ -z "${INIT_MYSQL_USER}" ]]       && printf "\e[1;32m%-6s\e[m\n" "INIT_MYSQL_USER: unset"
    [[ -z "${INIT_MYSQL_PASS}" ]]       && printf "\e[1;32m%-6s\e[m\n" "INIT_MYSQL_PASS: unset"
    [[ -z "${INIT_MYSQL_DBNAME}" ]]     && printf "\e[1;32m%-6s\e[m\n" "INIT_MYSQL_DBNAME: unset"
    exit 1
fi

printf "\e[1;32m%-6s\e[m\n" "Attempting to connect to MySQL at ${INIT_MYSQL_HOST}:${INIT_MYSQL_PORT} as ${INIT_MYSQL_SUPER_USER}"

# Wait for MySQL to be ready
max_attempts=30
attempts=0
export MYSQL_PWD="${INIT_MYSQL_SUPER_PASS}"
until mariadb-admin ping -h"${INIT_MYSQL_HOST}" -P"${INIT_MYSQL_PORT}" -u"${INIT_MYSQL_SUPER_USER}" --silent; do
    if (( attempts == max_attempts )); then
        printf "\e[1;32m%-6s\e[m\n" "MySQL is not ready after ${max_attempts} attempts, exiting."
        exit 1
    fi
    printf "\e[1;32m%-6s\e[m\n" "Waiting for Host '${INIT_MYSQL_HOST}' on port '${INIT_MYSQL_PORT}' ..."
    attempts=$((attempts + 1))
    sleep 5
done

printf "\e[1;32m%-6s\e[m\n" "Successfully connected to MySQL at ${INIT_MYSQL_HOST}:${INIT_MYSQL_PORT}"

# Create user if it doesn't exist
mariadb -h"${INIT_MYSQL_HOST}" -P"${INIT_MYSQL_PORT}" -u"${INIT_MYSQL_SUPER_USER}" \
    -e "CREATE USER IF NOT EXISTS '${INIT_MYSQL_USER}'@'%' IDENTIFIED BY '${INIT_MYSQL_PASS}';"
printf "\e[1;32m%-6s\e[m\n" "User ${INIT_MYSQL_USER} created or already exists"

# Update user password
mariadb -h"${INIT_MYSQL_HOST}" -P"${INIT_MYSQL_PORT}" -u"${INIT_MYSQL_SUPER_USER}" \
    -e "ALTER USER '${INIT_MYSQL_USER}'@'%' IDENTIFIED BY '${INIT_MYSQL_PASS}';"
printf "\e[1;32m%-6s\e[m\n" "Password for user ${INIT_MYSQL_USER} updated"

# Create and grant privileges for each database
for db in ${INIT_MYSQL_DBNAME}; do
    # Create database if it doesn't exist
    mariadb -h"${INIT_MYSQL_HOST}" -P"${INIT_MYSQL_PORT}" -u"${INIT_MYSQL_SUPER_USER}" \
        -e "CREATE DATABASE IF NOT EXISTS ${db};"
    printf "\e[1;32m%-6s\e[m\n" "Database ${db} created or already exists"
    
    # Grant privileges
    mariadb -h"${INIT_MYSQL_HOST}" -P"${INIT_MYSQL_PORT}" -u"${INIT_MYSQL_SUPER_USER}" \
        -e "GRANT ALL PRIVILEGES ON ${db}.* TO '${INIT_MYSQL_USER}'@'%';"
    printf "\e[1;32m%-6s\e[m\n" "Granted all privileges on ${db} to ${INIT_MYSQL_USER}"
    
    # Initialize database if init file exists
    if [[ -f "/docker-entrypoint-initdb.d/${db}.sql" ]]; then
        printf "\e[1;32m%-6s\e[m\n" "Initializing ${db} with schema..."
        mariadb -h"${INIT_MYSQL_HOST}" -P"${INIT_MYSQL_PORT}" -u"${INIT_MYSQL_SUPER_USER}" "${db}" \
            < "/docker-entrypoint-initdb.d/${db}.sql"
        printf "\e[1;32m%-6s\e[m\n" "Database ${db} initialized with schema"
    fi
done

# Flush privileges
mariadb -h"${INIT_MYSQL_HOST}" -P"${INIT_MYSQL_PORT}" -u"${INIT_MYSQL_SUPER_USER}" \
    -e "FLUSH PRIVILEGES;"
printf "\e[1;32m%-6s\e[m\n" "Privileges flushed"