#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the Links source directory which ls finds, e.g. 'libxcrypt-4.4.17'.
cd $(ls -d libxcrypt-*)

echo "Generating configure."
./autogen.sh

rm -rf $DEST_DIR

echo "Configuring '$BUNDLE_NAME'."
CFLAGS="$CFLAGS" ./configure \
  --prefix=$DEST_DIR

echo "Preparing '$BUNDLE_NAME' work area. This may take a while."
make clean

echo "Building '$BUNDLE_NAME'."
make -j $NUM_JOBS

echo "Installing '$BUNDLE_NAME'."
make -j $NUM_JOBS install

echo "Reducing '$BUNDLE_NAME' size."
set +e
strip -g $DEST_DIR/lib/*
set -e

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/lib/libcrypt.so* $OVERLAY_ROOTFS/lib/

echo "Bundle '$BUNDLE_NAME' has been installed."

cd $SRC_DIR
