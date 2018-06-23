#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

init() {
  # Remove the old ISO generation area if it exists.
  echo "Removing old ISO image work area. This may take a while."
  rm -rf $ISOIMAGE

  echo "Preparing new ISO image work area."
  mkdir -p $ISOIMAGE
}

prepare_mll_bios() {
  # This is the folder where we keep legacy BIOS boot artifacts.
  mkdir -p $ISOIMAGE/boot

  # Now we copy the kernel.
  cp $KERNEL_INSTALLED/kernel \
    $ISOIMAGE/boot/kernel.xz

  # Now we copy the root file system.
  cp $WORK_DIR/rootfs.cpio.xz \
    $ISOIMAGE/boot/rootfs.xz
}

prepare_overlay() {
  # Now we copy the overlay content if it exists.
  if [ -d $ISOIMAGE_OVERLAY \
    -a ! "`ls $ISOIMAGE_OVERLAY`" = "" ] ; then

    echo "The ISO image will have overlay structure."
    cp -r $ISOIMAGE_OVERLAY/* $ISOIMAGE
  else
    echo "The ISO image will have no overlay structure."
  fi
}

prepare_boot_bios() {
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

  # Find the Syslinux build directory.
  WORK_SYSLINUX_DIR=`ls -d $WORK_DIR/syslinux/syslinux-*`

  # Copy the precompiled files 'isolinux.bin' and 'ldlinux.c32'. These files
  # are used by Syslinux during the legacy BIOS boot process.
  mkdir -p $ISOIMAGE/boot/syslinux
  cp $WORK_SYSLINUX_DIR/bios/core/isolinux.bin \
    $ISOIMAGE/boot/syslinux
  cp $WORK_SYSLINUX_DIR/bios/com32/elflink/ldlinux/ldlinux.c32 \
    $ISOIMAGE/boot/syslinux
}

# Genrate 'El Torito' boot image as per UEFI sepcification 2.7,
# sections 13.3.1.x and 13.3.2.x.
prepare_boot_uefi() {
  # Find the build architecture based on the BusyBox executable.
  BUSYBOX_ARCH=$(file $ROOTFS/bin/busybox | cut -d' ' -f3)

  # Determine the proper UEFI configuration. The default image file
  # names are described in UEFI specification 2.7, section 3.5.1.1.
  # Note that the x86_64 UEFI image file name indeed contains small
  # letter 'x'.
  if [ "$BUSYBOX_ARCH" = "64-bit" ] ; then
    MLL_CONF=x86_64
    LOADER=$WORK_DIR/systemd-boot/systemd-boot*/uefi_root/EFI/BOOT/BOOTx64.EFI
  else
    MLL_CONF=x86
    LOADER=$WORK_DIR/systemd-boot/systemd-boot*/uefi_root/EFI/BOOT/BOOTIA32.EFI
  fi

  # Find the kernel size in bytes.
  kernel_size=`du -b $KERNEL_INSTALLED/kernel | awk '{print \$1}'`

  # Find the initramfs size in bytes.
  rootfs_size=`du -b $WORK_DIR/rootfs.cpio.xz | awk '{print \$1}'`

  loader_size=`du -b $LOADER | awk '{print \$1}'`

  # The EFI boot image is 64KB bigger than the kernel size.
  image_size=$((kernel_size + rootfs_size + loader_size + 65536))

  echo "Creating UEFI boot image file '$WORK_DIR/uefi.img'."
  rm -f $WORK_DIR/uefi.img
  truncate -s $image_size $WORK_DIR/uefi.img

  echo "Attaching hard disk image file to loop device."
  LOOP_DEVICE_HDD=$(losetup -f)
  losetup $LOOP_DEVICE_HDD $WORK_DIR/uefi.img

  echo "Formatting hard disk image with FAT filesystem."
  mkfs.vfat $LOOP_DEVICE_HDD

  echo "Preparing 'uefi' work area."
  rm -rf $WORK_DIR/uefi
  mkdir -p $WORK_DIR/uefi
  mount $WORK_DIR/uefi.img $WORK_DIR/uefi

#  # Add the configuration files for UEFI boot.
#  cp -r $SRC_DIR/minimal_boot/uefi/* \
#    $ISOIMAGE

  echo "Preparing kernel and rootfs."
  mkdir -p $WORK_DIR/uefi/minimal/$MLL_CONF
  cp $KERNEL_INSTALLED/kernel \
    $WORK_DIR/uefi/minimal/$MLL_CONF/kernel.xz
  cp $WORK_DIR/rootfs.cpio.xz \
    $WORK_DIR/uefi/minimal/$MLL_CONF/rootfs.xz

  echo "Preparing 'systemd-boot' UEFI boot loader."
  mkdir -p $WORK_DIR/uefi/EFI/BOOT
  cp $LOADER \
    $WORK_DIR/uefi/EFI/BOOT

  echo "Preparing 'systemd-boot' configuration."
  mkdir -p $WORK_DIR/uefi/loader/entries
  cp $SRC_DIR/minimal_boot/uefi/loader/loader.conf \
    $WORK_DIR/uefi/loader
  cp $SRC_DIR/minimal_boot/uefi/loader/entries/mll-${MLL_CONF}.conf \
    $WORK_DIR/uefi/loader/entries

  echo "Setting the default UEFI boot entry."
  sed -i "s|default.*|default mll-$MLL_CONF|" $WORK_DIR/uefi/loader/loader.conf

  echo "Unmounting UEFI boot image file."
  sync
  umount $WORK_DIR/uefi
  sync
  sleep 1

  # The directory is now empty (mount point for loop device).
  rm -rf $WORK_DIR/uefi

  # Make sure the UEFI boot image is readable.
  chmod ugo+r $WORK_DIR/uefi.img

  mkdir -p $ISOIMAGE/boot
  cp $WORK_DIR/uefi.img \
    $ISOIMAGE/boot
}

check_root() {
  if [ ! "$(id -u)" = "0" ] ; then
    cat << CEOF

  ISO image preparation process for UEFI systems requires root permissions
  but you don't have such permissions. Restart this script with root
  permissions in order to generate UEFI compatible ISO structure.

CEOF
    exit 1
  fi
}

echo "*** PREPARE ISO BEGIN ***"

# Read the 'FIRMWARE_TYPE' property from '.config'
FIRMWARE_TYPE=`read_property FIRMWARE_TYPE`
echo "Firmware type is '$FIRMWARE_TYPE'."

case $FIRMWARE_TYPE in
  bios)
    init
    prepare_boot_bios
    prepare_mll_bios
    prepare_overlay
    ;;

  uefi)
    check_root
    init
    prepare_boot_uefi
    prepare_overlay
    ;;

  both)
    check_root
    init
    prepare_boot_uefi
    prepare_boot_bios
    prepare_mll_bios
    prepare_overlay
    ;;

  *)
    echo "Firmware type '$FIRMWARE_TYPE' is not recognized. Cannot continue."
    exit 1
    ;;
esac


cd $SRC_DIR

echo "*** PREPARE ISO END ***"
