#!/bin/sh

set -e

. ../../common.sh

# Read the common configuration properties.
DOWNLOAD_URL=`read_property DROPBEAR_SOURCE_URL`
USE_LOCAL_SOURCE=`read_property USE_LOCAL_SOURCE`

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

if [ "$USE_LOCAL_SOURCE" = "true" -a ! -f $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE ] ; then
  echo "Source bundle $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE is missing and will be downloaded."
  USE_LOCAL_SOURCE="false"
fi

cd $MAIN_SRC_DIR/source/overlay

if [ ! "$USE_LOCAL_SOURCE" = "true" ] ; then
  # Downloading Dropbear source bundle file. The '-c' option allows the download to resume.
  echo "Downloading Dropbear source bundle from $DOWNLOAD_URL"
  wget -c $DOWNLOAD_URL
else
  echo "Using local Dropbear source bundle $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE"
fi

# Delete folder with previously extracted Dropbear.
echo "Removing Dropbear work area. This may take a while."
rm -rf $WORK_DIR/overlay/$BUNDLE_NAME
mkdir $WORK_DIR/overlay/$BUNDLE_NAME

# Extract Dropbear to folder 'work/overlay/dropbear'.
# Full path will be something like 'work/overlay/dropbear/dropbear-2016.73'.
tar -xvf $ARCHIVE_FILE -C $WORK_DIR/overlay/$BUNDLE_NAME

cd $SRC_DIR
