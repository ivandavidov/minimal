#!/bin/sh

cd work

rm -f rootfs.cpio.gz

cd rootfs

find . | cpio -H newc -o | gzip > ../rootfs.cpio.gz

cd ../..
