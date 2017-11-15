#!/bin/sh

SRC_DIR=$(pwd)

. ../../common.sh

cd $WORK_DIR/overlay/kbd

DESTDIR="$PWD/kbd_installed"

# Change to the kbd source directory which ls finds, e.g. 'kbd-2.04'.
cd $(ls -d kbd-*)

echo "Preparing kbd work area. This may take a while..."
make -j $NUM_JOBS clean
rm -rf $DESTDIR

echo "Configuring kbd..."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr

echo "Building kbd..."
make -j $NUM_JOBS

echo "Installing kbd..."
make -j $NUM_JOBS install DESTDIR="$DESTDIR"

echo "Reducing kbd size..."
strip -g \
  $DESTDIR/usr/bin/* \
  $DESTDIR/usr/sbin/* \
  $DESTDIR/lib/*

ROOTFS=$WORK_DIR/src/minimal_overlay/rootfs

mkdir -p $ROOTFS/usr
cp -r "$DESTDIR/usr/bin" \
  "$DESTDIR/usr/share" \
  "$ROOTFS/usr/"

echo "kbd has been installed."

cd $SRC_DIR

