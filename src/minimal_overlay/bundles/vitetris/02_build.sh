#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME/vitetris-master

echo "Preparing '$BUNDLE_NAME' work area. This may take a while."
make -j $NUM_JOBS clean

rm -rf $DEST_DIR

echo "Configuring '$BUNDLE_NAME'."
CFLAGS="$CFLAGS" ./configure \
  --prefix=$WORK_DIR/overlay/$BUNDLE_NAME/vitetris-master \
  2player=no \
  joystick=no \
  network=no \
  curses=no \
  allegro=no \
  xlib=no \
  term_resizing=no \
  menu=no \
  blockstyles=no \
  pctimer=no

echo "Building '$BUNDLE_NAME'."
make -j $NUM_JOBS

echo "Installing '$BUNDLE_NAME'."
mkdir $DEST_DIR
cp tetris $DEST_DIR

echo "Reducing '$BUNDLE_NAME' size."
set +e
strip -g $DEST_DIR/*
set -e

mkdir -p "$OVERLAY_ROOTFS/bin"
cp -r $DEST_DIR/tetris $OVERLAY_ROOTFS/bin/tetris

echo "Bundle '$BUNDLE_NAME' has been installed."

cd $SRC_DIR

