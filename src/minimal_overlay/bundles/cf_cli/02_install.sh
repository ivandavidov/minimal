#!/bin/sh

SRC_DIR=$(pwd)

# Find the main source directory
cd ../../..
MAIN_SRC_DIR=$(pwd)
cd $SRC_DIR

echo "Removing old cloud foundry artifacts. This may take a while..."
rm -rf $MAIN_SRC_DIR/work/overlay/clofo/clofo_installed
mkdir -p $MAIN_SRC_DIR/work/overlay/clofo/clofo_installed/opt/clofo
mkdir -p $MAIN_SRC_DIR/work/overlay/clofo/clofo_installed/bin

cd $MAIN_SRC_DIR/work/overlay/clofo

cp $MAIN_SRC_DIR/source/overlay/cf-cli.tgz .

tar -xvf cf-cli.tgz
rm -f LICENSE NOTICE cf-cli.tgz
chmod +rx cf

cp cf $MAIN_SRC_DIR/work/overlay/clofo/clofo_installed/opt/clofo/cf

cd $MAIN_SRC_DIR/work/overlay/clofo/clofo_installed

ln -s ../opt/clofo/cf bin/cf

cp -r $MAIN_SRC_DIR/work/overlay/clofo/clofo_installed/* \
  $MAIN_SRC_DIR/work/src/minimal_overlay/rootfs

echo "cloud foundry cli has been installed."

cd $SRC_DIR

