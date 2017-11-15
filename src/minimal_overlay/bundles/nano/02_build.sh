#!/bin/bash

SRC_DIR=$(pwd)

. ../../common.sh

cd $WORK_DIR/overlay/nano

DESTDIR="$PWD/nano_installed"

# Change to the nano source directory which ls finds, e.g. 'nano-2.8.7'.
cd $(ls -d nano-*)

echo "Preparing nano work area. This may take a while..."
make -j $NUM_JOBS clean

rm -rf $DESTDIR

echo "Configuring nano..."
CFLAGS="$CFLAGS" ./configure \
    --prefix=/usr \
    LDFLAGS=-L$WORK_DIR/overlay/ncurses/ncurses_installed/usr/include

echo "Building nano..."
make -j $NUM_JOBS

echo "Installing nano..."
make -j $NUM_JOBS install DESTDIR=$DESTDIR

echo "Reducing nano size..."
strip -g $DESTDIR/usr/bin/*

ROOTFS="$WORK_DIR/src/minimal_overlay/rootfs"

cp -r $DESTDIR/* $ROOTFS

echo "nano has been installed."

cd $SRC_DIR
