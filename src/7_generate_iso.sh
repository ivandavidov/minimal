#!/bin/sh

if [ -z "$BASE_DIR" ]; then
	# Standalone execution
	BASE_DIR="`pwd`"
	. $BASE_DIR/.vars
	rm -rf $OUT_DIR/minimal_linux_live.iso
fi

cd $LINUX_DIR

if [ -z `which mkisofs` ]; then
	alias mkisofs="genisoimage"
fi

# Force Makefile to look for genisoimage instead of isoimage
sed -i 's/mkisofs/genisoimage/g' arch/x86/boot/Makefile

make isoimage FDINITRD=$OUT_DIR/rootfs.cpio.gz
cp arch/x86/boot/image.iso $OUT_DIR/minimal_linux_live.iso

cd $BASE_DIR

