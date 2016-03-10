#!/usr/bin/env bash -e

if [ -z "$1" ]; then
    >&2 echo "Usage: $0 [S3-BUCKET]"
    exit 1
fi

# The project's root directory.
PROJECT_DIR=$(dirname $0)/..

# Name of the user's default environment.
STACK_NAME=moonshot-sample-app-dev-$(echo $USER | sed 's/[^a-zA-Z0-9_]*//g')

# Creates the provisioning script and parameters file.
cp $PROJECT_DIR/bin/environment.dist $PROJECT_DIR/bin/environment
cp $PROJECT_DIR/cloud_formation/parameters/moonshot-sample-app.yml.dist $PROJECT_DIR/cloud_formation/parameters/$STACK_NAME.yml

# Changes the S3 bucket in the provisioning script and parameters file.
sed -i '' "s#{{bucket}}#$1#" "$PROJECT_DIR/bin/environment"
sed -i '' "s#{{bucket}}#$1#" "$PROJECT_DIR/cloud_formation/parameters/$STACK_NAME.yml"

# Create an index.php file, which is the "application".
cp $PROJECT_DIR/docroot/index.php.dist $PROJECT_DIR/docroot/index.php
