#!/bin/sh

set -e

. ../../common.sh

echo "Removing old 'BOSH CLI' artifacts. This may take a while."
rm -rf $DEST_DIR
mkdir -p $DEST_DIR/opt/$BUNDLE_NAME
mkdir -p $DEST_DIR/usr/bin

cd $DEST_DIR

cp $MAIN_SRC_DIR/source/overlay/bosh-cli opt/$BUNDLE_NAME/bosh

chmod +rx opt/$BUNDLE_NAME/bosh

cd $DEST_DIR/usr/bin

ln -s ../../opt/$BUNDLE_NAME/bosh bosh

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/* \
  $OVERLAY_ROOTFS

echo "Bundle 'BOSH CLI' has been installed."

cd $SRC_DIR
