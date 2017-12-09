#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** PREPARE ISO (UEFI) BEGIN ***"

generate_uefi_boot_image() (
  # Find the kernel size in bytes.
  kernel_size=`du -b $KERNEL_INSTALLED/kernel | awk '{print \$1}'`
  
  # The EFI boot image is 64KB bigger than the kernel size.
  image_size=$((kernel_size + 65536))
  
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

  mkdir -p $WORK_DIR/uefi/efi/boot

  echo "Preparing EFI stub."
  BUSYBOX_ARCH=$(file $ROOTFS/bin/busybox | cut -d' ' -f3)
  if [ "$BUSYBOX_ARCH" = "64-bit" ] ; then
    cp $KERNEL_INSTALLED/kernel \
      $WORK_DIR/uefi/efi/boot/bootx64.efi
  else
    cp $KERNEL_INSTALLED/kernel \
      $WORK_DIR/uefi/efi/boot/bootia32.efi  
  fi
  
  echo "Unmounting UEFI boot image file."
  sync
  umount $WORK_DIR/uefi
  sync
  sleep 1
  
  chmod ugo+r $WORK_DIR/uefi.img
)

FORCE_UEFI=`read_property FORCE_UEFI`

if [ ! "$FORCE_UEFI" = "true" ] ; then
  echo "Skipping ISO image preparation for UEFI systems."
  exit 0
fi

if [ ! "$(id -u)" = "0" ] ; then
  cat << CEOF
  
  ISO image preparation process for UEFI systems requires root permissions
  but you don't have such permissions. Restart this script with root
  permissions in order to generate UEFI compatible ISO structure.
  
CEOF
  exit 1
fi

# Find the Syslinux build directory.
WORK_SYSLINUX_DIR=`ls -d $WORK_DIR/syslinux/syslinux-*`

# Remove the old ISO generation area if it exists.
echo "Removing old ISO image work area. This may take a while."
rm -rf $ISOIMAGE

# This is the root folder of the ISO image.
echo "Preparing new ISO image work area."
mkdir -p $ISOIMAGE

# Generate the UEFI boot image which contains the kernel (with
# packed initramfs) as default EFI stub.
generate_uefi_boot_image

cp $WORK_DIR/uefi.img $ISOIMAGE

# Now we copy the overlay content if it exists
if [ -d $ISOIMAGE_OVERLAY \
  -a ! "`ls $ISOIMAGE`" = "" ] ; then

  echo "The ISO image will have overlay structure."
  cp -r $ISOIMAGE_OVERLAY/* $ISOIMAGE
else
  echo "The ISO image will have no overlay structure."
fi

cd $SRC_DIR

echo "*** PREPARE ISO (UEFI) END ***"
