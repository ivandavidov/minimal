#!/bin/sh

SRC_DIR=$(pwd)

. ../../common.sh

if [ ! -d "$WORK_DIR/overlay/mll_utils" ] ; then
  echo "The directory $WORK_DIR/overlay/mll_utils does not exist. Cannot continue."
  exit 1
fi

# Copy all generated files to the source overlay folder.
cp -r $WORK_DIR/overlay/mll_utils/* $WORK_DIR/src/minimal_overlay/rootfs

echo "All MLL utilities have been installed."

cd $SRC_DIR

