#!/bin/sh

SRC_DIR=$(pwd)

cd work/kernel

# Change to the first directory ls finds, e.g. 'linux-4.4.6'.
cd $(ls -d *)

# Cleans up the kernel sources, including configuration files.
make mrproper

# Read the 'KERNEL_CONFIG_FILE' property from '.config'
KERNEL_CONFIG_FILE="$SRC_DIR/$(grep -i KERNEL_CONFIG_FILE $SRC_DIR/.config | cut -f2 -d'=')"

if [ -f $KERNEL_CONFIG_FILE ] ; then
  # Use predefined configuration file for the kernel.
  cp $KERNEL_CONFIG_FILE .config
else
  # Create default configuration file for the kernel.
  make defconfig

  # Changes the name of the system to 'minimal'.
  sed -i "s/.*CONFIG_DEFAULT_HOSTNAME.*/CONFIG_DEFAULT_HOSTNAME=\"minimal\"/" .config

  # Enable overlay support, e.g. merge ro and rw directories.
  sed -i "s/.*CONFIG_OVERLAY_FS.*/CONFIG_OVERLAY_FS=y/" .config
fi

# Compile the kernel with optimization for 'parallel jobs' = 'number of processors'.
# Good explanation of the different kernels:
# http://unix.stackexchange.com/questions/5518/what-is-the-difference-between-the-following-kernel-makefile-terms-vmlinux-vmlinux
make bzImage -j $(grep ^processor /proc/cpuinfo | wc -l)

# Install kernel headers in './usr' (this is not '/usr') which are used later
# when we build and configure the GNU C library (glibc).
make headers_install

cd ../../..

