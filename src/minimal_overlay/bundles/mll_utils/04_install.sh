#!/bin/sh

set -e

. ../../common.sh

if [ ! -d "$WORK_DIR/overlay/$BUNDLE_NAME" ] ; then
  echo "The directory '$WORK_DIR/overlay/$BUNDLE_NAME' does not exist. Cannot continue."
  exit 1
fi

# Copy all generated files to the source overlay folder.
# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r $WORK_DIR/overlay/$BUNDLE_NAME/* \
  $OVERLAY_ROOTFS

echo "All MLL utilities have been installed."

cd $SRC_DIR
