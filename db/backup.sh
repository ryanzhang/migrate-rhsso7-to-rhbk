#!/bin/bash
pg_dump -U keycloak -W -F t -f $2 $1

