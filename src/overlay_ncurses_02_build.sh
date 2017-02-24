#!/bin/sh

SRC_DIR=$(pwd)

# Read the 'JOB_FACTOR' property from '.config'
JOB_FACTOR="$(grep -i ^JOB_FACTOR .config | cut -f2 -d'=')"

# Find the number of available CPU cores.
NUM_CORES=$(grep ^processor /proc/cpuinfo | wc -l)

# Calculate the number of 'make' jobs to be used later.
NUM_JOBS=$((NUM_CORES * JOB_FACTOR))

cd work/overlay/ncurses

# Change to the Links source directory which ls finds, e.g. 'ncurses-6.0'.
cd $(ls -d ncurses-*)

echo "Preparing Ncurses work area. This may take a while..."
make clean -j $NUM_JOBS 2>/dev/null

# Configure Ncurses to not make libraries it can't support.
sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in

rm -rf ../ncurses_installed

echo "Configuring Links..."
./configure \
    --prefix=$SRC_DIR/work/overlay/ncurses/ncurses_installed \
    --with-termlib \
    --with-shared \
    --with-terminfo-dirs=/lib/terminfo \
    --with-default-terminfo-dirs=/lib/terminfo \
    --without-normal \
    --without-debug \
    --without-cxx-binding \
    --with-abi-version=5 \
    CFLAGS="-Os -s -fno-stack-protector -U_FORTIFY_SOURCE" \
    CPPFLAGS="-P"

echo "Building Ncurses..."
make -j $NUM_JOBS

echo "Installing Ncurses..."
make install -j $NUM_JOBS

echo "Reducing Ncurses size..."
strip -g ../ncurses_installed/bin/* 2>/dev/null
strip -g ../ncurses_installed/lib/* 2>/dev/null
strip -g ../ncurses_installed/share/* 2>/dev/null

cp -r ../ncurses_installed/bin $SRC_DIR/work/src/minimal_overlay
cp -r ../ncurses_installed/lib $SRC_DIR/work/src/minimal_overlay
cp -r ../ncurses_installed/share $SRC_DIR/work/src/minimal_overlay
echo "Ncurses has been installed."

cd $SRC_DIR
