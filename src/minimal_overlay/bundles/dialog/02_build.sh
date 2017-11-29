#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the dialog source directory which ls finds, e.g. 'dialog-1.3-20170509'.
cd $(ls -d dialog-*)

echo "Preparing dialog work area. This may take a while."
make -j $NUM_JOBS clean

rm -rf $DEST_DIR

# Configure dialog
echo "Configuring dialog."
CFLAGS="$CFLAGS" ./configure \
    --prefix=/usr

echo "Building dialog."
make -j $NUM_JOBS

echo "Installing dialog."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

echo "Reducing dialog size."
strip -g $DEST_DIR/usr/bin/*

cp -r $DEST_DIR/usr/* $OVERLAY_ROOTFS

echo "Bundle 'dialog' has been installed."

cd $SRC_DIR
