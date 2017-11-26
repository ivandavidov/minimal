#!/bin/bash

SRC_DIR=$(pwd)

. ../../common.sh

cd $WORK_DIR/src

mkdir -p ./minimal_overlay/rootfs/usr/src

shopt -s extglob

cp -r ./!(minimal_overlay/rootfs) ./minimal_overlay/rootfs/usr/src

shopt -u extglob

echo "Source files and folders have been copied to '/usr/src'."

cd $SRC_DIR
