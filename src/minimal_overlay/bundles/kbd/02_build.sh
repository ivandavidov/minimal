#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the kbd source directory which ls finds, e.g. 'kbd-2.04'.
cd $(ls -d kbd-*)

echo "Preparing kbd work area. This may take a while."
make -j $NUM_JOBS clean
rm -rf $DEST_DIR

echo "Configuring kbd."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr \
  --disable-vlock
# vlock requires PAM

echo "Building kbd."
make -j $NUM_JOBS

echo "Installing kbd."
make -j $NUM_JOBS install DESTDIR="$DEST_DIR"

echo "Reducing kbd size."
strip -g \
  $DEST_DIR/usr/bin/* \
  $DEST_DIR/usr/sbin/* \
  $DEST_DIR/lib/*

mkdir -p $OVERLAY_ROOTFS/usr
cp -r "$DEST_DIR/usr/bin" \
  "$DEST_DIR/usr/share" \
  "$OVERLAY_ROOTFS/usr/"

echo "Bundle 'kbd' has been installed."

cd $SRC_DIR
