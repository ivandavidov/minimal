#!/bin/sh

. $(dirname $(readlink -f $0 2>/dev/null))/.config

# Remove previously generated artefacts
make -C ${SCRIPTDIR}/work/busybox/busybox-${BUSYBOX_VERSION} -j $(grep -c ^processor /proc/cpuinfo) clean

# Create a default configuration file
make -C ${SCRIPTDIR}/work/busybox/busybox-${BUSYBOX_VERSION} -j $(grep -c ^processor /proc/cpuinfo) defconfig

# Change the configuration, so that busybox is statically compiled
# You could do this manually with 'make menuconfig'
sed -i "s/.*CONFIG_STATIC.*/CONFIG_STATIC=y/" "${SCRIPTDIR}/work/busybox/busybox-${BUSYBOX_VERSION}/.config"

# Busybox has "RPC networking" enabled in default configuration file.
# In glibc > 2.14 such support was removed by default.
# http://lists.busybox.net/pipermail/buildroot/2012-June/055173.html
# It causes failures on glibc toolchains without RPC support.
sed -i 's/.*CONFIG_FEATURE_HAVE_RPC.*/CONFIG_FEATURE_HAVE_RPC=n/' "${SCRIPTDIR}/work/busybox/busybox-${BUSYBOX_VERSION}/.config"
sed -i 's/.*CONFIG_FEATURE_INETD_RPC.*/CONFIG_FEATURE_INETD_RPC=n/' "${SCRIPTDIR}/work/busybox/busybox-${BUSYBOX_VERSION}/.config"

# Compile busybox with optimization for "parallel jobs" = "number of processors"
make -C ${SCRIPTDIR}/work/busybox/busybox-${BUSYBOX_VERSION} -j $(grep -c ^processor /proc/cpuinfo) busybox 

# Create the symlinks for busybox
# It uses the file 'busybox.links' for this
make -C ${SCRIPTDIR}/work/busybox/busybox-${BUSYBOX_VERSION} -j $(grep -c ^processor /proc/cpuinfo) install
