#!/bin/sh

SRC_DIR=$(pwd)

# Find the main source directory
cd ../../..
MAIN_SRC_DIR=$(pwd)
cd $SRC_DIR

echo "Removing old static-get artifacts. This may take a while..."
rm -rf $MAIN_SRC_DIR/work/overlay/staget/staget_installed
mkdir -p $MAIN_SRC_DIR/work/overlay/staget/staget_installed/opt/staget
mkdir -p $MAIN_SRC_DIR/work/overlay/staget/staget_installed/bin

cd $MAIN_SRC_DIR/work/overlay/staget

cp $MAIN_SRC_DIR/source/overlay/static-get.sh .

chmod +rx static-get.sh

cp static-get.sh $MAIN_SRC_DIR/work/overlay/staget/staget_installed/opt/staget

cd $MAIN_SRC_DIR/work/overlay/staget/staget_installed

ln -s ../opt/staget/static-get.sh bin/static-get

cp -r $MAIN_SRC_DIR/work/overlay/staget/staget_installed/* \
  $MAIN_SRC_DIR/work/src/minimal_overlay/rootfs

echo "static-get has been installed."

cd $SRC_DIR

