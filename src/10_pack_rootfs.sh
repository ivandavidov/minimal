#!/bin/sh

SRC_DIR=$(pwd)

cd work

# Remove the old 'initramfs' archive if it exists.
rm -f rootfs.cpio.gz

cd rootfs

# Packs the current 'initramfs' folder structure in 'cpio.xz' archive.
echo "Packing initramfs..."
find . | cpio -R root:root -H newc -o | xz --check=none > ../rootfs.cpio.xz

cd cd $SRC_DIR

