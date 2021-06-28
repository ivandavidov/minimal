#!/bin/sh

set -e

. ../../common.sh

cd $OVERLAY_WORK_DIR/$BUNDLE_NAME
mv `ls -d *` adoptopenjdk

rm -rf $DEST_DIR
mkdir -p $DEST_DIR/bin
mkdir -p $DEST_DIR/opt

mv adoptopenjdk $DEST_DIR/opt

cd $DEST_DIR/bin

for FILE in $(ls ../opt/adoptopenjdk/bin)
do
  ln -s ../opt/adoptopenjdk/bin/$FILE $FILE
done

install_to_overlay

echo "$BUNDLE_NAME has been installed."

cd $SRC_DIR
