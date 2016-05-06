#!/bin/sh

SRC_DIR=$(pwd)

cd work/overlay/links

# Change to the Links source directory which ls finds, e.g. 'links-2.12'.
cd $(ls -d links-*)

echo "Preparing Links work area. This may take a while..."
make clean 2>/dev/null

echo "Configuring Links..."
./configure \
  --prefix=../links_installed \
  --disable-graphics \
  --enable-utf8 \
  --without-ipv6 \
  --without-ssl \
  --without-x

echo "Building Links..."
make

make install
cp -r ../links_installed/bin $SRC_DIR/work/src/minimal_overlay
 
echo "Links has been installed."

cd $SRC_DIR

