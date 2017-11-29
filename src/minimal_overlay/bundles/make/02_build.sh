#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the make source directory which ls finds, e.g. 'make-8.28'.
cd $(ls -d make-*)

echo "Preparing make work area. This may take a while."
make -j $NUM_JOBS clean

rm -rf $DEST_DIR

echo "Configuring make."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr

echo "Building make."
make -j $NUM_JOBS

echo "Installing make."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

mkdir -p $DEST_DIR/lib
cp $SYSROOT/lib/libdl.so.2 $DEST_DIR/lib/

echo "Reducing make size."
strip -g $DEST_DIR/usr/bin/*

cp -r $DEST_DIR/* $OVERLAY_ROOTFS

echo "make has been installed."

cd $SRC_DIR
