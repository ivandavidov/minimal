#!/bin/sh

# System initialization sequence:
#
# /init
#  |
#  +--(1) /etc/01_prepare.sh
#  |
#  +--(2) /etc/02_overlay.sh (this file)
#          |
#          +-- /etc/03_init.sh
#               |
#               +-- /sbin/init
#                    |
#                    +--(1) /etc/04_bootscript.sh
#                    |       |
#                    |       +-- /etc/autorun/* (all scripts)
#                    |
#                    +--(2) /bin/sh (Alt + F1, main console)
#                    |
#                    +--(2) /bin/sh (Alt + F2)
#                    |
#                    +--(2) /bin/sh (Alt + F3)
#                    |
#                    +--(2) /bin/sh (Alt + F4)

# Create the new mountpoint in RAM.
mount -t tmpfs none /mnt

# Create folders for all critical file systems.
mkdir /mnt/dev
mkdir /mnt/sys
mkdir /mnt/proc
mkdir /mnt/tmp
echo "Created folders for all critical file systems."

# Copy root folders in the new mountpoint.
echo -e "Copying the root file system to \\e[94m/mnt\\e[0m."
for dir in */ ; do
  case $dir in
    dev/)
      # skip
      ;;
    proc/)
      # skip
      ;;
    sys/)
      # skip
      ;;
    mnt/)
      # skip
      ;;
    tmp/)
      # skip
      ;;
    *)
      cp -a $dir /mnt
      ;;
  esac
done

DEFAULT_OVERLAY_DIR="/tmp/minimal/overlay"
DEFAULT_UPPER_DIR="/tmp/minimal/rootfs"
DEFAULT_WORK_DIR="/tmp/minimal/work"

echo "Searching available devices for overlay content."
for DEVICE in /dev/* ; do
  DEV=$(echo "${DEVICE##*/}")
  SYSDEV=$(echo "/sys/class/block/$DEV")

  case $DEV in
    *loop*) continue ;;
  esac

  if [ ! -d "$SYSDEV" ] ; then
    continue
  fi

  mkdir -p /tmp/mnt/device
  DEVICE_MNT=/tmp/mnt/device

  OVERLAY_DIR=""
  OVERLAY_MNT=""
  UPPER_DIR=""
  WORK_DIR=""

  mount $DEVICE $DEVICE_MNT 2>/dev/null
  if [ -d $DEVICE_MNT/minimal/rootfs -a -d $DEVICE_MNT/minimal/work ] ; then
    # folder
    echo -e "  Found \\e[94m/minimal\\e[0m folder on device \\e[31m$DEVICE\\e[0m."
    touch $DEVICE_MNT/minimal/rootfs/minimal.pid 2>/dev/null
    if [ -f $DEVICE_MNT/minimal/rootfs/minimal.pid ] ; then
      # read/write mode
      echo -e "  Device \\e[31m$DEVICE\\e[0m is mounted in read/write mode."

      rm -f $DEVICE_MNT/minimal/rootfs/minimal.pid

      OVERLAY_DIR=$DEFAULT_OVERLAY_DIR
      OVERLAY_MNT=$DEVICE_MNT
      UPPER_DIR=$DEVICE_MNT/minimal/rootfs
      WORK_DIR=$DEVICE_MNT/minimal/work
    else
      # read only mode
      echo -e "  Device \\e[31m$DEVICE\\e[0m is mounted in read only mode."

      OVERLAY_DIR=$DEVICE_MNT/minimal/rootfs
      OVERLAY_MNT=$DEVICE_MNT
      UPPER_DIR=$DEFAULT_UPPER_DIR
      WORK_DIR=$DEFAULT_WORK_DIR
    fi
  elif [ -f $DEVICE_MNT/minimal.img ] ; then
    #image
    echo -e "  Found \\e[94m/minimal.img\\e[0m image on device \\e[31m$DEVICE\\e[0m."

    mkdir -p /tmp/mnt/image
    IMAGE_MNT=/tmp/mnt/image

    LOOP_DEVICE=$(losetup -f)
    losetup $LOOP_DEVICE $DEVICE_MNT/minimal.img

    mount $LOOP_DEVICE $IMAGE_MNT
    if [ -d $IMAGE_MNT/rootfs -a -d $IMAGE_MNT/work ] ; then
      touch $IMAGE_MNT/rootfs/minimal.pid 2>/dev/null
      if [ -f $IMAGE_MNT/rootfs/minimal.pid ] ; then
        # read/write mode
        echo -e "  Image \\e[94m$DEVICE/minimal.img\\e[0m is mounted in read/write mode."

        rm -f $IMAGE_MNT/rootfs/minimal.pid

        OVERLAY_DIR=$DEFAULT_OVERLAY_DIR
        OVERLAY_MNT=$IMAGE_MNT
        UPPER_DIR=$IMAGE_MNT/rootfs
        WORK_DIR=$IMAGE_MNT/work
      else
        # read only mode
        echo -e "  Image \\e[94m$DEVICE/minimal.img\\e[0m is mounted in read only mode."

        OVERLAY_DIR=$IMAGE_MNT/rootfs
        OVERLAY_MNT=$IMAGE_MNT
        UPPER_DIR=$DEFAULT_UPPER_DIR
        WORK_DIR=$DEFAULT_WORK_DIR
      fi
    else
      umount $IMAGE_MNT
      rm -rf $IMAGE_MNT
    fi
  fi

  if [ "$OVERLAY_DIR" != "" -a "$UPPER_DIR" != "" -a "$WORK_DIR" != "" ] ; then
    mkdir -p $OVERLAY_DIR
    mkdir -p $UPPER_DIR
    mkdir -p $WORK_DIR

    mount -t overlay -o lowerdir=$OVERLAY_DIR:/mnt,upperdir=$UPPER_DIR,workdir=$WORK_DIR none /mnt 2>/dev/null

    OUT=$?
    if [ ! "$OUT" = "0" ] ; then
      echo -e "  \\e[31mMount failed (probably on vfat).\\e[0m"

      umount $OVERLAY_MNT 2>/dev/null
      rmdir $OVERLAY_MNT 2>/dev/null

      rmdir $DEFAULT_OVERLAY_DIR 2>/dev/null
      rmdir $DEFAULT_UPPER_DIR 2>/dev/null
      rmdir $DEFAULT_WORK_DIR 2>/dev/null
    else
      # All done, time to go.
      echo -e "  Overlay data from device \\e[31m$DEVICE\\e[0m has been merged."
      break
    fi
  else
    echo -e "  Device \\e[31m$DEVICE\\e[0m has no proper overlay structure."
  fi

  umount $DEVICE_MNT 2>/dev/null
  rm -rf $DEVICE_MNT 2>/dev/null
done

# Move critical file systems to the new mountpoint.
mount --move /dev /mnt/dev
mount --move /sys /mnt/sys
mount --move /proc /mnt/proc
mount --move /tmp /mnt/tmp
echo -e "Mount locations \\e[94m/dev\\e[0m, \\e[94m/sys\\e[0m, \\e[94m/tmp\\e[0m and \\e[94m/proc\\e[0m have been moved to \\e[94m/mnt\\e[0m."

# The new mountpoint becomes file system root. All original root folders are
# deleted automatically as part of the command execution. The '/sbin/init'
# process is invoked and it becomes the new PID 1 parent process.
echo "Switching from initramfs root area to overlayfs root area."
exec switch_root /mnt /etc/03_init.sh

echo "(/etc/02_overlay.sh) - there is a serious bug."

# Wait until any key has been pressed.
read -n1 -s
