#!/bin/sh

set -e

echo "*** PREPARE SYSROOT BEGIN ***"

SRC_DIR=$(pwd)

cd work

echo "Cleaning existing sysroot. This may take a while."
rm -rf sysroot

echo "Preparing glibc. This may take a while."
mkdir -p sysroot/usr
ln -s ../include sysroot/usr/include
ln -s ../lib sysroot/usr/lib

cp -r kernel/kernel_installed/include sysroot
cp -r glibc/glibc_installed/* sysroot

cd $SRC_DIR

echo "*** PREPARE SYSROOT END ***"
