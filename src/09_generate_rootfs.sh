#!/bin/sh

set -e

echo "*** GENERATE ROOTFS BEGIN ***"

SRC_DIR=$(pwd)

# Remember the sysroot
SYSROOT=$(pwd)/work/sysroot

# Remember the BysyBox install folder.
BUSYBOX_INSTALLED=$(pwd)/work/busybox/busybox_installed

cd work

echo "Preparing rootfsfs work area."
rm -rf rootfs

# Copy all BusyBox generated stuff to the location of our 'rootfs' folder.
cp -r $BUSYBOX_INSTALLED rootfs

# Copy all rootfs resources to the location of our 'rootfs' folder.
cp -r ../minimal_rootfs/* rootfs

cd rootfs

# Delete the '.keep' files which we use in order to keep track of otherwise
# empty folders.
find * -type f -name '.keep' -exec rm {} +

# Remove 'linuxrc' which is used when we boot in 'RAM disk' mode.
rm -f linuxrc

# This is for the dynamic loader. Note that the name and the location are both
# specific for 32-bit and 64-bit machines. First we check the BusyBox executable
# and then we copy the dynamic loader to its appropriate location.
BUSYBOX_ARCH=$(file bin/busybox | cut -d' ' -f3)
if [ "$BUSYBOX_ARCH" = "64-bit" ] ; then
  mkdir lib64
  cp $SYSROOT/lib/ld-linux* lib64
  echo "Dynamic loader is accessed via '/lib64'."
else
  cp $SYSROOT/lib/ld-linux* lib
  echo "Dynamic loader is accessed via '/lib'."
fi

# Copy all necessary 'glibc' libraries to '/lib' BEGIN.

# BusyBox has direct dependencies on these libraries.
cp $SYSROOT/lib/libm.so.6 lib
cp $SYSROOT/lib/libc.so.6 lib

# Copy all necessary 'glibc' libraries to '/lib' END.

strip -g \
  $SRC_DIR/work/rootfs/bin/* \
  $SRC_DIR/work/rootfs/sbin/* \
  $SRC_DIR/work/rootfs/lib/* \
  2>/dev/null
echo "Reduced the size of libraries and executables."

# Read the 'OVERLAY_LOCATION' property from '.config'
OVERLAY_LOCATION="$(grep -i ^OVERLAY_LOCATION $SRC_DIR/.config | cut -f2 -d'=')"

if [ "$OVERLAY_LOCATION" = "rootfs" -a -d $SRC_DIR/work/overlay_rootfs ] ; then
  echo "Merging overlay software in rootfs."

  cp -r $SRC_DIR/work/overlay_rootfs/* .
  cp -r $SRC_DIR/minimal_overlay/rootfs/* .
fi

echo "The rootfs area has been generated."

cd $SRC_DIR

echo "*** GENERATE ROOTFS END ***"
