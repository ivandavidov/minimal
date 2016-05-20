#!/bin/sh

SRC_DIR=$(pwd)

cd work/overlay/links

# Change to the Links source directory which ls finds, e.g. 'links-2.12'.
cd $(ls -d links-*)

echo "Preparing Links work area. This may take a while..."
make clean 2>/dev/null

rm -rf ../links_installed

echo "Configuring Links..."
./configure \
  --prefix=../links_installed \
  --disable-graphics \
  --disable-utf8 \
  --without-ipv6 \
  --without-ssl \
  --without-x

# Set CFLAGS directly in Makefile.
sed -i "s/^CFLAGS = .*/CFLAGS = \\-Os \\-s \\-fno\\-stack\\-protector \\-U_FORTIFY_SOURCE/" Makefile

echo "Building Links..."
make

echo "Installing Links..."
make install

echo "Reducing Links size..."
strip -g ../links_installed/bin/* 2>/dev/null

cp -r ../links_installed/bin $SRC_DIR/work/src/minimal_overlay
echo "Links has been installed."

cd $SRC_DIR

