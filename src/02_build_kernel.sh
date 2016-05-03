#!/bin/sh

SRC_DIR=$(pwd)

cd work/kernel

# Change to the kernel source directory which ls finds, e.g. 'linux-4.4.6'.
cd $(ls -d linux-*)

# Cleans up the kernel sources, including configuration files.
echo "Preparing kernel work area..."
make mrproper

# Read the 'USE_PREDEFINED_KERNEL_CONFIG' property from '.config'
USE_PREDEFINED_KERNEL_CONFIG="$(grep -i USE_PREDEFINED_KERNEL_CONFIG $SRC_DIR/.config | cut -f2 -d'=')"

if [ "$USE_PREDEFINED_KERNEL_CONFIG" = "true" -a ! -f $SRC_DIR/config_predefined/kernel.config ] ; then
  echo "Config file $SRC_DIR/config_predefined/kernel.config does not exist."
  USE_PREDEFINED_KERNEL_CONFIG="false"
fi

if [ "$USE_PREDEFINED_KERNEL_CONFIG" = "true" ] ; then
  # Use predefined configuration file for the kernel.
  echo "Using config file $SRC_DIR/config_predefined/kernel.config"  
  cp -f $SRC_DIR/config_predefined/kernel.config .config
else
  # Create default configuration file for the kernel.
  make defconfig
  echo "Generated default kernel configuration."

  # Changes the name of the system to 'minimal'.
  sed -i "s/.*CONFIG_DEFAULT_HOSTNAME.*/CONFIG_DEFAULT_HOSTNAME=\"minimal\"/" .config

  # Enable overlay support, e.g. merge ro and rw directories.
  sed -i "s/.*CONFIG_OVERLAY_FS.*/CONFIG_OVERLAY_FS=y/" .config
  
  # Step 1 - disable all active kernel compression options (should be only one).
  sed -i "s/.*\\(CONFIG_KERNEL_.*\\)=y/\\#\\ \\1 is not set/" .config  
  
  # Step 2 - enable the 'xz' compression option.
  sed -i "s/.*CONFIG_KERNEL_XZ.*/CONFIG_KERNEL_XZ=y/" .config
fi

# Compile the kernel with optimization for 'parallel jobs' = 'number of processors'.
# Good explanation of the different kernels:
# http://unix.stackexchange.com/questions/5518/what-is-the-difference-between-the-following-kernel-makefile-terms-vmlinux-vmlinux
echo "Building kernel..."
make \
  CFLAGS="-Os -s -fno-stack-protector -U_FORTIFY_SOURCE" \
  bzImage -j $(grep ^processor /proc/cpuinfo | wc -l)

# Install kernel headers in './usr' (this is not '/usr') which are used later
# when we build and configure the GNU C library (glibc).
echo "Generating kernel headers..."
make headers_install

cd ../../..

