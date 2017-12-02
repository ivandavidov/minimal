#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the kexec-tools source directory which ls finds, e.g. 'kexec-tools-2.0.15'.
cd $(ls -d kexec-tools-*)

if [ -f Makefile ] ; then
  echo "Preparing '$BUNDLE_NAME' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for '$BUNDLE_NAME' has been skipped."
fi

rm -rf $DEST_DIR

echo "Building '$BUNDLE_NAME'."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr \
  --without-lzama

make -j $NUM_JOBS

make -j $NUM_JOBS install DESTDIR="$DEST_DIR"

echo "Reducing '$BUNDLE_NAME' size."
set +e
strip -g $DEST_DIR/usr/bin/* \
  $DEST_DIR/usr/lib/* 2>/dev/null
set -e

mkdir -p $OVERLAY_ROOTFS/usr/

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/usr/* \
  $OVERLAY_ROOTFS/usr/

echo "Bundle '$BUNDLE_NAME' has been installed."

cd $SRC_DIR
