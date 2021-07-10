#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Read the common configuration properties.
INSTALL_PIP=`read_property INSTALL_PIP`

if [ "$INSTALL_PIP" = "true" ] ; then
  echo "Installing pip"
  $DEST_DIR/usr/bin/python3 get-pip.py
fi

cd $SRC_DIR
