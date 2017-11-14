#!/bin/sh

SRC_DIR=$(pwd)

. ../../common.sh

# Grab everything after the '=' character.
DOWNLOAD_URL=$(grep -i COREUTILS_SOURCE_URL $MAIN_SRC_DIR/.config | cut -f2 -d'=')

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
  # Downloading coreutils source bundle file. The '-c' option allows the download to resume.
  echo "Downloading coreutils source bundle from $DOWNLOAD_URL"
  wget -c $DOWNLOAD_URL
else
  echo "Using local coreutils source bundle $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE"
fi

# Delete folder with previously extracted coreutils.
echo "Removing coreutils work area. This may take a while..."
rm -rf $WORK_DIR/overlay/coreutils
mkdir $WORK_DIR/overlay/coreutils

# Extract coreutils to folder 'work/overlay/coreutils'.
# Full path will be something like 'work/overlay/coreutils/coreutils-8.28'.
tar -xvf $ARCHIVE_FILE -C $WORK_DIR/overlay/coreutils

cd $SRC_DIR

