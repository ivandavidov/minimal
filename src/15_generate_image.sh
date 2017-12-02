#!/bin/sh

set -e

echo "*** GENERATE IMAGE BEGIN ***"

SRC_DIR=$(pwd)

# Prepare the work area.
rm -f mll_image.tgz
rm -rf $SRC_DIR/work/mll_image
mkdir -p $SRC_DIR/work/mll_image

if [ -d $SRC_DIR/work/rootfs ] ; then
  # Copy the rootfs.
  cp -r $SRC_DIR/work/rootfs/* \
    $SRC_DIR/work/mll_image
else
  echo "Cannot continue - rootfs is missing."
  exit 1
fi

if [ -d $SRC_DIR/work/overlay_rootfs ] ; then
  echo "Merging overlay software in image."

  # Copy the overlay content.
  # With '--remove-destination' all possibly existing soft links in
  # '$SRC_DIR/work/mll_image' will be overwritten correctly.
  cp -r --remove-destination $SRC_DIR/work/overlay_rootfs/* \
    $SRC_DIR/work/mll_image
  cp -r --remove-destination $SRC_DIR/minimal_overlay/rootfs/* \
    $SRC_DIR/work/mll_image
else
  echo "MLL image will have no overlay software."
fi

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
  #  Then you can run MLL shell in Docker container like this:     #
  #                                                                #
  #    docker run -it minimal-linux-live /bin/sh                   #
  #                                                                #
  ##################################################################

CEOF

echo "*** GENERATE IMAGE END ***"
