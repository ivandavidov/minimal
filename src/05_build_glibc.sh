#!/bin/sh

# Find the kernel build directory.
cd work/kernel
cd $(ls -d linux-*)
WORK_KERNEL_DIR=$(pwd)
cd ../../..

cd work/glibc

# Find the glibc source directory, e.g. 'glibc-2.23' and remember it.
cd $(ls -d glibc-*)
GLIBC_SRC=$(pwd)
cd ..

# Prepare the work area, e.g. 'work/glibc/glibc_objects'.
echo "Preparing glibc object area. This may take a while..."
rm -rf glibc_objects
mkdir glibc_objects

# Prepare the install area, e.g. 'work/glibc/glibc_installed'.
echo "Preparing glibc install area. This may take a while..."
rm -rf glibc_installed
mkdir glibc_installed
GLIBC_INSTALLED=$(pwd)/glibc_installed

# All glibc work is done from the working area.
cd glibc_objects

# glibc is configured to use the root folder (--prefix=) and as result all
# libraries will be installed in '/lib'. Note that on 64-bit machines BusyBox
# will be linked with the libraries in '/lib' while the Linux loader is expected
# to be in '/lib64'. Kernel headers are taken from our already prepared kernel
# header area (see 03_build_kernel.sh). Packages 'gd' and 'selinux' are disabled
# for better build compatibility with the host system.
echo "Configuring glibc..."
$GLIBC_SRC/configure \
  --prefix= \
  --with-headers=$WORK_KERNEL_DIR/usr/include \
  --without-gd \
  --without-selinux \
  --disable-werror \
  CFLAGS="-Os -s -fno-stack-protector -U_FORTIFY_SOURCE"

# Compile glibc with optimization for "parallel jobs" = "number of processors".
echo "Building glibc..."
make -j $(grep ^processor /proc/cpuinfo | wc -l)

# Install glibc in the installation area, e.g. 'work/glibc/glibc_installed'.
echo "Installing glibc..."
make install \
  DESTDIR=$GLIBC_INSTALLED \
  -j $(grep ^processor /proc/cpuinfo | wc -l)

cd ../../..

