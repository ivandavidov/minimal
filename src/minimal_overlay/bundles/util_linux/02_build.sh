#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

if [ ! "$(id -u)" = "0" ] ; then
  cat << CEOF

  The build process for bundle '$BUNDLE_NAME' requires root
  permissions. Restart the build process as 'root' in order
  to build '$BUNDLE_NAME'.
  
CEOF

  exit 1
fi

# Change to the util-linux source directory which ls finds, e.g. 'util-linux-2.31'.
cd $(ls -d util-linux-*)

if [ -f Makefile ] ; then
  echo "Preparing '$BUNDLE_NAME' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for '$BUNDLE_NAME' has been skipped."
fi

rm -rf $DEST_DIR

echo "Configuring '$BUNDLE_NAME'."
CFLAGS="$CFLAGS" ./configure \
  ADJTIME_PATH=/var/lib/hwclock/adjtime   \
  --docdir=/usr/share/doc/util-linux-2.31 \
  --disable-chfn-chsh  \
  --disable-login      \
  --disable-nologin    \
  --disable-su         \
  --disable-setpriv    \
  --disable-runuser    \
  --disable-pylibmount \
  --disable-static     \
  --without-python     \
  --without-systemd    \
  --without-systemdsystemunitdir

echo "Building '$BUNDLE_NAME'."
make -j $NUM_JOBS

echo "Installing '$BUNDLE_NAME'."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

echo "Reducing '$BUNDLE_NAME' size."
set +e
strip -g $DEST_DIR/usr/bin/*
set -e

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/* \
  $OVERLAY_ROOTFS

echo "Bundle '$BUNDLE_NAME' has been installed."

cd $SRC_DIR
