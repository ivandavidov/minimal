#!/bin/sh

set -e

echo "*** PREPARE ISO BEGIN ***"

SRC_DIR=$(pwd)

# Save the kernel installation directory.
KERNEL_INSTALLED=$SRC_DIR/work/kernel/kernel_installed

# Find the Syslinux build directory.
cd work/syslinux
cd $(ls -d *)
WORK_SYSLINUX_DIR=$(pwd)
cd $SRC_DIR

# Remove the old ISO generation area if it exists.
echo "Removing old ISO image work area. This may take a while."
rm -rf work/isoimage

# This is the root folder of the ISO image.
echo "Preparing new ISO image work area."
mkdir work/isoimage

cd work/isoimage

# Now we copy the kernel.
cp $KERNEL_INSTALLED/kernel ./kernel.xz

# Now we copy the root file system.
cp ../rootfs.cpio.xz ./rootfs.xz

# Now we copy the overlay content if it exists
if [ -d $SRC_DIR/work/isoimage_overlay \
  -a ! "`ls $SRC_DIR/work/isoimage_overlay`" = "" ] ; then

  echo "The ISO image will have overlay structure."
  cp -r $SRC_DIR/work/isoimage_overlay/* .
else
  echo "The ISO image will have no overlay structure."
fi

# Copy the precompiled files 'isolinux.bin' and 'ldlinux.c32' in the ISO image
# root folder.
cp $WORK_SYSLINUX_DIR/bios/core/isolinux.bin .
cp $WORK_SYSLINUX_DIR/bios/com32/elflink/ldlinux/ldlinux.c32 .

# Create the ISOLINUX configuration file.
cat << CEOF > ./syslinux.cfg
PROMPT 1
TIMEOUT 50
DEFAULT mll

SAY Press enter to boot minimal linux or wait 5 seconds
SAY Press tab to view available boot entries or enter syslinux commands directly

LABEL mll
	SAY Now booting minimal linux
        LINUX kernel.xz
        APPEND vga=ask
        INITRD rootfs.xz

LABEL mll_nomodeset
	SAY Now booting minimal linux with 'nomodeset'
        LINUX kernel.xz
        APPEND vga=ask nomodeset
        INITRD rootfs.xz
CEOF

# Create UEFI start script.
mkdir -p efi/boot
cat << CEOF > ./efi/boot/startup.nsh
echo -off
echo Minimal Linux Live is starting.
\\kernel.xz initrd=\\rootfs.xz
CEOF

cd $SRC_DIR

echo "*** PREPARE ISO END ***"
