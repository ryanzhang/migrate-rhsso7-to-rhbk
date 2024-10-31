#!/bin/bash
psql -U keycloak -d keycloak2 -c "SELECT * FROM public.migration_model;"
