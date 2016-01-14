#!/bin/sh

cd work

# Remove the old initramfs archive if it exists.
rm -f rootfs.cpio.gz

cd rootfs

# Suggested update by John Jolly.
#
# find . | cpio -R root:root -H newc -o | gzip > ../rootfs.cpio.gz
#
# This produces a root fs with files and directories all owned by user 0, group 0.
# Note: test this change as soon as possible!
#
# Packs the current folder structure in "cpio.gz" archive.
find . | cpio -H newc -o | gzip > ../rootfs.cpio.gz

cd ../..

