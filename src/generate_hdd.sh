#!/bin/sh

# Create sparse file of 20MB which can be used by QEMU.

if [ "$1" = "" ] ; then
  rm -f hdd.img
  truncate -s 20M hdd.img
elif [ "$1" = "-f" -o "$1" = "-folder" ] ; then
  if [ ! "$(id -u)" = "0" ] ; then
    echo "Using option '-f' (or '-folder') requires root permissions."
    exit 1
  fi
  
  echo "Create new hard disk image file with 20MB size."
  rm -f hdd.img
  truncate -s 20M hdd.img
  
  LOOP_DEVICE=$(losetup -f)
  
  echo "Attach hard disk image file to loop device."
  losetup $LOOP_DEVICE hdd.img
  
  echo "Format hard disk image file with Ext2 filesystem."
  mkfs.ext2 $LOOP_DEVICE
  
  echo "Mount hard disk image file to temporary folder."
  mkdir folder
  mount hdd.img folder
  
  echo "Create overlay structure."
  mkdir -p folder/minimal/rootfs
  mkdir -p folder/minimal/work
  
  echo "Create sample text file."
  echo "This file is on external hard disk." > folder/minimal/rootfs/overlay.txt 

  echo "Unmount hard disk image file."
  umount folder
  rm -rf folder
  
  echo "Detach hard disk image file from loop device."
  losetup -d $LOOP_DEVICE
  
  echo "Apply original ownership to hard disk image file."
  chown $(logname) hdd.img
elif [ "$1" = "-s" -o "$1" = "-sparse" ] ; then
  if [ ! "$(id -u)" = "0" ] ; then
    echo "Using option '-s' (or '-sparse') requires root permissions."
    exit 1
  fi
  
  echo "Create new hard disk image file with 20MB size."
  rm -f hdd.img
  truncate -s 20M hdd.img
  
  LOOP_DEVICE_HDD=$(losetup -f)
  
  echo "Attach hard disk image file to loop device."
  losetup $LOOP_DEVICE_HDD hdd.img
  
  echo "Format hard disk image file with FAT filesystem."
  mkfs.vfat $LOOP_DEVICE_HDD
  
  echo "Mount hard disk image file to temporary folder."
  mkdir sparse
  mount hdd.img sparse
  
  echo "Create new overlay image file with 1MB size."
  rm -f sparse/minimal.img
  truncate -s 1M sparse/minimal.img

  LOOP_DEVICE_OVL=$(losetup -f)
  echo "Attach overlay image file to loop device."
  losetup $LOOP_DEVICE_OVL sparse/minimal.img

  echo "Format overlay image file with Ext2 filesystem."
  mkfs.ext2 $LOOP_DEVICE_OVL

  echo "Mount overlay image file to temporary folder."
  mkdir ovl
  mount sparse/minimal.img ovl
  
  echo "Create overlay structure."
  mkdir -p ovl/rootfs
  mkdir -p ovl/work
  
  echo "Create sample text file."
  echo "This file is on external hard disk." > ovl/rootfs/overlay.txt

  echo "Apply root ownership to overlay content."
  chown -R root:root ovl

  echo "Unmount overlay image file."
  umount ovl
  sleep 1
  rm -rf ovl

  echo "Detach overlay image file from loop device."
  losetup -d $LOOP_DEVICE_OVL
  sleep 1

  echo "Unmount hard disk image file."
  umount sparse  
  sleep 1
  rm -rf sparse
  
  echo "Detach hard disk image file from loop device."
  losetup -d $LOOP_DEVICE_HDD
  sleep 1
  
  echo "Apply original ownership to hard disk image file."
  chown $(logname) hdd.img
else
  echo "Option '$1' is not recognized. Valid options are '-f' and '-s'."
fi
