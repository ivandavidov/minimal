#!/bin/bash

SRC_DIR=$(pwd)

. ../../common.sh

cd $WORK_DIR/overlay/util_linux

DESTDIR="$PWD/util_linux_installed"

# Change to the util-linux source directory which ls finds, e.g. 'util-linux-2.31'.
cd $(ls -d util-linux-*)

echo "Preparing util-linux work area. This may take a while..."
make -j $NUM_JOBS clean

rm -rf $DESTDIR

echo "Configuring util-linux..."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr \
  --disable-graphics \
  --disable-utf8 \
  --without-ipv6 \
  --without-ssl \
  --without-zlib \
  --without-x

echo "Building util-linux..."
make -j $NUM_JOBS

echo "Installing util-linux..."
make -j $NUM_JOBS install DESTDIR=$DESTDIR

echo "Reducing util-linux size..."
strip -g $DESTDIR/usr/bin/*

ROOTFS="$WORK_DIR/src/minimal_overlay/rootfs"

mkdir -p "$ROOTFS/usr/bin"
cp -r $DESTDIR/usr/bin/* $ROOTFS/usr/bin/

echo "util-linux has been installed."

cd $SRC_DIR

