#!/bin/sh

SRC_DIR=$(pwd)

# Read the 'JOB_FACTOR' property from '.config'
JOB_FACTOR="$(grep -i ^JOB_FACTOR .config | cut -f2 -d'=')"

# Read the 'CFLAGS' property from '.config'
CFLAGS="$(grep -i ^CFLAGS .config | cut -f2 -d'=')"

# Find the number of available CPU cores.
NUM_CORES=$(grep ^processor /proc/cpuinfo | wc -l)

# Calculate the number of 'make' jobs to be used later.
NUM_JOBS=$((NUM_CORES * JOB_FACTOR))

cd work/overlay/links

# Change to the Links source directory which ls finds, e.g. 'links-2.12'.
cd $(ls -d links-*)

echo "Preparing Links work area. This may take a while..."
make clean -j $NUM_JOBS 2>/dev/null

rm -rf ../links_installed

echo "Configuring Links..."
./configure \
  --prefix=../links_installed \
  --disable-graphics \
  --disable-utf8 \
  --without-ipv6 \
  --without-ssl \
  --without-zlib \
  --without-x

# Set CFLAGS directly in Makefile.
sed -i "s/^CFLAGS = .*/CFLAGS = $CFLAGS/" Makefile

echo "Building Links..."
make -j $NUM_JOBS

echo "Installing Links..."
make install -j $NUM_JOBS

echo "Reducing Links size..."
strip -g ../links_installed/bin/* 2>/dev/null

cp -r ../links_installed/bin $SRC_DIR/work/src/minimal_overlay
echo "Links has been installed."

cd $SRC_DIR

