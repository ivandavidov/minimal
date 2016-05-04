#!/bin/sh

SRC_DIR=$(pwd)

# Find the kernel build directory.
cd work/kernel
cd $(ls -d *)
WORK_KERNEL_DIR=$(pwd)
cd $SRC_DIR

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

ln -s $WORK_KERNEL_DIR/usr/include/linux linux
ln -s $WORK_KERNEL_DIR/usr/include/asm asm
ln -s $WORK_KERNEL_DIR/usr/include/asm-generic asm-generic
ln -s $WORK_KERNEL_DIR/usr/include/mtd mtd

cd $SRC_DIR

