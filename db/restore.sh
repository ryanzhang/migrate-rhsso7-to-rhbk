#!/bin/bash
psql -U keycloak -c "DROP DATABASE IF EXISTS keycloak18;"
psql -U keycloak -c "CREATE DATABASE keycloak18;"
pg_restore -U keycloak -d keycloak18 -1 keycloak18-202410270901.tar
