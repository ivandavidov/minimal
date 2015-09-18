#!/bin/sh

rm -f minimal_linux_live.iso

cd work/kernel
cd $(ls -d *)

# Edit Makefile to look for genisoimage instead of mkisofs. This was added as a
# workaround for some "Debian" and "Arch Linux" distributions. In general this
# fix should be harmless. 
sed -i 's/mkisofs/genisoimage/g' arch/x86/boot/Makefile

# Generate the ISO image with optimization for "parallel jobs" = "number of processors"
make isoimage FDINITRD=../../rootfs.cpio.gz -j $(grep ^processor /proc/cpuinfo | wc -l)

cp arch/x86/boot/image.iso ../../../minimal_linux_live.iso

cd ../../..

