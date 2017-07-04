#!/bin/sh

echo "*** PREPARE SYSROOT BEGIN ***"

SRC_DIR=$(pwd)

cd work

echo "Cleaning existing sysroot. This may take a while..."
rm -rf sysroot

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

cd $SRC_DIR

echo "*** PREPARE SYSROOT END ***"

