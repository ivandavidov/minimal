#!/bin/sh

echo "*** GET BUSYBOX BEGIN ***"

SRC_DIR=$(pwd)

# Grab everything after the '=' character.
DOWNLOAD_URL=$(grep -i ^BUSYBOX_SOURCE_URL .config | cut -f2 -d'=')

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

# Read the 'USE_LOCAL_SOURCE' property from '.config'
USE_LOCAL_SOURCE="$(grep -i ^USE_LOCAL_SOURCE .config | cut -f2 -d'=')"

if [ "$USE_LOCAL_SOURCE" = "true" -a ! -f $SRC_DIR/source/$ARCHIVE_FILE  ] ; then
  echo "Source bundle $SRC_DIR/source/$ARCHIVE_FILE is missing and will be downloaded."
  USE_LOCAL_SOURCE="false"
fi

cd source

if [ ! "$USE_LOCAL_SOURCE" = "true" ] ; then
  # Downloading BusyBox source bundle file. The '-c' option allows the download to resume.
  echo "Downloading BusyBox source bundle from $DOWNLOAD_URL"
  wget -c $DOWNLOAD_URL
else
  echo "Using local BusyBox source bundle $SRC_DIR/source/$ARCHIVE_FILE"
fi

# Delete folder with previously extracted busybox.
echo "Removing BusyBox work area. This may take a while..."
rm -rf ../work/busybox
mkdir ../work/busybox

# Extract busybox to folder 'busybox'.
# Full path will be something like 'work/busybox/busybox-1.24.2'.
tar -xvf $ARCHIVE_FILE -C ../work/busybox

cd $SRC_DIR

echo "*** GET BUSYBOX END ***"

