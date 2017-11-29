#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the vim source directory which ls finds, e.g. 'vim-8.0.1298'.
cd $(ls -d vim-*)

echo "Preparing vim work area. This may take a while."
make -j $NUM_JOBS clean

rm -rf $DEST_DIR

echo "Setting vimrc location."
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

echo "Configuring vim."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr

echo "Building vim."
make -j $NUM_JOBS

echo "Installing vim."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

echo "Generating vimrc."
mkdir -p $DEST_DIR/etc
cat > $DES_TDIR/etc/vimrc << "EOF"
" Begin /etc/vimrc

set nocompatible
set backspace=2
set mouse=r
syntax on
set background=dark

" End /etc/vimrc
EOF

echo "Symlinking vim to vi."
ln -sv vim $DEST_DIR/usr/bin/vi
mkdir -p $DEST_DIR/bin
ln -sv vim $DEST_DIR/bin/vi

echo "Reducing vim size."
strip -g $DEST_DIR/usr/bin/*

cp -r $DEST_DIR/* $OVERLAY_ROOTFS

echo "vim has been installed."

cd $SRC_DIR
