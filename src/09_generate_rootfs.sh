#!/bin/sh

# Remember the prepared glibc folder.
GLIBC_PREPARED=$(pwd)/work/glibc/glibc_prepared

cd work

echo "Preparing initramfs work area..."
rm -rf rootfs

# Copy all BusyBox generated stuff to the location of our 'initramfs' folder.
cp -r busybox/busybox_installed rootfs

# Copy all rootfs resources to the location of our 'initramfs' folder.
cp -r ../09_generate_rootfs/* rootfs

cd rootfs

# Remove 'linuxrc' which is used when we boot in 'RAM disk' mode. 
rm -f linuxrc

# Read the 'COPY_SOURCE_ROOTFS' property from '.config'
COPY_SOURCE_ROOTFS="$(grep -i COPY_SOURCE_ROOTFS ../../.config | cut -f2 -d'=')"

if [ "$COPY_SOURCE_ROOTFS" = "true" ] ; then
  # Copy all prepared source files and folders to '/src'. Note that the scripts
  # will not work there because you also need proper toolchain.
  cp -r ../src src
  echo "Original source files and folders have been copied."
else
  echo "Original source files and folders have been skipped."
fi

# Copy all necessary 'glibc' libraries to '/lib' BEGIN.

# This is the dynamic loader. Note that the file name is different for 32-bit
# and 64-bit machines.
cp $GLIBC_PREPARED/lib/ld-linux* ./lib

# BusyBox has direct dependencies on these libraries.
cp $GLIBC_PREPARED/lib/libm.so.6 ./lib
cp $GLIBC_PREPARED/lib/libc.so.6 ./lib

# These libraries are necessary for the DNS resolving.
cp $GLIBC_PREPARED/lib/libresolv.so.2 ./lib
cp $GLIBC_PREPARED/lib/libnss_dns.so.2 ./lib

# Make sure the Linux loader is visible on 64-bit machines. We can't rename the
# folder to '/lib64' because the glibc root location is set to '/lib' in the
# '05_build_glibc.sh' source script and therefore all 64-bit executables will
# be looking for shared libraries directly in '/lib'. 
BUSYBOX_ARCH=$(file busybox | cut -d\  -f3)
if [ "$BUSYBOX_ARCH" = "64-bit" ] ; then
  ln -s lib lib64
fi

# Copy all necessary 'glibc' libraries to '/lib' END.

echo "The initramfs area has been generated."

cd ../..

