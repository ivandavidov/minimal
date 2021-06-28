#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** BUILD GLIBC BEGIN ***"

# Prepare the work area, e.g. 'work/glibc/glibc_objects'.
echo "Preparing glibc object area. This may take a while."
rm -rf $GLIBC_OBJECTS
mkdir $GLIBC_OBJECTS

# Prepare the install area, e.g. 'work/glibc/glibc_installed'.
echo "Preparing glibc install area. This may take a while."
rm -rf $GLIBC_INSTALLED
mkdir $GLIBC_INSTALLED

# Find the glibc source directory, e.g. 'glibc-2.23' and remember it.
GLIBC_SRC=`ls -d $WORK_DIR/glibc/glibc-*`

# All glibc work is done from the working area.
cd $GLIBC_OBJECTS

# 'glibc' is configured to use the root folder (--prefix=) and as result all
# libraries will be installed in '/lib'. Note that on 64-bit machines Busybox
# will be linked with the libraries in '/lib' while the Linux loader is expected
# to be in '/lib64'. Kernel headers are taken from our already prepared kernel
# header area (see xx_build_kernel.sh). Packages 'gd' and 'selinux' are disabled
# for better build compatibility with the host system.
echo "Configuring glibc."
$GLIBC_SRC/configure \
  --prefix= \
  --with-headers=$KERNEL_INSTALLED/include \
  --without-gd \
  --without-selinux \
  --disable-werror \
  CFLAGS="$CFLAGS"

# Compile glibc with optimization for "parallel jobs" = "number of processors".
echo "Building glibc."
make -j $NUM_JOBS

# Install glibc in the installation area, e.g. 'work/glibc/glibc_installed'.
echo "Installing glibc."
make install \
  DESTDIR=$GLIBC_INSTALLED \
  -j $NUM_JOBS

cd $SRC_DIR

echo "*** BUILD GLIBC END ***"
