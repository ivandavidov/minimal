#!/bin/sh

SRC_DIR=$(pwd)

. ../../common.sh

cd $SRC_DIR

cd $WORK_DIR/src

ROOTFS="$WORK_DIR/src/minimal_overlay/rootfs"
mkdir -p "$ROOTFS/usr/src"

# maybe use find instead
shopt -s extglob
cp -r !("$ROOTFS") "$WORK_DIR/src" "$ROOTFS/usr/src"
shopt +u extglob

echo "Source files and folders have been copied to '/src'."
