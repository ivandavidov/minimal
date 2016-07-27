#!/bin/sh

echo "*** PREPARE GLIBC BEGIN ***"

SRC_DIR=$(pwd)

# Save the kernel installation directory.
KERNEL_INSTALLED=$(pwd)/work/kernel/kernel_installed

cd work/glibc

echo "Preparing glibc. This may take a while..."

rm -rf glibc_prepared
cp -r glibc_installed glibc_prepared

cd glibc_prepared

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
cd usr

ln -s ../include include
ln -s ../lib lib

cd ../include

ln -s $KERNEL_INSTALLED/include/linux linux
ln -s $KERNEL_INSTALLED/include/asm asm
ln -s $KERNEL_INSTALLED/include/asm-generic asm-generic
ln -s $KERNEL_INSTALLED/include/mtd mtd

cd $SRC_DIR

echo "*** PREPARE GLIBC END ***"

