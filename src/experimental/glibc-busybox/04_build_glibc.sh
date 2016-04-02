#!/bin/sh

cd work/kernel
cd $(ls -d *)
WORK_KERNEL_DIR=$(pwd)
cd ../../..

cd work/glibc

# Change to the first directory ls finds, e.g. 'glibc-2.22'
cd $(ls -d *)

rm -rf ./glibc_objects
mkdir glibc_objects

rm -rf ./glibc_installed
mkdir glibc_installed
cd glibc_installed
GLIBC_INSTALLED=$(pwd)

cd ../glibc_objects
../configure --prefix= --with-headers=$WORK_KERNEL_DIR/usr/include --disable-werror
#../configure --prefix=$GLIBC_INSTALLED --with-headers=$WORK_KERNEL_DIR/usr/include --enable-static-ns --disable-werror
#../configure --prefix=$GLIBC_INSTALLED --with-headers=$WORK_KERNEL_DIR/usr/include --disable-werror

make -j $(grep ^processor /proc/cpuinfo | wc -l)

#set DESTDIR=$GLIBC_INSTALLED
#export DESTDIR
make install DESTDIR=$GLIBC_INSTALLED -j $(grep ^processor /proc/cpuinfo | wc -l)

#unset DESTDIR

cd ../../..

