#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the lshw source directory which ls finds, e.g. 'lshw-1.0.3'.
cd $(ls -d lshw-*)/src

if [ -f Makefile ] ; then
  echo "Preparing '$BUNDLE_NAME' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for '$BUNDLE_NAME' has been skipped."
fi

rm -rf $DEST_DIR

echo "Building '$BUNDLE_NAME'."
make compressed ZLIB=1

echo "Installing '$BUNDLE_NAME'."
make install DESTDIR=$DEST_DIR ZLIB=1
install -p -m 0755 lshw-compressed $DEST_DIR/usr/sbin/lshw

# datafiles are somehow in wrong place with current git HEAD
mv $DEST_DIR/usr/share/lshw $DEST_DIR/usr/share/hwdata

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/* \
  $OVERLAY_ROOTFS

echo "Bundle '$BUNDLE_NAME' has been installed."

cd $SRC_DIR
