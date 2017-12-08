#!/bin/sh

set -e

. ../../common.sh

if [ ! -f `ls $WORK_DIR/kernel/linux-*/.config` ] ; then
  echo "Kernel configuration does not exist. Cannot continue."
  exit 1
else
  echo "Kernel configuration exists."
fi

rm -rf $DEST_DIR

cd $WORK_DIR/kernel/linux-*

echo "Building kernel modules."
make_target modules

echo "Installing kernel modules."
make_target \
  INSTALL_MOD_PATH=$DEST_DIR \
  modules_install

echo "Removing unnecessary links."
cd $DEST_DIR/lib/modules/*
unlink build
unlink source

echo "Reducing the size of all generated kernel modules."
reduce_size $DEST_DIR/lib/modules

mkdir -p $DEST_DIR/etc/autorun
cp $SRC_DIR/10_modules.sh $DEST_DIR/etc/autorun

install_to_overlay

cd $SRC_DIR
