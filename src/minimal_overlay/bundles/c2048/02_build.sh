#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

rm -f 2048

gcc $CFLAGS -o 2048 2048.c
strip -g 2048

mkdir -p $OVERLAY_ROOTFS/usr/bin
cp --remove-destination $PWD/2048 $OVERLAY_ROOTFS/usr/bin/

echo "Bundle 'c2048' has been installed."

cd $SRC_DIR
