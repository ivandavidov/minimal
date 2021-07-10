#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Read the common configuration properties.
INSTALL_PIP=`read_property INSTALL_PIP`
PIP_PACKAGES=`read_property PIP_INSTALL_PACKAGES`

if [ "$INSTALL_PIP" = "true" ] ; then
  echo "Installing pip packages."
  for package in ${PIP_PACKAGES//,/ }
  do 
    echo "Installing package '$package'."

    CFLAGS="$CFLAGS" \
	CXXFLAGS="$CXXFLAGS" \
	$DEST_DIR/usr/bin/python3 -m pip install --force-reinstall \
      --global-option=build_ext --global-option="--include-dirs=$OVERLAY_ROOTFS/include:$OVERLAY_ROOTFS/usr/include" \
      --global-option=build_ext --global-option="--library-dirs=$OVERLAY_ROOTFS/lib:$OVERLAY_ROOTFS/usr/lib" \
      --global-option=build_ext --global-option="--plat-name=linux-x86_64" \
      --global-option=build_ext --global-option="--force" \
      $package
  done
fi

cd $SRC_DIR
