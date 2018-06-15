#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME
mv `ls -d *` $BUNDLE_NAME

mkdir opt
mv zulujdk opt

mkdir $WORK_DIR/overlay/$BUNDLE_NAME/bin
cd $WORK_DIR/overlay/$BUNDLE_NAME/bin

for FILE in $(ls ../opt/$BUNDLE_NAME/bin)
do
  ln -s ../opt/$BUNDLE_NAME/bin/$FILE $FILE
done

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $WORK_DIR/overlay/$BUNDLE_NAME/* \
  $OVERLAY_ROOTFS

echo "Zulu JDK has been installed."

cd $SRC_DIR
