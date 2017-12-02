#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the dialog source directory which ls finds, e.g. 'dialog-1.3-20170509'.
cd $(ls -d dialog-*)

if [ -f Makefile ] ; then
  echo "Preparing 'dialog' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for 'dialog' has been skipped."
fi

rm -rf $DEST_DIR

echo "Configuring 'dialog'."
CFLAGS="$CFLAGS" ./configure \
    --prefix=/usr

echo "Building 'dialog'."
make -j $NUM_JOBS

echo "Installing 'dialog'."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

rm -rf $DEST_DIR/usr/lib $DEST_DIR/usr/share

echo "Reducing 'dialog' size."
set +e
strip -g $DEST_DIR/usr/bin/*
set -e

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/usr \
  $OVERLAY_ROOTFS

echo "Bundle 'dialog' has been installed."

cd $SRC_DIR
