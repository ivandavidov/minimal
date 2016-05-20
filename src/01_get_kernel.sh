#!/bin/sh

echo "*** GET KERNEL BEGIN ***"

SRC_DIR=$(pwd)

# Grab everything after the '=' character.
DOWNLOAD_URL=$(grep -i ^KERNEL_SOURCE_URL .config | cut -f2 -d'=')

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
  # Downloading kernel source bundle file. The '-c' option allows the download to resume.
  echo "Downloading kernel source bundle from $DOWNLOAD_URL"
  wget -c $DOWNLOAD_URL
else
  echo "Using local kernel source bundle $SRC_DIR/source/$ARCHIVE_FILE"
fi

# Delete folder with previously extracted kernel.
echo "Removing kernel work area. This may take a while..."
rm -rf ../work/kernel
mkdir ../work/kernel

# Extract kernel to folder 'work/kernel'.
# Full path will be something like 'work/kernel/linux-4.4.6'.
tar -xvf $ARCHIVE_FILE -C ../work/kernel

cd $SRC_DIR

echo "*** GET KERNEL END ***"

