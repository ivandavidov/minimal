#!/bin/sh

echo "*** PREPARE SYSROOT BEGIN ***"

SRC_DIR=$(pwd)

cd work

echo "Cleaning existing sysroot. This may take a while..."
rm -rf sysroot
rm -rf sysroot.specs

echo "Preparing glibc. This may take a while..."
cp -r glibc/glibc_installed sysroot
cd sysroot

# Create custom 'usr' area and link it with some of the kernel header directories.
# BusyBox compilation process uses these linked directories. The following
# directories are affected:
#
# usr (glibc)
# |
# +--include (glibc)
# |  |
# |  +--asm (kernel)
# |  |
# |  +--asm-generic (kernel)
# |  |
# |  +--linux (kernel)
# |  |
# |  +--mtd (kernel)
# |
# +--lib (glibc)

mkdir -p usr

ln -s ../include usr/include
ln -s ../lib usr/lib

ln -s ../../kernel/kernel_installed/include/linux include/linux
ln -s ../../kernel/kernel_installed/include/asm include/asm
ln -s ../../kernel/kernel_installed/include/asm-generic include/asm-generic
ln -s ../../kernel/kernel_installed/include/mtd include/mtd

cd ..

echo "generating sysroot.specs"
SYSROOT="$PWD/sysroot"

# gcc has a "internal" path that needs to be added to find the static versions of libgcc_*
GCC_INTERNAL_PATH=$(dirname $(gcc -print-libgcc-file-name))

cat << CEOF > sysroot.specs
*link_libgcc:
-L$SYSROOT/lib -L$SYSROOT/lib64 -L$SYSROOT/usr/lib -L$SYSROOT/usr/lib64 -L$SYSROOT/usr/local/lib -L$SYSROOT/usr/local/lib64 -L$GCC_INTERNAL_PATH
CEOF

cd $SRC_DIR

echo "*** PREPARE SYSROOT END ***"

