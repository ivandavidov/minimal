#!/bin/sh

if [ -z "$BASE_DIR" ]; then
	BASE_DIR="`pwd`"
fi

. $BASE_DIR/.vars

rm -f minimal_linux_live.iso

cd $LINUX_DIR

if [ -z `which mkisofs` ]; then
	alias mkisofs="genisoimage"
fi

# Force Makefile to look for genisoimage instead of isoimage
sed -i 's/mkisofs/genisoimage/g' arch/x86/boot/Makefile

make isoimage FDINITRD=$WORK_DIR/rootfs.cpio.gz
cp arch/x86/boot/image.iso $BASE_DIR/minimal_linux_live.iso

cd $BASE_DIR

