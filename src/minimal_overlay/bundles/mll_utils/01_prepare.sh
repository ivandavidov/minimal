#!/bin/sh

SRC_DIR=$(pwd)

echo "Preparing the Minimal Linux Live utilities folder. This may take a while..."
rm -rf work/overlay/mll_utils
mkdir -p work/overlay/mll_utils/sbin

echo "Miminal Linux Live utilities folder has been prepared."

cd $SRC_DIR

