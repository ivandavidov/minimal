#!/bin/sh

cd work

# Remove the old initramfs archive if it exists.
rm -f rootfs.cpio.gz

cd rootfs

# Packs the current folder structure in "cpio.gz" archive.
find . | cpio -H newc -o | gzip > ../rootfs.cpio.gz

cd ../..

