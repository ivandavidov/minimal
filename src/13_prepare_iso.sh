#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** PREPARE ISO BEGIN ***"

# Find the Syslinux build directory.
cd `ls -d $WORK_DIR/syslinux/*`
WORK_SYSLINUX_DIR=$PWD

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

# Create UEFI start script '/efi/boot/startup.nsh'. This script should be
# executed by the firmware on boot if there is no UEFI compatible 'eltorito'
# boot image in the ISO image *and* the UEFI boot shell is enabled.
#
# Currently MLL doesn't provide native UEFI stub for boot manager and this
# script is the only UEFI compliant way to pass the execution from the
# firmware to the kernel. All this script does is to execute the kernel
# which is masquaraded as PE/COFF image and pass arguments to the kernel,
# e.g. 'initrd=<initramfs_archive>' and 'nomodeset'.
#
# Currently the 'startup.nsh' approach is most likely not universally
# compatible. For example, this approach most probably will fail on UEFI
# systems where the boot shell is missing or it is disabled.
mkdir -p $ISOIMAGE/EFI/boot
cat << CEOF > $ISOIMAGE/EFI/boot/startup.nsh
echo -off
echo Minimal Linux Live is starting.
\\kernel.xz initrd=\\rootfs.xz nomodeset

CEOF

# UEFI hacks BEGIN
#
# These files have no impact on the BIOS boot process. In
# UEFI boot shell navigate to 'EFI/minimal' and try to
# execute 'bootia32.efi' or 'bootx64.efi'.
#
# TODO - remove before next MLL release or fix the UEFI issue.
#        The proper way to fix the UEFI issue is to provide
#        secondary 'eltorito' boot image which is FAT32 and
#        contains proper /EFI/boot/xxx files.

mkdir -p $ISOIMAGE/EFI/minimal

cp $WORK_SYSLINUX_DIR/efi32/efi/syslinux.efi \
  $ISOIMAGE/EFI/minimal/bootia32.efi
cp $WORK_SYSLINUX_DIR/efi32/com32/elflink/ldlinux/ldlinux.e32 \
  $ISOIMAGE/EFI/minimal

cp $WORK_SYSLINUX_DIR/efi64/efi/syslinux.efi \
  $ISOIMAGE/EFI/minimal/bootx64.efi
cp $WORK_SYSLINUX_DIR/efi64/com32/elflink/ldlinux/ldlinux.e64 \
  $ISOIMAGE/EFI/minimal

# UEFI hacks END

cd $SRC_DIR

echo "*** PREPARE ISO END ***"
