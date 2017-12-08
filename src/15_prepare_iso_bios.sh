#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** PREPARE ISO (BIOS) BEGIN ***"

FORCE_UEFI=`read_property FORCE_UEFI`

if [ "$FORCE_UEFI" = "true" ] ; then
  echo "Skipping ISO image preparation for BIOS systems."
  exit 0
fi

# Find the Syslinux build directory.
WORK_SYSLINUX_DIR=`ls -d $WORK_DIR/syslinux/syslinux-*`

# Remove the old ISO generation area if it exists.
echo "Removing old ISO image work area. This may take a while."
rm -rf $ISOIMAGE

# This is the root folder of the ISO image.
echo "Preparing new ISO image work area."
mkdir -p $ISOIMAGE

# Now we copy the kernel.
cp $KERNEL_INSTALLED/kernel $ISOIMAGE/kernel.xz

# Now we copy the root file system.
cp $WORK_DIR/rootfs.cpio.xz $ISOIMAGE/rootfs.xz

# Now we copy the overlay content if it exists
if [ -d $ISOIMAGE_OVERLAY \
  -a ! "`ls $ISOIMAGE`" = "" ] ; then

  echo "The ISO image will have overlay structure."
  cp -r $ISOIMAGE_OVERLAY/* $ISOIMAGE
else
  echo "The ISO image will have no overlay structure."
fi

# Copy the precompiled files 'isolinux.bin' and 'ldlinux.c32' in the ISO image
# root folder.
cp $WORK_SYSLINUX_DIR/bios/core/isolinux.bin $ISOIMAGE
cp $WORK_SYSLINUX_DIR/bios/com32/elflink/ldlinux/ldlinux.c32 $ISOIMAGE

# Create the ISOLINUX configuration file.
cat << CEOF > $ISOIMAGE/syslinux.cfg
PROMPT 1
TIMEOUT 50
DEFAULT mll

SAY
SAY   ##################################################################
SAY   #                                                                #
SAY   #  Press <ENTER> to boot Minimal Linux Live or wait 5 seconds.   #
SAY   #                                                                #
SAY   #  Press <TAB> to view available boot entries or enter Syslinux  #
SAY   #  commands directly.                                            #
SAY   #                                                                #
SAY   ##################################################################
SAY 

LABEL mll
        LINUX kernel.xz
        APPEND vga=ask
        INITRD rootfs.xz

LABEL mll_nomodeset
        LINUX kernel.xz
        APPEND vga=ask nomodeset
        INITRD rootfs.xz
CEOF

cd $SRC_DIR

echo "*** PREPARE ISO (BIOS) END ***"
