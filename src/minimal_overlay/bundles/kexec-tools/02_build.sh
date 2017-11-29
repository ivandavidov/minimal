#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the kexec-tools source directory which ls finds, e.g. 'kexec-tools-2.0.15'.
cd $(ls -d kexec-tools-*)

echo "Preparing kexec-tools work area. This may take a while..."
make -j $NUM_JOBS clean
rm -rf $DEST_DIR

echo "Building kexec-tools..."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr \
  --without-lzama

make -j $NUM_JOBS

make -j $NUM_JOBS install DESTDIR="$DEST_DIR"

echo "Reducing kexec-tools size..."
strip -g $DEST_DIR/usr/bin/* \
  $DEST_DIR/usr/lib/* 2>/dev/null

mkdir -p $OVERLAY_ROOTFS/usr/
cp -r $DEST_DIR/usr/* $OVERLAY_ROOTFS/usr/

echo "kexec-tools has been installed."

cd $SRC_DIR
