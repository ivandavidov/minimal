#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** PACK ROOTFS BEGIN ***"

echo "Packing initramfs. This may take a while."

# Remove the old 'initramfs' artifacts.
rm -f $WORK_DIR/rootfs.cpio*

cd $ROOTFS

# Pack the current 'initramfs' folder structure in 'cpio.xz' archive.
find . | cpio -R root:root -H newc -o > $WORK_DIR/rootfs.cpio

# Pack the 'cpio' archive in 'cpio.xz' compressed archive.
cat $WORK_DIR/rootfs.cpio | xz -9 --check=none > $WORK_DIR/rootfs.cpio.xz

echo "Packing of initramfs has finished."

cd $SRC_DIR

echo "*** PACK ROOTFS END ***"
