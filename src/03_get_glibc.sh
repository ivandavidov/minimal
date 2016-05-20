#!/bin/sh

echo "*** GET GLIBC BEGIN ***"

SRC_DIR=$(pwd)

# Grab everything after the '=' character.
DOWNLOAD_URL=$(grep -i ^GLIBC_SOURCE_URL .config | cut -f2 -d'=')

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
  # Downloading glibc source bundle file. The '-c' option allows the download to resume.
  echo "Downloading glibc source bundle from $DOWNLOAD_URL"
  wget -c $DOWNLOAD_URL
else
  echo "Using local glibc source bundle $SRC_DIR/source/$ARCHIVE_FILE"
fi

# Delete folder with previously extracted glibc.
echo "Removing glibc work area. This may take a while..."
rm -rf ../work/glibc
mkdir ../work/glibc

# Extract glibc to folder 'work/glibc'.
# Full path will be something like 'work/glibc/glibc-2.23'.
tar -xvf $ARCHIVE_FILE -C ../work/glibc

cd $SRC_DIR

echo "*** GET GLIBC END ***"

