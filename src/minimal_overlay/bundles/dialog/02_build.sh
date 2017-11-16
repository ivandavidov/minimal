#!/bin/bash

SRC_DIR=$(pwd)

. ../../common.sh

cd $WORK_DIR/overlay/dialog

DESTDIR="$PWD/dialog_installed"

# Change to the dialog source directory which ls finds, e.g. 'dialog-1.3-20170509'.
cd $(ls -d dialog-*)

echo "Preparing dialog work area. This may take a while..."
make -j $NUM_JOBS clean

rm -rf $DESTDIR

# Configure dialog
echo "Configuring dialog..."
CFLAGS="$CFLAGS" ./configure \
    --prefix=/usr

echo "Building dialog..."
make -j $NUM_JOBS

echo "Installing dialog..."
make -j $NUM_JOBS install DESTDIR=$DESTDIR

echo "Reducing dialog size..."
strip -g $DESTDIR/usr/bin/*

ROOTFS="$WORK_DIR/src/minimal_overlay/rootfs"

cp -r $DESTDIR/usr/* $ROOTFS

echo "dialog has been installed."

cd $SRC_DIR

