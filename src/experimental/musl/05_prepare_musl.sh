#!/bin/sh

cd work/kernel
cd $(ls -d *)
WORK_KERNEL_DIR=$(pwd)
cd ../../..

cd work/musl

# Change to the first directory ls finds, e.g. 'musl-1.1.11'
cd $(ls -d *)

cd musl-installed/bin

unlink musl-ar
ln -s `which ar` musl-ar

unlink musl-strip
ln -s `which strip` musl-strip

cd ../include

#
# Should work with headers from the newly downloaded kernel
# but it diesn't work. Damn!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
#unlink linux
#ln -s $WORK_KERNEL_DIR/include/linux linux
#
#unlink mtd
#ln -s $WORK_KERNEL_DIR/include/linux/mtd mtd
#
#unlink asm
#ln -s $WORK_KERNEL_DIR/include/uapi/asm-generic asm
#
#unlink asm-generic
#ln -s $WORK_KERNEL_DIR/include/uapi/asm-generic asm-generic
#
#unlink uapi
#ln -s $WORK_KERNEL_DIR/include/uapi uapi
#
#unlink uapi
#ln -s $WORK_KERNEL_DIR/include/uapi uapi

unlink linux
ln -s /usr/include/linux linux

unlink mtd
ln -s /usr/include/mtd mtd

if [ -d /usr/include/asm ]
then
  unlink asm
  ln -s /usr/include/asm asm
else
  unlink asm
  ln -s /usr/include/asm-generic asm
fi

unlink asm-generic
ln -s /usr/include/asm-generic asm-generic

