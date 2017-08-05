#!/bin/sh

SRC_DIR=$(pwd)

. ../../common.sh

cd $WORK_DIR/overlay/links

DESTDIR="$PWD/links_installed"

# Change to the Links source directory which ls finds, e.g. 'links-2.12'.
cd $(ls -d links-*)

echo "Preparing Links work area. This may take a while..."
make -j $NUM_JOBS clean

rm -rf $DESTDIR

echo "Configuring Links..."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr \
  --disable-graphics \
  --disable-utf8 \
  --without-ipv6 \
  --without-ssl \
  --without-zlib \
  --without-x

echo "Building Links..."
make -j $NUM_JOBS

echo "Installing Links..."
make -j $NUM_JOBS install DESTDIR=$DESTDIR

echo "Reducing Links size..."
strip -g $DESTDIR/usr/bin/*

ROOTFS="$WORK_DIR/src/minimal_overlay/rootfs"

mkdir -p "$ROOTFS/usr/bin"
cp -r $DESTDIR/usr/bin/* $ROOTFS/usr/bin/

echo "Links has been installed."

cd $SRC_DIR

