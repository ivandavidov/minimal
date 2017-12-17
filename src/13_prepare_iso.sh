#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** PREPARE ISO BEGIN ***"

# Find the Syslinux build directory.
WORK_SYSLINUX_DIR=`ls -d $WORK_DIR/syslinux/syslinux-*`

# Remove the old ISO generation area if it exists.
echo "Removing old ISO image work area. This may take a while."
rm -rf $ISOIMAGE

echo "Preparing new ISO image work area."
mkdir -p $ISOIMAGE

# This is the folder where we keep legacy BIOS boot artifacts.
mkdir -p $ISOIMAGE/boot

# Now we copy the kernel.
cp $KERNEL_INSTALLED/kernel \
  $ISOIMAGE/boot/kernel.xz

# Now we copy the root file system.
cp $WORK_DIR/rootfs.cpio.xz \
  $ISOIMAGE/boot/rootfs.xz

# Now we copy the overlay content if it exists
if [ -d $ISOIMAGE_OVERLAY \
  -a ! "`ls $ISOIMAGE_OVERLAY`" = "" ] ; then

  echo "The ISO image will have overlay structure."
  cp -r $ISOIMAGE_OVERLAY/* $ISOIMAGE
else
  echo "The ISO image will have no overlay structure."
fi

# Add the Syslinux configuration files for legacy BIOS and additional
# UEFI startup script.
#
# The existing UEFI startup script does not guarantee that you can run
# MLL on UEFI systems. This script is invoked only in case your system
# drops you in UEFI shell with support level 1 or above. See UEFI shell
# specification 2.2, section 3.1. Depending on your system configuration
# you may not end up with UEFI shell even if your system supports it.
# In this case MLL will not boot and you will end up with some kind of
# UEFI error message.
cp -r $SRC_DIR/minimal_boot/bios/* \
  $ISOIMAGE

# Copy the precompiled files 'isolinux.bin' and 'ldlinux.c32'. These files
# are used by Syslinux during the legacy BIOS boot process.
mkdir -p $ISOIMAGE/boot/syslinux
cp $WORK_SYSLINUX_DIR/bios/core/isolinux.bin \
  $ISOIMAGE/boot/syslinux
cp $WORK_SYSLINUX_DIR/bios/com32/elflink/ldlinux/ldlinux.c32 \
  $ISOIMAGE/boot/syslinux

cd $SRC_DIR

echo "*** PREPARE ISO END ***"
