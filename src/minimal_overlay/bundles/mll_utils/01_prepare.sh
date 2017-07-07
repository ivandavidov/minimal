#!/bin/sh

SRC_DIR=$(pwd)

. ../../common.sh

echo "Preparing the Minimal Linux Live utilities folder. This may take a while..."
rm -rf $WORK_DIR/overlay/mll_utils
mkdir -p $WORK_DIR/overlay/mll_utils/sbin

echo "Miminal Linux Live utilities folder has been prepared."

cd $SRC_DIR

