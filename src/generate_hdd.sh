#!/bin/sh

set -e

# Create sparse file of 20MB which can be used by QEMU.

if [ "$1" = "-e" -o "$1" = "--empty" ] ; then
  # Create new hard disk image file.
  rm -f hdd.img
  truncate -s 20M hdd.img
  echo "Created new hard disk image file 'hdd.img' with 20MB size."
elif [ "$1" = "-f" -o "$1" = "--folder" ] ; then
  if [ ! "$(id -u)" = "0" ] ; then
    echo "Using option '-f' (or '--folder') requires root permissions."
    exit 1
  fi

  rm -f hdd.img
  truncate -s 20M hdd.img
  echo "Created new hard disk image file 'hdd.img' with 20MB size."

  LOOP_DEVICE=$(losetup -f)
  losetup $LOOP_DEVICE hdd.img
  echo "Attached hard disk image file to loop device."

  mkfs.ext2 $LOOP_DEVICE
  echo "Hard disk image file has been formatted with Ext2 filesystem."

  mkdir folder
  mount hdd.img folder
  echo "Mounted hard disk image file to temporary folder."

  mkdir -p folder/minimal/rootfs
  mkdir -p folder/minimal/work
  echo "Overlay structure has been created."

  echo "This file is on external hard disk." > folder/minimal/rootfs/overlay.txt
  echo "Created sample text file."

  sync
  umount folder
  sync
  rm -rf folder
  echo "Unmounted hard disk image file."

  losetup -d $LOOP_DEVICE
  echo "Detached hard disk image file from loop device."

  # Find the original user. Note that this may not always be correct.
  ORIG_USER=`who | awk '{print \$1}'`
  chown $ORIG_USER hdd.img
  echo "Applied original ownership to hard disk image file."
elif [ "$1" = "-s" -o "$1" = "--sparse" ] ; then
  if [ ! "$(id -u)" = "0" ] ; then
    echo "Using option '-s' (or '--sparse') requires root permissions."
    exit 1
  fi

  rm -f hdd.img
  truncate -s 20M hdd.img
  echo "Created new hard disk image file 'hdd.img' with 20MB size."

  LOOP_DEVICE_HDD=$(losetup -f)
  losetup $LOOP_DEVICE_HDD hdd.img
  echo "Attached hard disk image file to loop device."

  mkfs.vfat $LOOP_DEVICE_HDD
  echo "Hard disk image file has been formatted with FAT filesystem."

  rm -rf sparse
  mkdir sparse
  mount hdd.img sparse
  echo "Mounted hard disk image file to temporary folder."

  rm -f sparse/minimal.img
  truncate -s 3M sparse/minimal.img
  echo "Created new overlay image file with 3MB size."

  LOOP_DEVICE_OVL=$(losetup -f)
  losetup $LOOP_DEVICE_OVL sparse/minimal.img
  echo "Attached overlay image file to loop device."

  mkfs.ext2 $LOOP_DEVICE_OVL
  echo "Overlay image file has been formatted with Ext2 filesystem."

  mkdir ovl
  mount sparse/minimal.img ovl
  echo "Mounted overlay image file to temporary folder."

  mkdir -p ovl/rootfs
  mkdir -p ovl/work
  echo "Overlay structure has been created."

  echo "Create sample text file."
  echo "This file is on external hard disk." > ovl/rootfs/overlay.txt

  chown -R root:root ovl
  echo "Applied root ownership to overlay content."

  sync
  umount ovl
  sync
  sleep 1
  rm -rf ovl
  echo "Unmounted overlay image file."

  losetup -d $LOOP_DEVICE_OVL
  sleep 1
  echo "Overlay image file has been detached from loop device."

  sync
  umount sparse
  sync
  sleep 1
  rm -rf sparse
  echo "Unmounted hard disk image file."

  losetup -d $LOOP_DEVICE_HDD
  sleep 1
  echo "Hard disk image file has been detached from loop device."
  # Find the original user. Note that this may not always be correct.
  ORIG_USER=`who | awk '{print \$1}'`

  chown $ORIG_USER hdd.img

  echo "Applied original ownership to hard disk image file."
elif [ "$1" = "-h" -o "$1" = "--help" ] ; then
  cat << CEOF
  Usage: $0 [OPTION]
  This utility generates 20MB sparse file 'hdd.img' which can be used as QEMU
  disk image where all filesystem changes from the live session are persisted.

  -e, --empty     Create empty sparse image file which is not formatted.
  -f, --folder    Create sparse image file formatted with Ext2 filesystem which
                  contains compatible overlay folder structure.
  -h, --help      Prints this help information.
  -s, --sparse    Create sparse image file formatted with FAT filesystem which
                  contains sparse image file 'minimal.img' (3MB) formatted with
                  Ext2 filesystem which contains the actual overlay structure.
CEOF

elif [ "$1" = "" ] ; then
  echo "No option specified. Use '-h' or '--help' for more info."
else
  echo "Option '$1' is not recognized. Use '-h' or '--help' for more info."
fi

