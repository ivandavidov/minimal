#!/bin/sh

SRC_DIR=$(pwd)

. ../../common.sh

cd $WORK_DIR/overlay/zlib

DESTDIR="$WORK_DIR/overlay/zlib/zlib_installed"

# Change to the Links source directory which ls finds, e.g. 'zlib-1.2.11'.
cd $(ls -d zlib-*)

echo "Preparing ZLIB work area. This may take a while..."
make -j $NUM_JOBS clean

rm -rf $DESTDIR

echo "Configuring ZLIB..."
CFLAGS="$CFLAGS" ./configure \
  --prefix=$DESTDIR

echo "Building ZLIB..."
make -j $NUM_JOBS

echo "Installing ZLIB..."
make -j $NUM_JOBS install

echo "Reducing ZLIB size..."
strip -g $DESTDIR/lib/*

ROOTFS="$WORK_DIR/src/minimal_overlay/rootfs"

mkdir -p "$ROOTFS/lib"
cp -r $DESTDIR/lib/libz.so.1.* $ROOTFS/lib/libz.so.1

echo "ZLIB has been installed."

cd $SRC_DIR

