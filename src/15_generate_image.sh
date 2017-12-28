#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** GENERATE IMAGE BEGIN ***"

# Prepare the work area.
rm -f $SRC_DIR/mll_image.tgz
rm -rf $WORK_DIR/mll_image
mkdir -p $WORK_DIR/mll_image

if [ -d $ROOTFS ] ; then
  # Copy the rootfs.
  cp -r $ROOTFS/* \
    $WORK_DIR/mll_image
else
  echo "Cannot continue - rootfs is missing."
  exit 1
fi

if [ -d $OVERLAY_ROOTFS ] && \
   [ ! "`ls -A $OVERLAY_ROOTFS`" = "" ] ; then

  echo "Merging overlay software in image."

  # Copy the overlay content.
  # With '--remove-destination' all possibly existing soft links in
  # $WORK_DIR/mll_image will be overwritten correctly.
  cp -r --remove-destination $OVERLAY_ROOTFS/* \
    $WORK_DIR/mll_image
  cp -r --remove-destination $SRC_DIR/minimal_overlay/rootfs/* \
    $WORK_DIR/mll_image
else
  echo "MLL image will have no overlay software."
fi

cd $WORK_DIR/mll_image

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
