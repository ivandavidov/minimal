#!/bin/bash

SRC_DIR=$(pwd)

. ../../common.sh

cd $WORK_DIR/overlay/util_linux

DESTDIR="$PWD/util_linux_installed"

# Change to the util-linux source directory which ls finds, e.g. 'util-linux-2.31'.
cd $(ls -d util-linux-*)

echo "Preparing util-linux work area. This may take a while..."
make -j $NUM_JOBS clean

rm -rf $DESTDIR

echo "Configuring util-linux..."
CFLAGS="$CFLAGS" ./configure \
  ADJTIME_PATH=/var/lib/hwclock/adjtime   \
  --docdir=/usr/share/doc/util-linux-2.31 \
  --disable-chfn-chsh  \
  --disable-login      \
  --disable-nologin    \
  --disable-su         \
  --disable-setpriv    \
  --disable-runuser    \
  --disable-pylibmount \
  --disable-static     \
  --without-python     \
  --without-systemd    \
  --without-systemdsystemunitdir

echo "Building util-linux..."
make -j $NUM_JOBS

echo "Installing util-linux..."
make -j $NUM_JOBS install DESTDIR=$DESTDIR

echo "Reducing util-linux size..."
strip -g $DESTDIR/usr/bin/*

ROOTFS="$WORK_DIR/src/minimal_overlay/rootfs"

cp -r $DESTDIR/* $ROOTFS

echo "util-linux has been installed."

cd $SRC_DIR
