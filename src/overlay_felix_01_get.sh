#!/bin/sh

set -e

SRC_DIR=$(pwd)

# Grab everything after the '=' character.
DOWNLOAD_URL=$(grep -i FELIX_SOURCE_URL .config | cut -f2 -d'=')

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

# Read the 'USE_LOCAL_SOURCE' property from '.config'
USE_LOCAL_SOURCE="$(grep -i USE_LOCAL_SOURCE .config | cut -f2 -d'=')"

if [ "$USE_LOCAL_SOURCE" = "true" -a ! -f $SRC_DIR/source/overlay/$ARCHIVE_FILE  ] ; then
  echo "Source bundle $SRC_DIR/source/overlay/$ARCHIVE_FILE is missing and will be downloaded."
  USE_LOCAL_SOURCE="false"
fi

cd source/overlay

if [ ! "$USE_LOCAL_SOURCE" = "true" ] ; then
  # Downloading Apache Felix source bundle file. The '-c' option allows the download to resume.
  echo "Downloading Apache Felix source bundle from $DOWNLOAD_URL"
  wget -c $DOWNLOAD_URL
else
  echo "Using local Apache Felix source bundle $SRC_DIR/source/overlay/$ARCHIVE_FILE"
fi

# Delete folder with previously extracted Felix.
echo "Removing Apache Felix work area. This may take a while..."
rm -rf ../../work/overlay/felix
mkdir ../../work/overlay/felix

# Extract Felix to folder 'work/overlay/felix'.
# Full path will be something like 'work/overlay/felix/felix-framework-5.4.0'.
tar -xvf $ARCHIVE_FILE -C ../../work/overlay/felix

cd $SRC_DIR

