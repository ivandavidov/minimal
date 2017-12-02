#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the kbd source directory which ls finds, e.g. 'kbd-2.04'.
cd $(ls -d kbd-*)

if [ -f Makefile ] ; then
  echo "Preparing '$BUNDLE_NAME' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for '$BUNDLE_NAME' has been skipped."
fi

rm -rf $DEST_DIR

echo "Configuring '$BUNDLE_NAME'."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr \
  --disable-vlock
# vlock requires PAM

echo "Building '$BUNDLE_NAME'."
make -j $NUM_JOBS

echo "Installing '$BUNDLE_NAME'."
make -j $NUM_JOBS install DESTDIR="$DEST_DIR"

echo "Reducing '$BUNDLE_NAME' size."
set +e
strip -g \
  $DEST_DIR/usr/bin/* \
  $DEST_DIR/usr/sbin/* \
  $DEST_DIR/lib/*
set -e

mkdir -p $OVERLAY_ROOTFS/usr
mkdir -p $OVERLAY_ROOTFS/etc/autorun

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination "$DEST_DIR/usr/bin" "$DEST_DIR/usr/share" \
  "$OVERLAY_ROOTFS/usr/"
cp -r --remove-destination "$SRC_DIR/90_kbd.sh" \
  "$OVERLAY_ROOTFS/etc/autorun"

echo "Bundle '$BUNDLE_NAME' has been installed."

cd $SRC_DIR
