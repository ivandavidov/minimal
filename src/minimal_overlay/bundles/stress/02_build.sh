#!/bin/bash

SRC_DIR=$(pwd)

. ../../common.sh

cd $WORK_DIR/overlay/stress

DESTDIR="$PWD/stress_installed"

# Change to the stress source directory which ls finds, e.g. 'stress-1.0.4'.
cd $(ls -d stress-*)

echo "Preparing stress work area. This may take a while..."
make -j $NUM_JOBS clean

rm -rf $DESTDIR

echo "Configuring stress..."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr

echo "Building stress..."
make -j $NUM_JOBS

echo "Installing stress..."
make -j $NUM_JOBS install DESTDIR=$DESTDIR

echo "Reducing stress size..."
strip -g $DESTDIR/usr/bin/*

ROOTFS="$WORK_DIR/src/minimal_overlay/rootfs"

cp -r $DESTDIR/* $ROOTFS

echo "stress has been installed."

cd $SRC_DIR
