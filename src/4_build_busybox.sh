#!/bin/sh

cd work/busybox

# Change to the first directory ls finds, e.g/ busybox-1.22.1
cd $(ls -d *)

# Clean's the source?
make clean

# Create a default configuration file
make defconfig

# Change the configuration, so that busybox is statically compiled
# You could do this manually with 'make menuconfig'
sed -i "s/.*CONFIG_STATIC.*/CONFIG_STATIC=y/" .config

# Compile busybox
make busybox

# Create the symlinks for busybox
# It uses the file busybox.links for this
make install

cd ../../..
