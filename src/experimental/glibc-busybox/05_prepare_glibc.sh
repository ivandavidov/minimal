#!/bin/sh

# Find the kernel build directory.
cd work/kernel
cd $(ls -d *)
WORK_KERNEL_DIR=$(pwd)
cd ../../..

cd work/glibc

# Change to the first directory ls finds, e.g. 'glibc-2.22'
cd $(ls -d *)

cd glibc_installed

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
# |  +--asm-generic (kernel)
# |  |
# |  +--linux (kernel)
# |  |
# |  +--mtd (kernel)
# |
# +--lib (glibc)

mkdir -p usr
cd usr

unlink include 2>/dev/null
ln -s ../include include

unlink lib 2>/dev/null
ln -s ../lib lib

cd ../include

unlink linux 2>/dev/null
ln -s $WORK_KERNEL_DIR/usr/include/linux linux

unlink asm 2>/dev/null
ln -s $WORK_KERNEL_DIR/usr/include/asm asm

unlink asm-generic 2>/dev/null
ln -s $WORK_KERNEL_DIR/usr/include/asm-generic asm-generic

unlink mtd 2>/dev/null
ln -s $WORK_KERNEL_DIR/usr/include/mtd mtd

cd ../../../..

