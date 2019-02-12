#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the ethtool source directory which ls finds, e.g. 'ethtool-1.0.3'.
cd $(ls -d ethtool-*)

if [ -f Makefile ] ; then
  echo "Preparing '$BUNDLE_NAME' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for '$BUNDLE_NAME' has been skipped."
fi

rm -rf $DEST_DIR

#echo "Setting 'vimrc' location."
#echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

echo "Configuring '$BUNDLE_NAME'."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr --libdir=/lib \

echo "Building '$BUNDLE_NAME'."
make -j $NUM_JOBS

echo "Installing '$BUNDLE_NAME'."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

#echo "Generating '$BUNDLE_NAME'."
#mkdir -p $DEST_DIR/etc
#cat > $DEST_DIR/etc/vimrc << "EOF"
#" Begin /etc/vimrc
#
#set nocompatible
#set backspace=2
#set mouse=r
#syntax on
#set background=dark
#
#" End /etc/vimrc
#EOF

#echo "Symlinking 'vim' to 'vi'."
#ln -sv vim $DEST_DIR/usr/bin/vi
#mkdir -p $DEST_DIR/bin
#ln -sv vim $DEST_DIR/bin/vi

#mkdir -p $DESTDIR/var/run/

echo "Reducing '$BUNDLE_NAME' size."
set +e
strip -g $DEST_DIR/usr/sbin/ethtool
set -e

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/* \
  $OVERLAY_ROOTFS

echo "Bundle '$BUNDLE_NAME' has been installed."

cd $SRC_DIR
