#!/bin/sh

SRC_DIR=$(pwd)

. ../../common.sh

# Grab everything after the '=' character.
DOWNLOAD_URL=$(grep -i STATIC_GET_SOURCE_URL $MAIN_SRC_DIR/.config | cut -f2 -d'=')

# Read the 'USE_LOCAL_SOURCE' property from '.config'
USE_LOCAL_SOURCE="$(grep -i USE_LOCAL_SOURCE $MAIN_SRC_DIR/.config | cut -f2 -d'=')"

if [ "$USE_LOCAL_SOURCE" = "true" -a ! -f $MAIN_SRC_DIR/source/overlay/static-get.sh  ] ; then
  echo "Shell script $MAIN_SRC_DIR/source/overlay/static-get.sh is missing and will be downloaded."
  USE_LOCAL_SOURCE="false"
fi

cd $MAIN_SRC_DIR/source/overlay

if [ ! "$USE_LOCAL_SOURCE" = "true" ] ; then
  # Downloading static-get shell script file. The '-c' option allows the download to resume.
  echo "Downloading static-get shell script from $DOWNLOAD_URL"
  wget -O static-get.sh -c $DOWNLOAD_URL
else
  echo "Using local static-get shell script $MAIN_SRC_DIR/source/overlay/static-get.sh"
fi

# Delete folder with previously prepared static-get.
echo "Removing static-get work area. This may take a while..."
rm -rf $WORK_DIR/overlay/staget
mkdir $WORK_DIR/overlay/staget

# Copy static-get to folder 'work/overlay/staget'.
cp static-get.sh $WORK_DIR/overlay/staget

cd $SRC_DIR

