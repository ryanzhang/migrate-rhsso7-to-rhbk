#!/bin/bash
interval=15
y=24.0.8

# Check for Java 17
java_version=$(java -version 2>&1 | awk -F[\".] '/version/ {print $2}')
required_version="17"

if [[ "$java_version" != "$required_version" ]]; then
  echo "Error: RHSSO requires Java 17 runtime to run."
  exit 1
fi


echo "Start to Migrate to RHBK-${y} "
unzip -q "rhbk-${y}.zip" -d ./
if [ $? -ne 0 ]; then
   echo "Failed to unzip rhbk-${y}.zip"
   exit 1
fi
cd rhbk-${y}
bin/kc.sh start-dev --db=postgres --db-url=jdbc:postgresql://db.galaxy/keycloak2 --db-username=keycloak  --db-password=keycloak 

echo "Upgrade to rhbk-${y} Completed!"
