#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the libevent source directory which ls finds, e.g. 'libevent-2.1.8-stable'.
cd $(ls -d libevent-*)

echo "Preparing libevent work area. This may take a while..."
make -j $NUM_JOBS clean

rm -rf $DEST_DIR

echo "Configuring libevent..."
CFLAGS="$CFLAGS" ./configure

echo "Building libevent..."
make -j $NUM_JOBS

echo "Installing libevent..."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

echo "Reducing libevent size..."
strip -g $DEST_DIR/usr/bin/*

cp -r $DEST_DIR/usr/local/* $OVERLAY_ROOTFS

echo "libevent has been installed."

cd $SRC_DIR
