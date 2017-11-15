#!/bin/bash

SRC_DIR=$(pwd)

. ../../common.sh

cd $WORK_DIR/overlay/vim

DESTDIR="$PWD/vim_installed"

# Change to the vim source directory which ls finds, e.g. 'vim-8.0.1298'.
cd $(ls -d vim-*)

echo "Preparing vim work area. This may take a while..."
make -j $NUM_JOBS clean

rm -rf $DESTDIR

echo "Setting vimrc location..."
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

echo "Configuring vim..."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr

echo "Building vim..."
make -j $NUM_JOBS

echo "Installing vim..."
make -j $NUM_JOBS install DESTDIR=$DESTDIR

echo "Generating vimrc..."
mkdir -p $DESTDIR/etc
cat > $DESTDIR/etc/vimrc << "EOF"
" Begin /etc/vimrc

set nocompatible
set backspace=2
set mouse=r
syntax on
set background=dark

" End /etc/vimrc
EOF

echo "Symlinking vim to vi..."
ln -sv vim $DESTDIR/usr/bin/vi
mkdir -p $DESTDIR/bin
ln -sv vim $DESTDIR/bin/vi

echo "Reducing vim size..."
strip -g $DESTDIR/usr/bin/*

ROOTFS="$WORK_DIR/src/minimal_overlay/rootfs"

cp -r $DESTDIR/* $ROOTFS

echo "vim has been installed."

cd $SRC_DIR

