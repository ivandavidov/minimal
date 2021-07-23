#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** PACK ROOTFS BEGIN ***"

echo "Packing initramfs. This may take a while."

# Remove the old 'initramfs' archive if it exists.
rm -f $WORK_DIR/rootfs.cpio.xz

cd $ROOTFS

# Packs the current 'initramfs' folder structure in 'cpio.xz' archive.
find . | cpio -R root:root -H newc -o | xz -9 --check=crc32 > $WORK_DIR/rootfs.cpio.xz

echo "Packing of initramfs has finished."

cd $SRC_DIR

echo "*** PACK ROOTFS END ***"
