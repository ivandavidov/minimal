#!/bin/sh

. ./.config

# Remove previously generated artefacts
make -C ${SCRIPTDIR}/work/busybox/busybox-${BUSYBOX_VERSION} clean

# Create a default configuration file
make ${SCRIPTDIR}/work/busybox/busybox-${BUSYBOX_VERSION} defconfig

# Change the configuration, so that busybox is statically compiled
# You could do this manually with 'make menuconfig'
sed -i "s/.*CONFIG_STATIC.*/CONFIG_STATIC=y/" .config

# Busybox has "RPC networking" enabled in default configuration file.
# In glibc > 2.14 such support was removed by default.
# http://lists.busybox.net/pipermail/buildroot/2012-June/055173.html
# It causes failures on glibc toolchains without RPC support.
sed -e 's/.*CONFIG_FEATURE_HAVE_RPC.*/CONFIG_FEATURE_HAVE_RPC=n/' -i .config
sed -e 's/.*CONFIG_FEATURE_INETD_RPC.*/CONFIG_FEATURE_INETD_RPC=n/' -i .config

# Compile busybox with optimization for "parallel jobs" = "number of processors"
make busybox -j $(grep -c ^processor /proc/cpuinfo)

# Create the symlinks for busybox
# It uses the file 'busybox.links' for this
make ${SCRIPTDIR}/work/busybox/busybox-${BUSYBOX_VERSION} install
