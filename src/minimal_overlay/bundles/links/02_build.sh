#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the Links source directory which ls finds, e.g. 'links-2.12'.
cd $(ls -d links-*)

echo "Preparing Links work area. This may take a while..."
make -j $NUM_JOBS clean

rm -rf $DEST_DIR

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
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

echo "Reducing Links size..."
strip -g $DEST_DIR/usr/bin/*

mkdir -p "$OVERLAY_ROOTFS/usr/bin"
cp -r $DEST_DIR/usr/bin/* $OVERLAY_ROOTFS/usr/bin/

echo "Links has been installed."

cd $SRC_DIR
