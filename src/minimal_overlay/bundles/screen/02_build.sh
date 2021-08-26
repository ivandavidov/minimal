#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the screen source directory which ls finds, e.g. 'screen-4.8.0'.
cd $(ls -d screen-*)

if [ -f Makefile ] ; then
  echo "Preparing '$BUNDLE_NAME' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for '$BUNDLE_NAME' has been skipped."
fi

rm -rf $DEST_DIR

echo "Configuring '$BUNDLE_NAME'."
CFLAGS="$CFLAGS -I${OVERLAY_ROOTFS}/include" \
LDFLAGS="$LDFLAGS -L${OVERLAY_ROOTFS}/lib -L${OVERLAY_ROOTFS}/usr/lib" \
  ./configure --prefix=/usr

# Remove the dependency to libutempter as it is
# not available on the target system.
echo "Patching configuration of '$BUNDLE_NAME'."
sed -i 's|-lutempter||g' Makefile
sed -i 's|#define HAVE_UTEMPTER 1||g' config.h

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
cp -r --remove-destination $DEST_DIR/* \
  $OVERLAY_ROOTFS

echo "Bundle '$BUNDLE_NAME' has been installed."

cd $SRC_DIR
