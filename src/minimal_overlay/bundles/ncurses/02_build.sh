#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the ncurses source directory which ls finds, e.g. 'ncurses-6.0'.
cd $(ls -d ncurses-*)

if [ -f Makefile ] ; then
  echo "Preparing '$BUNDLE_NAME' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for '$BUNDLE_NAME' has been skipped."
fi

rm -rf $DEST_DIR

# Remove static library
sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in
# http://www.linuxfromscratch.org/lfs/view/development/chapter06/ncurses.html

echo "Configuring '$BUNDLE_NAME'."
CFLAGS="$CFLAGS" ./configure \
    --prefix=/usr \
    --with-termlib \
    --with-terminfo-dirs=/lib/terminfo \
    --with-default-terminfo-dirs=/lib/terminfo \
    --without-normal \
    --without-debug \
    --without-ada \
    --without-cxx-binding \
    --with-abi-version=6 \
    --enable-widec \
    --enable-pc-files \
    --with-shared \
    CPPFLAGS=-I$PWD/ncurses/widechar \
    LDFLAGS=-L$PWD/lib \
    CPPFLAGS="-P"

# Most configuration switches are from AwlsomeAlex
# https://github.com/AwlsomeAlex/AwlsomeLinux/blob/59d59730703b058081a2371076a807590cacb31e/src/overlay_ncurses.sh

# CPPFLAGS fixes a bug with Ubuntu 16.04
# https://trac.sagemath.org/ticket/19762

echo "Building '$BUNDLE_NAME'."
make -j $NUM_JOBS

echo "Installing '$BUNDLE_NAME'."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

# Symnlink wide character libraries
cd $DEST_DIR/usr/lib
ln -s libncursesw.so.5 libncurses.so.5
ln -s libncurses.so.5 libncurses.so
ln -s libtinfow.so.5 libtinfo.so.5
ln -s libtinfo.so.5 libtinfo.so

echo "Reducing '$BUNDLE_NAME' size."
set +e
strip -g $DEST_DIR/usr/bin/*
set -e

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/usr/* \
  $OVERLAY_ROOTFS

echo "Bundle '$BUNDLE_NAME' has been installed."

cd $SRC_DIR
