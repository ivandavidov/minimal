#!/bin/sh

echo "*** BUILD KERNEL BEGIN ***"

SRC_DIR=$(pwd)

# Read the 'JOB_FACTOR' property from '.config'
JOB_FACTOR="$(grep -i ^JOB_FACTOR .config | cut -f2 -d'=')"

# Read the 'CFLAGS' property from '.config'
CFLAGS="$(grep -i ^CFLAGS .config | cut -f2 -d'=')"

# Find the number of available CPU cores.
NUM_CORES=$(grep ^processor /proc/cpuinfo | wc -l)

# Calculate the number of 'make' jobs to be used later.
NUM_JOBS=$((NUM_CORES * JOB_FACTOR))

cd work/kernel

# Prepare the kernel install area.
rm -rf kernel_installed
mkdir kernel_installed

# Change to the kernel source directory which ls finds, e.g. 'linux-4.4.6'.
cd $(ls -d linux-*)

# Cleans up the kernel sources, including configuration files.
echo "Preparing kernel work area..."
make mrproper -j $NUM_JOBS

# Read the 'USE_PREDEFINED_KERNEL_CONFIG' property from '.config'
USE_PREDEFINED_KERNEL_CONFIG="$(grep -i ^USE_PREDEFINED_KERNEL_CONFIG $SRC_DIR/.config | cut -f2 -d'=')"

if [ "$USE_PREDEFINED_KERNEL_CONFIG" = "true" -a ! -f $SRC_DIR/minimal_config/kernel.config ] ; then
  echo "Config file $SRC_DIR/minimal_config/kernel.config does not exist."
  USE_PREDEFINED_KERNEL_CONFIG="false"
fi

if [ "$USE_PREDEFINED_KERNEL_CONFIG" = "true" ] ; then
  # Use predefined configuration file for the kernel.
  echo "Using config file $SRC_DIR/minimal_config/kernel.config"  
  cp -f $SRC_DIR/minimal_config/kernel.config .config
else
  # Create default configuration file for the kernel.
  make defconfig -j $NUM_JOBS
  echo "Generated default kernel configuration."

  # Changes the name of the system to 'minimal'.
  sed -i "s/.*CONFIG_DEFAULT_HOSTNAME.*/CONFIG_DEFAULT_HOSTNAME=\"minimal\"/" .config

  # Enable overlay support, e.g. merge ro and rw directories (3.18+).
  sed -i "s/.*CONFIG_OVERLAY_FS.*/CONFIG_OVERLAY_FS=y/" .config
  
  # Enable overlayfs redirection (4.10+).
  echo "CONFIG_OVERLAY_FS_REDIRECT_DIR=y" >> .config

  # Turn on inodes index feature by default (4.13+).
  echo "CONFIG_OVERLAY_FS_INDEX=y" >> .config
  
  # Step 1 - disable all active kernel compression options (should be only one).
  sed -i "s/.*\\(CONFIG_KERNEL_.*\\)=y/\\#\\ \\1 is not set/" .config  
  
  # Step 2 - enable the 'xz' compression option.
  sed -i "s/.*CONFIG_KERNEL_XZ.*/CONFIG_KERNEL_XZ=y/" .config

  # Enable the VESA framebuffer for graphics support.
  sed -i "s/.*CONFIG_FB_VESA.*/CONFIG_FB_VESA=y/" .config

  # Read the 'USE_BOOT_LOGO' property from '.config'
  USE_BOOT_LOGO="$(grep -i ^USE_BOOT_LOGO $SRC_DIR/.config | cut -f2 -d'=')"

  if [ "$USE_BOOT_LOGO" = "true" ] ; then
    sed -i "s/.*CONFIG_LOGO_LINUX_CLUT224.*/CONFIG_LOGO_LINUX_CLUT224=y/" .config
    echo "Boot logo is enabled."
  else
    sed -i "s/.*CONFIG_LOGO_LINUX_CLUT224.*/\\# CONFIG_LOGO_LINUX_CLUT224 is not set/" .config
    echo "Boot logo is disabled."
  fi
  
  # Disable debug symbols in kernel => smaller kernel binary.
  sed -i "s/^CONFIG_DEBUG_KERNEL.*/\\# CONFIG_DEBUG_KERNEL is not set/" .config

  # Enable the EFI stub
  sed -i "s/.*CONFIG_EFI_STUB.*/CONFIG_EFI_STUB=y/" .config
  
  # Disable Apple Properties (Useful for Macs but useless in general)
  echo "CONFIG_APPLE_PROPERTIES=n" >> .config

  # Check if we are building 32-bit kernel. The exit code is '1' when we are
  # building 64-bit kernel, otherwise the exit code is '0'.
  grep -q "CONFIG_X86_32=y" .config

  # The '$?' variable holds the exit code of the last issued command.
  if [ $? = 1 ] ; then
    # Enable the mixed EFI mode when building 64-bit kernel.
    echo "CONFIG_EFI_MIXED=y" >> .config
  fi
fi

# Compile the kernel with optimization for 'parallel jobs' = 'number of processors'.
# Good explanation of the different kernels:
# http://unix.stackexchange.com/questions/5518/what-is-the-difference-between-the-following-kernel-makefile-terms-vmlinux-vmlinux
echo "Building kernel..."
make \
  CFLAGS="$CFLAGS" \
  bzImage -j $NUM_JOBS

# Install the kernel file.
cp arch/x86/boot/bzImage \
  $SRC_DIR/work/kernel/kernel_installed/kernel

# Install kernel headers which are used later when we build and configure the
# GNU C library (glibc).
echo "Generating kernel headers..."
make \
  INSTALL_HDR_PATH=$SRC_DIR/work/kernel/kernel_installed \
  headers_install -j $NUM_JOBS

cd $SRC_DIR

echo "*** BUILD KERNEL END ***"

