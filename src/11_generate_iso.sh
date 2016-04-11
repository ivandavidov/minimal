#!/bin/sh

# Find the kernel build directory.
cd work/kernel
cd $(ls -d *)
WORK_KERNEL_DIR=$(pwd)
cd ../../..

# Find the Syslinux build directory.
cd work/syslinux
cd $(ls -d *)
WORK_SYSLINUX_DIR=$(pwd)
cd ../../..

# Remove the old ISO file if it exists.
rm -f minimal_linux_live.iso

# Remove the old ISO generation area if it exists.
rm -rf work/isoimage

# This is the root folder of the ISO image.
mkdir work/isoimage
cd work/isoimage

# Copy the precompiled files 'isolinux.bin' and 'ldlinux.c32' in the ISO image root folder.
cp $WORK_SYSLINUX_DIR/bios/core/isolinux.bin .
cp $WORK_SYSLINUX_DIR/bios/com32/elflink/ldlinux/ldlinux.c32 .

# Now we copy the kernel.
cp $WORK_KERNEL_DIR/arch/x86/boot/bzImage ./kernel.bz

# Now we copy the root file system.
cp ../rootfs.cpio.gz ./rootfs.gz

# Copy all source files to '/src'. Note that the scripts won't work there.
mkdir src
cp ../../*.sh src
cp ../../.config src
cp ../../*.txt src
chmod +rx src/*.sh
chmod +r src/.config
chmod +r src/*.txt

# Create the overlay directory '/minimal/rootfs'. All files in this folder are
# merged in the root folder and can be manipulated thanks to overlayfs.
mkdir -p minimal/rootfs
cd minimal/rootfs
echo 'Sample file 1 from CD.' > file_from_cd_1.txt
echo 'Sample file 2 from CD.' > file_from_cd_2.txt
cd ../..

# Create ISOLINUX configuration file.
echo 'default kernel.bz  initrd=rootfs.gz' > ./isolinux.cfg

# Now we generate the ISO image file.
genisoimage -J -r -o ../minimal_linux_live.iso -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table ./

# This allows the ISO image to be bootable if it is burned on USB flash drive.
isohybrid ../minimal_linux_live.iso 2>/dev/null || true

# Copy the ISO image to the root project folder.
cp ../minimal_linux_live.iso ../../

cd ../..

