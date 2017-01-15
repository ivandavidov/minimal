#!/bin/sh

SRC_DIR=$(pwd)

# Find the main source directory
cd ../../..
MAIN_SRC_DIR=$(pwd)
cd $SRC_DIR

echo "Preparing the Minimal Linux Live utilities folder. This may take a while..."
rm -rf $MAIN_SRC_DIR/work/overlay/mll_utils
mkdir -p $MAIN_SRC_DIR/work/overlay/mll_utils/sbin

echo "Miminal Linux Live utilities folder has been prepared."

cd $SRC_DIR

