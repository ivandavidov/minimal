#!/bin/sh

set -e

echo "*** BUILD GLIBC BEGIN ***"

SRC_DIR=$(pwd)

# Read the 'JOB_FACTOR' property from '.config'
JOB_FACTOR="$(grep -i ^JOB_FACTOR .config | cut -f2 -d'=')"

# Read the 'CFLAGS' property from '.config'
CFLAGS="$(grep -i ^CFLAGS .config | cut -f2 -d'=')"

# Find the number of available CPU cores.
NUM_CORES=$(grep ^processor /proc/cpuinfo | wc -l)

# Calculate the number of 'make' jobs to be used later.
NUM_JOBS=$((NUM_CORES * JOB_FACTOR))

# Save the kernel installation directory.
KERNEL_INSTALLED=$SRC_DIR/work/kernel/kernel_installed

cd work/glibc

# Find the glibc source directory, e.g. 'glibc-2.23' and remember it.
cd $(ls -d glibc-*)
GLIBC_SRC=$(pwd)
cd ..

# Prepare the work area, e.g. 'work/glibc/glibc_objects'.
echo "Preparing GNU C library object area. This may take a while."
rm -rf glibc_objects
mkdir glibc_objects

# Prepare the install area, e.g. 'work/glibc/glibc_installed'.
echo "Preparing GNU C library install area. This may take a while."
rm -rf glibc_installed
mkdir glibc_installed
GLIBC_INSTALLED=$(pwd)/glibc_installed

# All glibc work is done from the working area.
cd glibc_objects

# glibc is configured to use the root folder (--prefix=) and as result all
# libraries will be installed in '/lib'. Note that on 64-bit machines BusyBox
# will be linked with the libraries in '/lib' while the Linux loader is expected
# to be in '/lib64'. Kernel headers are taken from our already prepared kernel
# header area (see xx_build_kernel.sh). Packages 'gd' and 'selinux' are disabled
# for better build compatibility with the host system.

# Read the 'FORCE_32_BIT_BINARIES' property from '.config'
FORCE_32_BIT_BINARIES="$(grep -i ^FORCE_32_BIT_BINARIES $SRC_DIR/.config | cut -f2 -d'=')"

if [ "$FORCE_32_BIT_BINARIES" = "true" ] ; then
  # Create 32-bit configuration file for the GNU C library.
  # On Ubuntu host machine this requires 'gcc-multilib'.
  echo "Configuring 32-bit GNU C library."
  $GLIBC_SRC/configure \
    --build=i686-linux \
    --host=i686-linux \
    --prefix= \
    --with-headers=$KERNEL_INSTALLED/include \
    --without-gd \
    --without-selinux \
    --disable-werror \
    CC="gcc -m32" \
    CXX="g++ -m32" \
    CFLAGS="$CFLAGS -march=i686" \ 
    CXXFLAGS="$CFLAGS -march=i686"
else
  echo "Configuring GNU C library."
  $GLIBC_SRC/configure \
    --prefix= \
    --with-headers=$KERNEL_INSTALLED/include \
    --without-gd \
    --without-selinux \
    --disable-werror \
    CFLAGS="$CFLAGS" \
    CXXFLAGS="$CFLAGS"
fi

# Compile glibc with optimization for "parallel jobs" = "number of processors".
echo "Building GNU C library."
make -j $NUM_JOBS

# Install glibc in the installation area, e.g. 'work/glibc/glibc_installed'.
echo "Installing GNU C library."
make install \
  DESTDIR=$GLIBC_INSTALLED \
  -j $NUM_JOBS

cd $SRC_DIR

echo "*** BUILD GLIBC END ***"

