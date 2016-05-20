#!/bin/sh

SRC_DIR=$(pwd)

echo "Cleaning up the overlay work area. This may take a while..."
rm -rf work/overlay
mkdir -p work/overlay

# Just in case we execute the overlay software generation script before we
# execute the main build script.
mkdir -p work/src/minimal_overlay

# -p stops errors if the directory already exists
mkdir -p source/overlay

cd minimal_overlay

for dir in $(ls -d */ 2>/dev/null) ; do
  rm -rf $dir
  echo "Overlay folder '$dir' has been removed."
done

echo "Ready to continue with the overlay software."

cd $SRC_DIR

