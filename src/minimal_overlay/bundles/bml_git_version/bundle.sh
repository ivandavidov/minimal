#!/bin/sh

set -e

. ../../common.sh

if [ ! -f $WORK_DIR/kernel/linux-*/.config ] ; then
  echo "Kernel configuration does not exist. Cannot continue."
  exit 1
fi

if [ ! -f $WORK_DIR/kernel/kernel_installed/kernel ] ; then
  echo "Kernel image does not exist. Cannot continue."
  exit 1
fi

cd `ls -d $WORK_DIR/kernel/linux-*`

# set version
commit="$(git rev-parse --short bare-minimal-linux)"
sed -i -e "s/^CONFIG_LOCALVERSION=.*/CONFIG_LOCALVERSION=\"-bml-$commit\"/" .config

make bzImage -j 4

cp arch/x86/boot/bzImage $WORK_DIR/kernel/kernel_installed/kernel

cd $SRC_DIR
