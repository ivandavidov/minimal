#!/bin/sh

echo "*** GENERATE ROOTFS BEGIN ***"

SRC_ROOT=$(pwd)

# Remember the sysroot
SYSROOT=$(pwd)/work/sysroot

# Remember the BysyBox install folder.
BUSYBOX_INSTALLED=$(pwd)/work/busybox/busybox_installed

cd work

echo "Preparing initramfs work area..."
rm -rf rootfs

# Copy all BusyBox generated stuff to the location of our 'initramfs' folder.
cp -r $BUSYBOX_INSTALLED rootfs

# Copy all rootfs resources to the location of our 'initramfs' folder.
cp -r src/minimal_rootfs/* rootfs

cd rootfs

# Remove 'linuxrc' which is used when we boot in 'RAM disk' mode. 
rm -f linuxrc

# Read the 'COPY_SOURCE_ROOTFS' property from '.config'
COPY_SOURCE_ROOTFS="$(grep -i ^COPY_SOURCE_ROOTFS $SRC_ROOT/.config | cut -f2 -d'=')"

if [ "$COPY_SOURCE_ROOTFS" = "true" ] ; then
  # Copy all prepared source files and folders to '/src'. Note that the scripts
  # will not work there because you also need proper toolchain.
  cp -r ../src src
  echo "Source files and folders have been copied to '/src'."
else
  echo "Source files and folders have been skipped."
fi

# This is for the dynamic loader. Note that the name and the location are both
# specific for 32-bit and 64-bit machines. First we check the BusyBox executable
# and then we copy the dynamic loader to its appropriate location.
BUSYBOX_ARCH=$(file bin/busybox | cut -d' '  -f3)
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
  $SRC_ROOT/work/rootfs/bin/* \
  $SRC_ROOT/work/rootfs/sbin/* \
  $SRC_ROOT/work/rootfs/lib/* \
  2>/dev/null
echo "Reduced the size of libraries and executables."

echo "The initramfs area has been generated."

cd $SRC_ROOT

echo "*** GENERATE ROOTFS END ***"

