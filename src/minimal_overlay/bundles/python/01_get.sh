#!/bin/sh

set -e

. ../../common.sh

# Read the common configuration properties.
DOWNLOAD_URL=`read_property PYTHON_SOURCE_URL`
USE_LOCAL_SOURCE=`read_property USE_LOCAL_SOURCE`

INSTALL_PIP=`read_property INSTALL_PIP`
PIP_DOWNLOAD_URL=`read_property PIP_SOURCE_URL`
USE_LOCAL_PIP_SOURCE=`read_property USE_LOCAL_SOURCE`

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}
PIP_FILE=${PIP_DOWNLOAD_URL##*/}

if [ "$USE_LOCAL_SOURCE" = "true" -a ! -f $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE  ] ; then
  echo "Source bundle $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE is missing and will be downloaded."
  USE_LOCAL_SOURCE="false"
fi

if [ "$INSTALL_PIP" = "true" ] ; then
  if [ "$USE_LOCAL_PIP_SOURCE" = "true" -a ! -f $MAIN_SRC_DIR/source/overlay/$PIP_FILE  ] ; then
    echo "Pip installation $MAIN_SRC_DIR/source/overlay/$PIP_FILE is missing and will be downloaded."
    USE_LOCAL_PIP_SOURCE="false"
  fi
fi

cd $MAIN_SRC_DIR/source/overlay

if [ ! "$USE_LOCAL_SOURCE" = "true" ] ; then
  # Downloading python source bundle file. The '-c' option allows the download to resume.
  echo "Downloading PYTHON source bundle from $DOWNLOAD_URL"
  wget -c $DOWNLOAD_URL
else
  echo "Using local PYTHON source bundle $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE"
fi

if [ "$INSTALL_PIP" = "true" ] ; then
  if [ ! "$USE_LOCAL_PIP_SOURCE" = "true" ] ; then
    # Downloading pip source bundle file. The '-c' option allows the download to resume.
    echo "Downloading PIP source bundle from $PIP_DOWNLOAD_URL"
    wget -c $PIP_DOWNLOAD_URL
  else
    echo "Using local PIP source bundle $MAIN_SRC_DIR/source/overlay/$PIP_FILE"
  fi
fi

# Delete folder with previously extracted python.
echo "Removing PYTHON work area. This may take a while."
rm -rf $WORK_DIR/overlay/$BUNDLE_NAME
mkdir $WORK_DIR/overlay/$BUNDLE_NAME

# Extract python to folder 'work/overlay/python'.
# Full path will be something like 'work/overlay/python/Python-3.8.0'.
tar -xvf $ARCHIVE_FILE -C $WORK_DIR/overlay/$BUNDLE_NAME

if [ "$INSTALL_PIP" = "true" ] ; then
  # Copy the pip installation script
  cp $PIP_FILE $WORK_DIR/overlay/$BUNDLE_NAME/get-pip.py
fi

cd $SRC_DIR
