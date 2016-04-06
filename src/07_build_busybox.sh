#!/bin/sh

# Find the glibc installation area.
cd work/glibc
cd $(ls -d *)
cd glibc_installed
GLIBC_INSTALLED=$(pwd)
cd ../../../..

cd work/busybox

# Change to the first directory ls finds, e.g. 'busybox-1.24.2'.
cd $(ls -d *)

# Remove previously generated artifacts.
make distclean

# Create default configuration file.
make defconfig

# This variable holds the full path to the glibc installation area as quoted string.
# All back slashes are escaped (/ => \/) in order to keep the 'sed' command stable.
GLIBC_INSTALLED_ESCAPED=$(echo \"$GLIBC_INSTALLED\" | sed 's/\//\\\//g')

# Now we tell BusyBox to use the glibc installation area.
sed -i "s/.*CONFIG_SYSROOT.*/CONFIG_SYSROOT=$GLIBC_INSTALLED_ESCAPED/" .config

# The 'inetd' applet fails to compile because we use the glibc installation area as
# main pointer to the kernel headers (see 05_prepare_glibc.sh) and some headers are
# not resolved. The easiest solution is to ignore this particular applet. 
sed -i "s/.*CONFIG_INETD.*/CONFIG_INETD=n/" .config

# Compile busybox with optimization for "parallel jobs" = "number of processors".
make busybox -j $(grep ^processor /proc/cpuinfo | wc -l)

# Create the symlinks for busybox. The file 'busybox.links' is used for this.
make install

cd ../../..

