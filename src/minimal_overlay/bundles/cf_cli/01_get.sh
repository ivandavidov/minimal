#!/bin/sh

set -e

. ../../common.sh

# Read the common configuration properties.
DOWNLOAD_URL=`read_property CLOUD_FOUNDRY_CLI_URL`
USE_LOCAL_SOURCE=`read_property USE_LOCAL_SOURCE`

if [ "$USE_LOCAL_SOURCE" = "true" -a ! -f $MAIN_SRC_DIR/source/overlay/cf-cli.tgz ] ; then
  echo "Shell script $MAIN_SRC_DIR/source/overlay/cf-cli.tgz is missing and will be downloaded."
  USE_LOCAL_SOURCE="false"
fi

cd $MAIN_SRC_DIR/source/overlay

if [ ! "$USE_LOCAL_SOURCE" = "true" ] ; then
  # Downloading Cloud Foundry compressed binary archive. The '-c' option allows the download to resume.
  echo "Downloading Cloud Foundry compressed binary archive from $DOWNLOAD_URL"
  wget -O cf-cli.tgz -c $DOWNLOAD_URL
else
  echo "Using local cloud foundry compressed binary archive $MAIN_SRC_DIR/source/overlay/cf-cli.tgz"
fi

# Delete folder with previously prepared cloud foundry cli.
echo "Removing Cloud Foundry CLI work area. This may take a while."
rm -rf $WORK_DIR/overlay/$BUNDLE_NAME
mkdir $WORK_DIR/overlay/$BUNDLE_NAME

# Copy cf-cli.tgz to folder 'work/overlay/cf_cli'.
cp cf-cli.tgz $WORK_DIR/overlay/$BUNDLE_NAME

cd $SRC_DIR
