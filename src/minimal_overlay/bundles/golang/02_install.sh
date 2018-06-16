#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME
mv `ls -d *` $BUNDLE_NAME

mkdir opt
mv $BUNDLE_NAME opt

mkdir -p usr/local
cd $WORK_DIR/overlay/$BUNDLE_NAME/usr/local
ln -s ../../opt/$BUNDLE_NAME go

mkdir $WORK_DIR/overlay/$BUNDLE_NAME/bin
cd $WORK_DIR/overlay/$BUNDLE_NAME/bin

for FILE in $(ls ../usr/local/go/bin)
do
  ln -s ../usr/local/go/bin/$FILE $FILE
done

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $WORK_DIR/overlay/$BUNDLE_NAME/* \
  $OVERLAY_ROOTFS

echo "Golang has been installed."

cd $SRC_DIR
