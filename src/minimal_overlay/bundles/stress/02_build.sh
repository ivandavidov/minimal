#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

DESTDIR="$PWD/stress_installed"

# Change to the stress source directory which ls finds, e.g. 'stress-1.0.4'.
cd $(ls -d stress-*)

echo "Preparing stress work area. This may take a while..."
make -j $NUM_JOBS clean

rm -rf $DEST_DIR

echo "Configuring stress..."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr

echo "Building stress..."
make -j $NUM_JOBS

echo "Installing stress..."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

echo "Reducing stress size..."
strip -g $DEST_DIR/usr/bin/*

cp -r $DEST_DIR/* $OVERLAY_ROOTFS

echo "stress has been installed."

cd $SRC_DIR
