#!/bin/sh

set -e

. ../../common.sh

if [ ! -d "$WORK_DIR/overlay/$BUNDLE_NAME" ] ; then
  echo "The directory $WORK_DIR/overlay/$BUNDLE_NAME does not exist. Cannot continue."
  exit 1
fi

cd $WORK_DIR/overlay/$BUNDLE_NAME

# 'mll-install' BEGIN

# This script installs Minimal Linux Live on Ext2 partition.
cat << CEOF > sbin/mll-install
#!/bin/sh

CURRENT_DIR=\$(pwd)
PRINT_HELP=false

if [ "\$1" = "" -o "\$1" = "-h" -o "\$1" = "--help" ] ; then
  PRINT_HELP=true
fi

# Put more business logic here (if needed).

if [ "\$PRINT_HELP" = "true" ] ; then
  cat << DEOF

  This is the Minimal Linux Live installer. Requires root permissions.

  Usage: mll-install DEVICE

  DEVICE    The device where Minimal Linux Live will be installed. Specify only
            the name, e.g. 'sda'. The installer will automatically convert this
            to '/dev/sda' and will exit with warning message if the device does
            not exist.

  mll-install sdb

  The above example installs Minimal Linux Live  on '/dev/sdb'.

DEOF

  exit 0
fi

if [ ! "\$(id -u)" = "0" ] ; then
  echo "You need root permissions. Use '-h' or '--help' for more information."
  exit 1
fi

if [ ! -e /dev/\$1 ] ; then
  echo "Device '/dev/\$1' does not exist. Use '-h' or '--help' for more information."
  exit 1
fi

cat << DEOF

  Minimal Linux Live will be installed on device '/dev/\$1'. The device will be
  formatted with Ext2 and all previous data will be lost. Press 'Ctrl + C' to
  exit or any other key to continue.

DEOF

read -n1 -s

umount /dev/\$1 2>/dev/null
sleep 1
mkfs.ext2 /dev/\$1
mkdir /tmp/mnt/inst
mount /dev/\$1 /tmp/mnt/inst
sleep 1
cd /tmp/mnt/device
cp -r kernel.xz rootfs.xz syslinux.cfg src minimal /tmp/mnt/inst 2>/dev/null
cat /opt/syslinux/mbr.bin > /dev/\$1
cd /tmp/mnt/inst
/sbin/extlinux --install .
cd ..
umount /dev/\$1
sleep 1
rmdir /tmp/mnt/inst

cat << DEOF

  Installation is now complete. Device '/dev/\$1' should be bootable now. Check
  the above output for any errors. You need to remove the ISO image and restart
  the system. Let us hope the installation process worked!!! :)

DEOF

cd \$CURRENT_DIR

CEOF

chmod +rx sbin/mll-install

# 'mll-install' END

if [ ! -d "$WORK_DIR/syslinux" ] ; then
echo "The installer depends on Syslinux which is missing. Cannot continue."
  exit 1
fi;

cd $WORK_DIR/syslinux
cd $(ls -d syslinux-*)

cp bios/extlinux/extlinux \
  $WORK_DIR/overlay/$BUNDLE_NAME/sbin
mkdir -p $WORK_DIR/overlay/$BUNDLE_NAME/opt/syslinux
cp bios/mbr/mbr.bin \
  $WORK_DIR/overlay/$BUNDLE_NAME/opt/syslinux

# Big mama hack - need to find proper workaround!!!
# Both syslinux and extlinux are 32-bit executables which require 32-bit libs.
# Possible solution 1 - build 32-bit GLIBC on demand.
# Possible solution 2 - drop 32-bit MLL and provide 64-bit with multi-arch.
mkdir -p $WORK_DIR/overlay/$BUNDLE_NAME/lib
mkdir -p $WORK_DIR/overlay/$BUNDLE_NAME/usr/lib
cp /lib/ld-linux.so.2 \
  $WORK_DIR/overlay/$BUNDLE_NAME/lib
cp /lib/i386-linux-gnu/libc.so.6 \
  $WORK_DIR/overlay/$BUNDLE_NAME/usr/lib
# Big mama hack - end.

echo "Minimal Linux Live installer has been generated."

cd $SRC_DIR
