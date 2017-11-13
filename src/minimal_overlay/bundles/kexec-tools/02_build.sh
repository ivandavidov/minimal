#!/bin/bash

SRC_DIR=$(pwd)

. ../../common.sh

cd $WORK_DIR/overlay/kexec-tools

DESTDIR="$PWD/kexec-tools_installed"

# Change to the kexec-tools source directory which ls finds, e.g. 'kexec-tools-2.0.15'.
cd $(ls -d kexec-tools-*)

echo "Preparing kexec-tools work area. This may take a while..."
make -j $NUM_JOBS clean
rm -rf $DESTDIR

echo "Building kexec-tools..."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr \
  --without-lzama

make -j $NUM_JOBS

make -j $NUM_JOBS install DESTDIR="$DESTDIR"

echo "Reducing kexec-tools size..."
strip -g $DESTDIR/usr/bin/* \
  $DESTDIR/usr/lib/* 2>/dev/null

ROOTFS="$WORK_DIR/src/minimal_overlay/rootfs"
mkdir -p $ROOTFS/usr/
cp -r $DESTDIR/usr/* $ROOTFS/usr/

echo "kexec-tools has been installed."

cd $SRC_DIR
