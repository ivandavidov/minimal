#!/bin/sh

cd work/musl
cd $(ls -d *)
cd musl-installed
cd bin
MUSL_BIN_DIR=$(pwd)
cd ../../../../..

cd work/busybox

# Change to the first directory ls finds, e.g. 'busybox-1.23.1'
cd $(ls -d *)

PATH_BACKUP=$PATH
PATH=$MUSL_BIN_DIR:$PATH

# Remove previously generated artifacts
make distclean

# Create a default configuration file
make defconfig

# Change the configuration, so that busybox is statically compiled
# You could do this manually with 'make menuconfig'
sed -i "s/.*CONFIG_STATIC.*/CONFIG_STATIC=y/" .config
sed -i "s/.*CONFIG_CROSS_COMPILER_PREFIX.*/CONFIG_CROSS_COMPILER_PREFIX=\"musl-\"/" .config
sed -i "s/.*CONFIG_IFPLUGD.*/CONFIG_IFPLUGD=n/" .config
sed -i "s/.*CONFIG_INETD.*/CONFIG_INETD=n/" .config

# Compile busybox with optimization for "parallel jobs" = "number of processors"
make busybox -j $(grep ^processor /proc/cpuinfo | wc -l)

# Create the symlinks for busybox
# It uses the file 'busybox.links' for this
make install

PATH=$PATH_BACKUP

cd ../../..

