#!/bin/sh

rm -f minimal_linux_live.iso

cd work/kernel
cd $(ls -d *)

# Edit Makefile to look for genisoimage instead of mkisofs
sed -i 's/mkisofs/genisoimage/g' arch/x86/boot/Makefile

make isoimage FDINITRD=../../rootfs.cpio.gz
cp arch/x86/boot/image.iso ../../../minimal_linux_live.iso

cd ../../..

