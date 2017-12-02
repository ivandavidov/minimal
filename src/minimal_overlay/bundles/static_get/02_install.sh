#!/bin/sh

set -e

. ../../common.sh

echo "Removing old 'static-get' artifacts. This may take a while."
rm -rf $DEST_DIR
mkdir -p $DEST_DIR/opt/$BUNDLE_NAME
mkdir -p $DEST_DIR/bin

cd $WORK_DIR/overlay/$BUNDLE_NAME

cp $MAIN_SRC_DIR/source/overlay/static-get.sh .

chmod +rx static-get.sh

cp static-get.sh $DEST_DIR/opt/$BUNDLE_NAME

cd $DEST_DIR

ln -s ../opt/$BUNDLE_NAME/static-get.sh bin/static-get
ln -s ../opt/$BUNDLE_NAME/static-get.sh bin/mll-get

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/* \
  $OVERLAY_ROOTFS

echo "Bundle 'static-get' has been installed."

cd $SRC_DIR
