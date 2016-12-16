#!/bin/bash

source .config

SRC_DIR=$(pwd)

# Grab everything after the '=' character.
#DOWNLOAD_URL=$(grep -i DROPBEAR_SOURCE_URL .config | cut -f2 -d'=')
DOWNLOAD_URL=$DROPBEAR_SOURCE_URL
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
  # Downloading Dropbear source bundle file. The '-c' option allows the download to resume.
  echo "Downloading Links source bundle from $DOWNLOAD_URL"
  wget -c $DOWNLOAD_URL
else
  echo "Using local Dropbear source bundle $SRC_DIR/source/overlay/$ARCHIVE_FILE"
fi

# Delete folder with previously extracted Dropbear.
echo "Removing Dropbear work area. This may take a while..."
rm -rf work/overlay/dropbear
mkdir ../../work/overlay/dropbear

# Extract Dropbear to folder 'work/overlay/dropbear'.
# Full path will be something like 'work/overlay/dropbear/dropbear-2016.73'.
tar -xvf $ARCHIVE_FILE -C ../../work/overlay/dropbear

cd $SRC_DIR

