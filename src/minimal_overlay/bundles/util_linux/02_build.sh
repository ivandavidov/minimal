#!/bin/sh

set -e

. ../../common.sh
. ../../../settings

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the util-linux source directory which ls finds, e.g. 'util-linux-2.34'.
cd $(ls -d util-linux-$UTIL_LINUX_VERSION)

if [ -f Makefile ] ; then
  echo "Preparing '$BUNDLE_NAME' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for '$BUNDLE_NAME' has been skipped."
fi

rm -rf $DEST_DIR
mkdir -p $DEST_DIR/usr/share/doc/util-linux
mkdir -p $DEST_DIR/bin

echo "Configuring '$BUNDLE_NAME'."
./autogen.sh && \
CFLAGS="$CFLAGS" ./configure \
  ADJTIME_PATH=/var/lib/hwclock/adjtime   \
  --prefix=$DEST_DIR \
  --docdir=$DEST_DIR/usr/share/doc/util-linux \
  --disable-chfn-chsh  \
  --disable-login      \
  --disable-nologin    \
  --disable-su         \
  --disable-setpriv    \
  --disable-runuser    \
  --disable-pylibmount \
  --disable-static     \
  --disable-makeinstall-chown \
  --enable-sfdisk \
  --enable-mkfs
  #--enable-libblkid \
  #--enable-libuuid \
  #--enable-libsmartcols \
  #--without-python     \
  #--without-systemd    \
  #--without-systemdsystemunitdir

echo "Building '$BUNDLE_NAME'."
make -j $NUM_JOBS

echo "Installing '$BUNDLE_NAME'."
make -j $NUM_JOBS install

cp -r /lib/x86_64-linux-gnu/libtinfo.so.6.3 $DEST_DIR/lib
cd $DEST_DIR/lib
ln -s libtinfo.so.6.3 libtinfo.so.6
cd $(ls -d util-linux-$UTIL_LINUX_VERSION)


echo "Reducing '$BUNDLE_NAME' size."
reduce_size $DEST_DIR/bin
reduce_size $DEST_DIR/sbin
reduce_size $DEST_DIR/lib

install_to_overlay bin
install_to_overlay sbin
install_to_overlay lib

echo "Bundle '$BUNDLE_NAME' has been installed."

cd $SRC_DIR

