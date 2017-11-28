#!/bin/sh

set -e

echo "*** GENERATE IMAGE BEGIN ***"

SRC_DIR=$(pwd)

# Prepare the work area.
rm -f mll_image.tgz
rm -rf $SRC_DIR/work/mll_image
mkdir -p $SRC_DIR/work/mll_image

# Copy the rootfs.
cp -r $SRC_DIR/work/rootfs/* \
  $SRC_DIR/work/mll_image

# Copy the overlay area.
cp -r $SRC_DIR/work/src/minimal_overlay/rootfs/* \
  $SRC_DIR/work/mll_image

cd $SRC_DIR/work/mll_image

# Generate the image file (ordinary 'tgz').
tar -zcf $SRC_DIR/mll_image.tgz *

cat << CEOF

  ##################################################################
  #                                                                #
  #  Minimal Linux Live image 'mll_image.tgz' has been generated.  #
  #                                                                #
  #  You can import the MLL image in Docker like this:             #
  #                                                                #
  #    docker import mll_image.tgz minimal-linux-live:latest       #
  #                                                                #
  #  Then you can run MLL container in Docker like this:           #
  #                                                                #
  #    docker run -it minimal-linux-live /bin/sh                   #
  #                                                                #
  ##################################################################

CEOF

echo "*** GENERATE IMAGE END ***"
