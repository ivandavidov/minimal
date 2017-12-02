#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the fio source directory which ls finds, e.g. 'fio-3.2'.
cd $(ls -d fio-*)

if [ -f Makefile ] ; then
  echo "Preparing 'fio' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for 'fio' has been skipped."
fi

rm -rf $DEST_DIR

echo "Configuring 'fio'."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr

echo "Building 'fio'."
make -j $NUM_JOBS

echo "Installing 'fio'."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

echo "Reducing 'fio' size."
set +e
strip -g $DEST_DIR/usr/bin/*
set -e

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/* \
  $OVERLAY_ROOTFS

echo "Bundle 'fio' has been installed."

cd $SRC_DIR
