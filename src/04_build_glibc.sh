#!/bin/sh

# Find the kernel build directory.
cd work/kernel
cd $(ls -d *)
WORK_KERNEL_DIR=$(pwd)
cd ../../..

cd work/glibc

# Change to the first directory ls finds, e.g. 'glibc-2.23'.
cd $(ls -d *)

# Prepare working area, e.g. 'work/glibc/glibc-2.23/glibc_objects'.
echo "Preparing glibc object area. This may take a while..."
rm -rf ./glibc_objects
mkdir glibc_objects

# Prepare install area, e.g. 'work/glibc/glibc-2.23/glibc_installed'.
rm -rf ./glibc_installed
mkdir glibc_installed
cd glibc_installed
GLIBC_INSTALLED=$(pwd)
echo "Prepared glibc install area."

# All glibc work is done from the working area.
cd ../glibc_objects

# glibc is configured to use the root folder (--prefix=) and as result all libraries
# will be installed in '/lib'. Kernel headers are taken from our already prepared
# kernel header area (see 02_build_kernel.sh). Packages 'gd' and 'selinux' are disabled.
echo "Configuring glibc..."
../configure \
  --prefix= \
  --with-headers=$WORK_KERNEL_DIR/usr/include \
  --without-gd \
  --without-selinux \
  --disable-werror \
  CFLAGS="-Os -fno-stack-protector -U_FORTIFY_SOURCE"

# Compile glibc with optimization for "parallel jobs" = "number of processors".
echo "Building glibc..."
make -j $(grep ^processor /proc/cpuinfo | wc -l)

# Install glibc in the installation area, e.g. 'work/glibc/glibc-2.23/glibc_installed'.
echo "Installing glibc..."
make install DESTDIR=$GLIBC_INSTALLED -j $(grep ^processor /proc/cpuinfo | wc -l)

cd ../../..

