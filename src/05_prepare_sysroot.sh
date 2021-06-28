#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** PREPARE SYSROOT BEGIN ***"

echo "Cleaning existing sysroot. This may take a while."
rm -rf $SYSROOT
mkdir -p $SYSROOT

echo "Preparing glibc. This may take a while."

# 1) Copy everything from glibc to the new sysroot area.
cp -r $GLIBC_INSTALLED/* $SYSROOT

# 2) Copy all kernel headers to the sysroot folder.
cp -r $KERNEL_INSTALLED/include $SYSROOT

# 3) Hack for the missing '/work/sysroot/usr' folder. We link
#    the existing libraries and the kernel headers. Without
#    this hack the Busybox compilation process fails. The proper
#    way to handle this is to use '--prefix=/usr' in the glibc
#    build process but then we have to deal with other issues.
#    For now this hack is the easiest and the simplest solution.
mkdir -p $SYSROOT/usr
ln -s ../include $SYSROOT/usr/include
ln -s ../lib $SYSROOT/usr/lib

cd $SRC_DIR

echo "*** PREPARE SYSROOT END ***"
