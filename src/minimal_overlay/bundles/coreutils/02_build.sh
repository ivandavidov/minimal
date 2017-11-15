#!/bin/bash

SRC_DIR=$(pwd)

. ../../common.sh

cd $WORK_DIR/overlay/coreutils

DESTDIR="$PWD/coreutils_installed"

# Change to the coreutils source directory which ls finds, e.g. 'coreutils-8.28'.
cd $(ls -d coreutils-*)

echo "Preparing coreutils work area. This may take a while..."
make -j $NUM_JOBS clean

rm -rf $DESTDIR

echo "Configuring coreutils..."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr

echo "Building coreutils..."
make -j $NUM_JOBS

echo "Installing coreutils..."
make -j $NUM_JOBS install DESTDIR=$DESTDIR

echo "Reducing coreutils size..."
strip -g $DESTDIR/usr/bin/*

ROOTFS="$WORK_DIR/src/minimal_overlay/rootfs"

cp -r $DESTDIR/* $ROOTFS

echo "coreutils has been installed."

cd $SRC_DIR
