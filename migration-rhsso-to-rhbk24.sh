#!/bin/bash
set -x

# Set interval in seconds
interval=15

# Check Java version
java_version=$(java -version 2>&1 | grep "1.8")
if [ -z "$java_version" ]; then
    echo "Migration script needs to run under Java version 1.8"
    exit 1
fi

# Required files
required_files=("add-postgresql-datasource.cli" "rh-sso-7.1.0.zip" "rh-sso-7.2.0.zip" 
                "rh-sso-7.3.0.GA.zip" "rh-sso-7.4.0.zip" "rh-sso-7.5.0-server-dist.zip" 
                "rh-sso-7.6.0-server-dist.zip" "postgresql-42.7.4.jar" "rhbk-24.0.8.zip")

# Check if required files exist
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo "Error: Missing file $file"
        exit 1
    fi
done

# Validate x is within range [2,5]
x=2
y=24.0.8
while [ $x -le 6 ]; do
    # Unzip SSO version 7.x.0
    unzip -q "rh-sso-7.${x}.0*.zip" -d ./
    if [ $? -ne 0 ]; then
        echo "Failed to unzip rh-sso-7.${x}.0.zip"
        exit 1
    fi
    
    # Start the server in the background and suppress output
    ./rh-sso-7.${x}/bin/standalone.sh &> /dev/null &
    sleep $interval
    
    # Run JBoss CLI commands
    ./rh-sso-7.${x}/bin/jboss-cli.sh --connect --file=add-postgresql-datasource.cli

    ./rh-sso-7.${x}/bin/jboss-cli.sh --connect --command=:reload

    #sleep $interval

    ./rh-sso-7.${x}/bin/jboss-cli.sh --connect --command=:shutdown
    sleep 3
    
    rm -rf ./rh-sso-7.${x}

    echo "Upgrade to Red Hat SSO 7.${x}.0 completed."


    # Increment x for next upgrade
    ((x++))
done
