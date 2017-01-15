#!/bin/sh

SRC_DIR=$(pwd)

# Find the main source directory
cd ../../..
MAIN_SRC_DIR=$(pwd)
cd $SRC_DIR

if [ ! -d "$MAIN_SRC_DIR/work/overlay/mll_utils" ] ; then
  echo "The directory $MAIN_SRC_DIR/work/overlay/mll_utils does not exist. Cannot continue."
  exit 1
fi

# Copy all generated files to the source overlay folder.
cp -r $MAIN_SRC_DIR/work/overlay/mll_utils/* \
  $MAIN_SRC_DIR/work/src/minimal_overlay/rootfs

echo "All MLL utilities have been installed."

cd $SRC_DIR

