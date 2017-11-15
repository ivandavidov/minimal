#!/bin/bash

SRC_DIR=$(pwd)

. ../../common.sh

cd $WORK_DIR/overlay/fio

DESTDIR="$PWD/fio_installed"

# Change to the fio source directory which ls finds, e.g. 'fio-3.2'.
cd $(ls -d fio-*)

echo "Preparing fio work area. This may take a while..."
make -j $NUM_JOBS clean

rm -rf $DESTDIR

echo "Configuring fio..."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr

echo "Building fio..."
make -j $NUM_JOBS

echo "Installing fio..."
make -j $NUM_JOBS install DESTDIR=$DESTDIR

echo "Reducing fio size..."
strip -g $DESTDIR/usr/bin/*

ROOTFS="$WORK_DIR/src/minimal_overlay/rootfs"

cp -r $DESTDIR/* $ROOTFS

echo "fio has been installed."

cd $SRC_DIR
