#!/bin/sh

cd work/musl
cd $(ls -d *)
cd musl-installed
cd bin
MUSL_BIN_DIR=$(pwd)
cd ../../../../..
cd work/toybox

# Change to the first directory ls finds, e.g. 'toybox-0.6.0'
cd $(ls -d *)

PATH_BACKUP=$PATH
PATH=$MUSL_BIN_DIR:$PATH

# Remove previously generated artefacts.
make distclean

# Create a configuration file with all possible selections.
#make allyesconfig
make defconfig

sed -i "s/.*CONFIG_DHCP.is.*/CONFIG_DHCP=y/" .config

# Static linking and cross compiling.
export CFLAGS="-std=c99"
export LDFLAGS="--static"
export CROSS_COMPILE="musl-"

# Compile ToyBox with optimization for "parallel jobs" = "number of processors".
make toybox -j $(grep ^processor /proc/cpuinfo | wc -l)

# We no longer need flags for static linking and cross compiling.
unset CFLAGS
unset LDFLAGS
unset CROSS_COMPILE

rm -rf rootfs
mkdir rootfs

# Directory where ToyBox binary and symlink will be instaled.
export PREFIX=rootfs

# Create the symlinks for toybox in single folder.
make install_flat

# We no longer need this environment variable.
unset PREFIX

PATH=$PATH_BACKUP

cd ../../..

