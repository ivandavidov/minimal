#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the lldpd source directory which ls finds, e.g. 'lldpd-1.0.3'.
cd $(ls -d lldpd-*)

if [ -f Makefile ] ; then
  echo "Preparing '$BUNDLE_NAME' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for '$BUNDLE_NAME' has been skipped."
fi

rm -rf $DEST_DIR

echo "Configuring '$BUNDLE_NAME'."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr --libdir=/lib \
  --enable-privsep=no --enable-static=no \
  --with-lldpd-ctl-socket=/lldpd.sock \
  --enable-fdp=no --enable-edp=no --enable-sonmp=no

echo "Building '$BUNDLE_NAME'."
make -j $NUM_JOBS

echo "Installing '$BUNDLE_NAME'."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

echo "Generating '$BUNDLE_NAME'."
mkdir -p $DEST_DIR/etc

mkdir -p $DESTDIR/var/run/

echo "Reducing '$BUNDLE_NAME' size."
set +e
strip -g $DEST_DIR/usr/sbin/lldp*
set -e

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/* \
  $OVERLAY_ROOTFS

echo "Bundle '$BUNDLE_NAME' has been installed."

cd $SRC_DIR
