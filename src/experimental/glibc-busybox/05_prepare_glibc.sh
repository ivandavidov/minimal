#!/bin/sh

cd work/kernel
cd $(ls -d *)
WORK_KERNEL_DIR=$(pwd)
cd ../../..

cd work/glibc

# Change to the first directory ls finds, e.g. 'glibc-2.22'
cd $(ls -d *)

cd glibc_installed

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

exit 0

unlink musl-ar 2>/dev/null
ln -s `which ar` musl-ar

unlink musl-strip 2>/dev/null
ln -s `which strip` musl-strip

unlink linux 2>/dev/null
ln -s /usr/include/linux linux

unlink mtd 2>/dev/null
ln -s /usr/include/mtd mtd

if [ -d /usr/include/asm ]
then
  unlink asm 2>/dev/null
  ln -s /usr/include/asm asm
else
  unlink asm 2>/dev/null
  ln -s /usr/include/asm-generic asm
fi

unlink asm-generic 2>/dev/null
ln -s /usr/include/asm-generic asm-generic
