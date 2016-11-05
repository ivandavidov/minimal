#!/bin/sh

SRC_DIR=$(pwd)

if [ ! -d "$SRC_DIR/work/overlay/mll_utils" ] ; then
  echo "The directory $SRC_DIR/work/overlay/mll_utils does not exist. Cannot continue."
  exit 1
fi

# Copy all generated files to the source overlay folder.
cp -r $SRC_DIR/work/overlay/mll_utils/* \
  $SRC_DIR/work/src/minimal_overlay

echo "All utilities have been installed."

cd $SRC_DIR

