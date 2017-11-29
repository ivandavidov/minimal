#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the nano source directory which ls finds, e.g. 'nano-2.8.7'.
cd $(ls -d nano-*)

echo "Preparing nano work area. This may take a while..."
make -j $NUM_JOBS clean

rm -rf $DEST_DIR

echo "Configuring nano..."
CFLAGS="$CFLAGS" ./configure \
    --prefix=/usr \
    LDFLAGS=-L$DEST_DIR/usr/include

echo "Building nano..."
make -j $NUM_JOBS

echo "Installing nano..."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

echo "Reducing nano size..."
strip -g $DEST_DIR/usr/bin/*

cp -r $DEST_DIR/* $OVERLAY_ROOTFS

echo "nano has been installed."

cd $SRC_DIR
