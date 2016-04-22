#!/bin/sh

cd work

# Remove the old 'initramfs' archive if it exists.
rm -f rootfs.cpio.gz

cd rootfs

# Packs the current 'initramfs' folder structure in 'cpio.gz' archive.
echo "Packing initramfs..."
find . | cpio -R root:root -H newc -o | gzip > ../rootfs.cpio.gz

cd ../..

