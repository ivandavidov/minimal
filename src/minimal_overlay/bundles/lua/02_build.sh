#!/bin/sh

# TODO: compile the gnu readline library for line editing support

SRC_DIR=$(pwd)

# Find the main source directory
cd ../../..
MAIN_SRC_DIR=$(pwd)
cd $SRC_DIR

# Read the 'JOB_FACTOR' property from '.config'
JOB_FACTOR="$(grep -i ^JOB_FACTOR $MAIN_SRC_DIR/.config | cut -f2 -d'=')"

# Read the 'CFLAGS' property from '.config'
CFLAGS="$(grep -i ^CFLAGS $MAIN_SRC_DIR/.config | cut -f2 -d'=')"

# Find the number of available CPU cores.
NUM_CORES=$(grep ^processor /proc/cpuinfo | wc -l)

# Calculate the number of 'make' jobs to be used later.
NUM_JOBS=$((NUM_CORES * JOB_FACTOR))

cd $MAIN_SRC_DIR/work/overlay/lua

# Change to the Lua source directory which ls finds, e.g. 'lua-5.3.4'.
cd $(ls -d lua-*)

echo "Preparing Lua work area. This may take a while..."
make clean -j $NUM_JOBS 2>/dev/null
rm -rf ../lua_installed

echo "Building Lua..."
make generic -j $NUM_JOBS CFLAGS="$CFLAGS --sysroot=$MAIN_SRC_DIR/work/glibc/glibc_prepared/"

make install -j $NUM_JOBS INSTALL_TOP=../../lua_installed/usr/local

echo "Reducing Lua size..."
strip -g ../lua_installed/usr/local/bin/* 2>/dev/null

mkdir -p $MAIN_SRC_DIR/work/src/minimal_overlay/rootfs/usr/local
cp -r ../lua_installed/usr/local/* $MAIN_SRC_DIR/work/src/minimal_overlay/rootfs/usr/local

echo "Lua has been installed."
echo "*******************************************************************************"
echo "*** NOTE:                                                                   ***"
echo "*** lua currently depends on glibc to be present for dynamic linking        ***"
echo "*** So make sure to build and include glibc_full                            ***"
echo "*******************************************************************************"

cd $SRC_DIR
