#!/bin/sh

if [ -z "$BASE_DIR" ]; then
	BASE_DIR="`pwd`"
fi

. $BASE_DIR/.vars

# Enter the busybox directory regardless of the version
cd $BUSYBOX_DIR

# Remove previously generated artefacts
make clean

# Create a default configuration file
make defconfig

# Change the configuration, so that busybox is statically compiled
# You could do this manually with 'make menuconfig'
sed -i "s/.*CONFIG_STATIC.*/CONFIG_STATIC=y/" .config
# Busybox has "RPC networking" enabled in default configuration file.
# In glibc > 2.14 such support was removed by default.
# http://lists.busybox.net/pipermail/buildroot/2012-June/055173.html
# It causes to failures on glibc toolchains without RPC support.
sed -e 's/.*CONFIG_FEATURE_HAVE_RPC.*/CONFIG_FEATURE_HAVE_RPC=n/' -i .config
sed -e 's/.*CONFIG_FEATURE_INETD_RPC.*/CONFIG_FEATURE_INETD_RPC=n/' -i .config

# Compile busybox
# TODO - Suggested by Ronny Kalusniok - test this for parallel compilation: "make busybox -j $(grep ^processor /proc/cpuinfo)".
make busybox

# Create the symlinks for busybox
# It uses the file 'busybox.links' for this
make install

cd $BASE_DIR

