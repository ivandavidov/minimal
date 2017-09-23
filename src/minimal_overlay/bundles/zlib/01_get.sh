#!/bin/sh

SRC_DIR=$(pwd)

. ../../common.sh

# Grab everything after the '=' character.
DOWNLOAD_URL=$(grep -i ZLIB_SOURCE_URL $MAIN_SRC_DIR/.config | cut -f2 -d'=')

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

# Read the 'USE_LOCAL_SOURCE' property from '.config'
USE_LOCAL_SOURCE="$(grep -i USE_LOCAL_SOURCE $MAIN_SRC_DIR/.config | cut -f2 -d'=')"

if [ "$USE_LOCAL_SOURCE" = "true" -a ! -f $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE  ] ; then
  echo "Source bundle $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE is missing and will be downloaded."
  USE_LOCAL_SOURCE="false"
fi

cd $MAIN_SRC_DIR/source/overlay

if [ ! "$USE_LOCAL_SOURCE" = "true" ] ; then
  # Downloading ZLIB source bundle file. The '-c' option allows the download to resume.
  echo "Downloading ZLIB source bundle from $DOWNLOAD_URL"
  wget -c $DOWNLOAD_URL
else
  echo "Using local ZLIB source bundle $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE"
fi

# Delete folder with previously extracted ZLIB.
echo "Removing ZLIB work area. This may take a while..."
rm -rf $WORK_DIR/overlay/zlib
mkdir $WORK_DIR/overlay/zlib

# Extract ZLIB to folder 'work/overlay/zlib'.
# Full path will be something like 'work/overlay/zlib/zlib-1.2.11'.
tar -xvf $ARCHIVE_FILE -C $WORK_DIR/overlay/zlib

cd $SRC_DIR

