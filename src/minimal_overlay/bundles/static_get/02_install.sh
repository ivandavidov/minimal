#!/bin/sh

SRC_DIR=$(pwd)

. ../../common.sh

echo "Removing old static-get artifacts. This may take a while..."
rm -rf $WORK_DIR/overlay/$BUNDLE_NAME/$BUNDLE_NAME_installed
mkdir -p $WORK_DIR/overlay/$BUNDLE_NAME/$BUNDLE_NAME_installed/opt/$BUNDLE_NAME
mkdir -p $WORK_DIR/overlay/$BUNDLE_NAME/$BUNDLE_NAME_installed/bin

cd $WORK_DIR/overlay/$BUNDLE_NAME

cp $MAIN_SRC_DIR/source/overlay/static-get.sh .

chmod +rx static-get.sh

cp static-get.sh $WORK_DIR/overlay/$BUNDLE_NAME/$BUNDLE_NAME_installed/opt/$BUNDLE_NAME

cd $WORK_DIR/overlay/$BUNDLE_NAME/$BUNDLE_NAME_installed

ln -s ../opt/$BUNDLE_NAME/static-get.sh bin/static-get
ln -s ../opt/$BUNDLE_NAME/static-get.sh bin/mll-get

cp -r $WORK_DIR/overlay/$BUNDLE_NAME/$BUNDLE_NAME_installed/* \
  $WORK_DIR/src/minimal_overlay/rootfs

echo "static-get has been installed."

cd $SRC_DIR

