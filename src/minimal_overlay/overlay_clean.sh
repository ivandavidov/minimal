#!/bin/sh

SRC_DIR=$(pwd)

echo "Cleaning up the overlay work area. This may take a while..."
rm -rf ../work/overlay

# -p stops errors if the directory already exists.
mkdir -p ../work/overlay
mkdir -p ../work/src/minimal_overlay/rootfs
mkdir -p ../source/overlay

cd ../work/src/minimal_overlay/rootfs

# Remove all previously generated overlay artifacts.
for dir in $(ls -d */ 2>/dev/null) ; do
  rm -rf $dir
  echo "Overlay folder '$dir' has been removed."
done

cd $SRC_DIR/../minimal_overlay/rootfs

# Copy the files/folders from the default overlay folder
for dir in $(ls -d */ 2>/dev/null) ; do
  cp -r $dir $SRC_DIR/../work/src/minimal_overlay/rootfs
  echo "Default overlay folder '$dir' has been prepared."
done
 
echo "Ready to continue with the overlay software."

cd $SRC_DIR

