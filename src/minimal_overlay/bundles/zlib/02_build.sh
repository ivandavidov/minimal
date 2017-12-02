#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the Links source directory which ls finds, e.g. 'zlib-1.2.11'.
cd $(ls -d zlib-*)

echo "Preparing '$BUNDLE_NAME' work area. This may take a while."
make -j $NUM_JOBS distclean

rm -rf $DEST_DIR

echo "Configuring '$BUNDLE_NAME'."
CFLAGS="$CFLAGS" ./configure \
  --prefix=$DEST_DIR

echo "Building '$BUNDLE_NAME'."
make -j $NUM_JOBS

echo "Installing '$BUNDLE_NAME'."
make -j $NUM_JOBS install

echo "Reducing '$BUNDLE_NAME' size."
set +e
strip -g $DEST_DIR/lib/*
set -e

mkdir -p "$OVERLAY_ROOTFS/lib"
cp -r $DEST_DIR/lib/libz.so.1.* $OVERLAY_ROOTFS/lib/libz.so.1

echo "Bundle '$BUNDLE_NAME' has been installed."

cd $SRC_DIR
