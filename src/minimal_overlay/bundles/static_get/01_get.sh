#!/bin/sh

set -e

. ../../common.sh

# Read the common configuration properties.
DOWNLOAD_URL=`read_property STATIC_GET_URL`
USE_LOCAL_SOURCE=`read_property USE_LOCAL_SOURCE`

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
echo "Removing static-get work area. This may take a while."
rm -rf $WORK_DIR/overlay/$BUNDLE_NAME
mkdir $WORK_DIR/overlay/$BUNDLE_NAME

# Copy static-get to folder 'work/overlay/static_get'.
cp static-get.sh $WORK_DIR/overlay/$BUNDLE_NAME

cd $SRC_DIR
