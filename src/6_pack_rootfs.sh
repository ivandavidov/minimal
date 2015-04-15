#!/bin/sh

if [ -z "$BASE_DIR" ]; then
	# Standalone execution
	BASE_DIR="`pwd`"
	. $BASE_DIR/.vars
	rm -rf $OUT_DIR/rootfs.cpio.gz
fi

cd $ROOTFS

find . | cpio -H newc -o | gzip > $OUT_DIR/rootfs.cpio.gz

cd $BASE_DIR

