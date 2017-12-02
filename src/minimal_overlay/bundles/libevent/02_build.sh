#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the libevent source directory which ls finds, e.g. 'libevent-2.1.8-stable'.
cd $(ls -d libevent-*)

if [ -f Makefile ] ; then
  echo "Preparing '$BUNDLE_NAME' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for '$BUNDLE_NAME' has been skipped."
fi

rm -rf $DEST_DIR

echo "Configuring '$BUNDLE_NAME'."
CFLAGS="$CFLAGS" ./configure

echo "Building '$BUNDLE_NAME'."
make -j $NUM_JOBS

echo "Installing '$BUNDLE_NAME'."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

echo "Reducing '$BUNDLE_NAME' size."
set +e
strip -g $DEST_DIR/usr/bin/*
set -e

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r $DEST_DIR/usr/local/* \
  $OVERLAY_ROOTFS

echo "Bundle '$BUNDLE_NAME' has been installed."

cd $SRC_DIR
