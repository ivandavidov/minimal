#!/bin/bash

SRC_DIR=$(pwd)

. ../../common.sh

cd $WORK_DIR/overlay/libevent

DESTDIR="$PWD/libevent_installed"

# Change to the libevent source directory which ls finds, e.g. 'libevent-2.1.8-stable'.
cd $(ls -d libevent-*)

echo "Preparing libevent work area. This may take a while..."
make -j $NUM_JOBS clean

rm -rf $DESTDIR

echo "Configuring libevent..."
CFLAGS="$CFLAGS" ./configure

echo "Building libevent..."
make -j $NUM_JOBS

echo "Installing libevent..."
make -j $NUM_JOBS install DESTDIR=$DESTDIR

echo "Reducing libevent size..."
strip -g $DESTDIR/usr/bin/*

ROOTFS="$WORK_DIR/src/minimal_overlay/rootfs"

cp -r $DESTDIR/usr/local/* $ROOTFS

echo "libevent has been installed."

cd $SRC_DIR
