#!/bin/sh

echo "*** PACK ROOTFS BEGIN ***"

SRC_DIR=$(pwd)

cd work

echo "Packing initramfs. This may take a while..."

# Remove the old 'initramfs' archive if it exists.
rm -f rootfs.cpio.gz

cd rootfs

# Packs the current 'initramfs' folder structure in 'cpio.xz' archive.
find . | cpio -R root:root -H newc -o | xz -9 --check=none > ../rootfs.cpio.xz

echo "Packing of initramfs has finished."

cd $SRC_DIR

echo "*** PACK ROOTFS END ***"

