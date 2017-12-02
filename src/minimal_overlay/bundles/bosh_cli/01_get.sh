#!/bin/sh

set -e

# Grab everything after the '=' character.
DOWNLOAD_URL=`grep -i ^BOSH_CLI_URL= $CONFIG | cut -f2- -d'=' | xargs`

# Read the 'USE_LOCAL_SOURCE' property from '.config'
USE_LOCAL_SOURCE="$(grep -i USE_LOCAL_SOURCE $MAIN_SRC_DIR/.config | cut -f2 -d'=')"

if [ "$USE_LOCAL_SOURCE" = "true" -a ! -f $MAIN_SRC_DIR/source/overlay/bosh-cli ] ; then
  echo "Shell script '$MAIN_SRC_DIR/source/overlay/bosh-cli' is missing and will be downloaded."
  USE_LOCAL_SOURCE="false"
fi

cd $MAIN_SRC_DIR/source/overlay

if [ ! "$USE_LOCAL_SOURCE" = "true" ] ; then
  # Downloading BOSH CLI binary. The '-c' option allows the download to resume.
  echo "Downloading BOSH CLI binary from $DOWNLOAD_URL"
  wget -O bosh-cli -c $DOWNLOAD_URL
else
  echo "Using local BOSH CLI binary '$MAIN_SRC_DIR/source/overlay/bosh-cli'."
fi

# Delete folder with previously prepared BOSH CLI.
echo "Removing BOSH CLI work area. This may take a while."
rm -rf $WORK_DIR/overlay/$BUNDLE_NAME
mkdir $WORK_DIR/overlay/$BUNDLE_NAME

# Copy bosh-cli to folder 'work/overlay/bosh_cli'.
cp bosh-cli $WORK_DIR/overlay/$BUNDLE_NAME

cd $SRC_DIR
