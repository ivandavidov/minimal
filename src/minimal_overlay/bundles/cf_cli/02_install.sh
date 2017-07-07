#!/bin/sh

SRC_DIR=$(pwd)

. ../../common.sh

echo "Removing old cloud foundry artifacts. This may take a while..."
rm -rf $WORK_DIR/overlay/clofo/clofo_installed
mkdir -p $WORK_DIR/overlay/clofo/clofo_installed/opt/clofo
mkdir -p $WORK_DIR/overlay/clofo/clofo_installed/bin

cd $WORK_DIR/overlay/clofo

cp $MAIN_SRC_DIR/source/overlay/cf-cli.tgz .

tar -xvf cf-cli.tgz
rm -f LICENSE NOTICE cf-cli.tgz
chmod +rx cf

cp cf $WORK_DIR/overlay/clofo/clofo_installed/opt/clofo/cf

cd $WORK_DIR/overlay/clofo/clofo_installed

ln -s ../opt/clofo/cf bin/cf

cp -r $WORK_DIR/overlay/clofo/clofo_installed/* $WORK_DIR/src/minimal_overlay/rootfs

echo "cloud foundry cli has been installed."

cd $SRC_DIR

