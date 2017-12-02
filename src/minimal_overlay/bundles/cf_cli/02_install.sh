#!/bin/sh

set -e

. ../../common.sh

echo "Removing old cloud foundry artifacts. This may take a while."
rm -rf $DEST_DIR
mkdir -p $DEST_DIR/opt/$BUNDLE_NAME
mkdir -p $DEST_DIR/bin

cd $WORK_DIR/overlay/$BUNDLE_NAME

cp $MAIN_SRC_DIR/source/overlay/cf-cli.tgz .

tar -xvf cf-cli.tgz
rm -f LICENSE NOTICE cf-cli.tgz
chmod +rx cf

cp cf $DEST_DIR/opt/$BUNDLE_NAME/cf

cd $DEST_DIR

ln -s ../opt/$BUNDLE_NAME/cf bin/cf

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/* \
  $OVERLAY_ROOTFS

echo "Cloud Foundry CLI has been installed."

cd $SRC_DIR
