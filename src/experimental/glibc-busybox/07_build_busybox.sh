#!/bin/sh

cd work/glibc
cd $(ls -d *)
cd glibc_installed
GLIBC_INSTALLED=$(pwd)

cd ../../../..

cd work/busybox

# Change to the first directory ls finds, e.g. 'busybox-1.23.1'
cd $(ls -d *)

#PATH_BACKUP=$PATH
#PATH=$GLIBC_INSTALLED:$PATH

# Remove previously generated artifacts
make distclean

# Create a default configuration file
make defconfig

# Change the configuration, so that busybox is statically compiled
# You could do this manually with 'make menuconfig'
#
# Uncomment for static build.
#
#sed -i "s/.*CONFIG_STATIC.*/CONFIG_STATIC=y/" .config

GLIBC_INSTALLED_ESCAPED=$(echo \"$GLIBC_INSTALLED\" | sed 's/\//\\\//g')

#echo $GLIBC_INSTALLED_ESCAPED
#exit 0

# Uncomment after some tests
#
sed -i "s/.*CONFIG_SYSROOT.*/CONFIG_SYSROOT=$GLIBC_INSTALLED_ESCAPED/" .config

#exit 0

#sed -i "s/.*CONFIG_CROSS_COMPILER_PREFIX.*/CONFIG_CROSS_COMPILER_PREFIX=\"uclibc-\"/" .config
#sed -i "s/.*CONFIG_IFPLUGD.*/CONFIG_IFPLUGD=n/" .config
sed -i "s/.*CONFIG_INETD.*/CONFIG_INETD=n/" .config
#sed -i "s/.*CONFIG_FEATURE_WTMP.*/CONFIG_FEATURE_WTMP=n/" .config

# Compile busybox with optimization for "parallel jobs" = "number of processors"
make busybox -j $(grep ^processor /proc/cpuinfo | wc -l)

# Create the symlinks for busybox
# It uses the file 'busybox.links' for this
make install

#PATH=$PATH_BACKUP

cd ../../..

