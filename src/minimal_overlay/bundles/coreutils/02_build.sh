#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the coreutils source directory which ls finds, e.g. 'coreutils-8.28'.
cd $(ls -d coreutils-*)

echo "Preparing coreutils work area. This may take a while..."
make -j $NUM_JOBS clean

rm -rf $DEST_DIR

echo "Configuring coreutils..."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr

echo "Building coreutils..."
make -j $NUM_JOBS

echo "Installing coreutils..."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

echo "Reducing coreutils size..."
strip -g $DEST_DIR/usr/bin/*

cp -r $DEST_DIR/* $OVERLAY_ROOTFS

echo "coreutils has been installed."

cd $SRC_DIR
