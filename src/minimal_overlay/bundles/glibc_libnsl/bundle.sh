#!/bin/sh

set -e

. ../../common.sh

if [ ! -d $SYSROOT ] ; then
  echo "Cannot continue - GLIBC is missing. Please buld GLIBC first."
  exit 1
fi

mkdir -p "$WORK_DIR/overlay/$BUNDLE_NAME"
cd $WORK_DIR/overlay/$BUNDLE_NAME

rm -rf $DEST_DIR

mkdir -p $DEST_DIR/lib
cp $SYSROOT/lib/libnsl.so.1 $DEST_DIR/lib/
ln -s libnsl.so.1 $DEST_DIR/lib/libnsl.so

echo "Reducing '$BUNDLE_NAME' size."
set +e
strip -g $DEST_DIR/lib/*
set -e

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/* \
  $OVERLAY_ROOTFS

echo "Bundle '$BUNDLE_NAME' has been installed."

cd $SRC_DIR
