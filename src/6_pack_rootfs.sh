#!/bin/sh

if [ -z "$BASE_DIR" ]; then
	BASE_DIR="`pwd`"
fi

. $BASE_DIR/.vars

cd $WORK_DIR

rm -f rootfs.cpio.gz

cd $ROOTFS

find . | cpio -H newc -o | gzip > $WORK_DIR/rootfs.cpio.gz

cd $BASE_DIR

