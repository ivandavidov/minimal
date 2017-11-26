#!/bin/bash

SRC_DIR=$(pwd)

. ../../common.sh

cd $WORK_DIR/overlay/make

DESTDIR="$PWD/make_installed"

# Change to the make source directory which ls finds, e.g. 'make-8.28'.
cd $(ls -d make-*)

echo "Preparing make work area. This may take a while..."
make -j $NUM_JOBS clean

rm -rf $DESTDIR

echo "Configuring make..."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr

echo "Building make..."
make -j $NUM_JOBS

echo "Installing make..."
make -j $NUM_JOBS install DESTDIR=$DESTDIR

echo "Reducing make size..."
strip -g $DESTDIR/usr/bin/*

ROOTFS="$WORK_DIR/src/minimal_overlay/rootfs"

cp -r $DESTDIR/* $ROOTFS

echo "make has been installed."

cd $SRC_DIR
