#!/bin/bash
psql -U keycloak -c "DROP DATABASE IF EXISTS keycloak2;"
psql -U keycloak -c "CREATE DATABASE keycloak2;"
pg_restore -U keycloak -d keycloak2 -1 $1
