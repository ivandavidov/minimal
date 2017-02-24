#!/bin/sh

SRC_DIR=$(pwd)

# Read the 'JOB_FACTOR' property from '.config'
JOB_FACTOR="$(grep -i ^JOB_FACTOR .config | cut -f2 -d'=')"

# Find the number of available CPU cores.
NUM_CORES=$(grep ^processor /proc/cpuinfo | wc -l)

# Calculate the number of 'make' jobs to be used later.
NUM_JOBS=$((NUM_CORES * JOB_FACTOR))

cd work/overlay/nano

# Change to the Nano source directory which ls finds, e.g. 'nano-2.6.3'.
cd $(ls -d nano-*)

echo "Preparing Nano work area. This may take a while..."
make clean -j $NUM_JOBS 2>/dev/null

rm -rf ../nano_installed

echo "Configuring Nano..."
./configure \
	--prefix=$SRC_DIR/work/overlay/nano/nano_installed \
	--disable-utf8 \
    CFLAGS="-Os -s -fno-stack-protector -U_FORTIFY_SOURCE"

echo "Building Nano..."
make -j $NUM_JOBS

echo "Installing Nano..."
make install -j $NUM_JOBS

echo "Reducing Nano size..."
strip -g ../nano_installed/bin/* 2>/dev/null

cp -r ../nano_installed/bin $SRC_DIR/work/src/minimal_overlay
echo "Nano has been installed."

# Configure Nano.
echo "set autoindent" >> $SRC_DIR/work/src/overlay/etc/nanorc
echo "set const" >> $SRC_DIR/work/src/overlay/etc/nanorc
echo "set fill 72" >> $SRC_DIR/work/src/overlay/etc/nanorc
echo "set historylog" >> $SRC_DIR/work/src/overlay/etc/nanorc
echo "set multibuffer" >> $SRC_DIR/work/src/overlay/etc/nanorc
echo "set nohelp" >> $SRC_DIR/work/src/overlay/etc/nanorc
echo "set regexp" >> $SRC_DIR/work/src/overlay/etc/nanorc
echo "set smooth" >> $SRC_DIR/work/src/overlay/etc/nanorc
echo "set suspend" >> $SRC_DIR/work/src/overlay/etc/nanorc

cd $SRC_DIR
