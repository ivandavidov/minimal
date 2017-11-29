#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the Links source directory which ls finds, e.g. 'zlib-1.2.11'.
cd $(ls -d zlib-*)

echo "Preparing ZLIB work area. This may take a while."
make -j $NUM_JOBS clean

rm -rf $DEST_DIR

echo "Configuring ZLIB."
CFLAGS="$CFLAGS" ./configure \
  --prefix=$DEST_DIR

echo "Building ZLIB."
make -j $NUM_JOBS

echo "Installing ZLIB."
make -j $NUM_JOBS install

echo "Reducing ZLIB size."
strip -g $DEST_DIR/lib/*

mkdir -p "$OVERLAY_ROOTFS/lib"
cp -r $DEST_DIR/lib/libz.so.1.* $OVERLAY_ROOTFS/lib/libz.so.1

echo "ZLIB has been installed."

cd $SRC_DIR
