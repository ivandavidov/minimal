#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** CONFIG KERNEL BEGIN ***"

# Change to the kernel source directory which ls finds, e.g. 'linux-4.4.6'.
cd `ls -d $WORK_DIR/kernel/linux-*`

# Delete old kernel configuration file.
rm -f .config

# Read the 'USE_PREDEFINED_KERNEL_CONFIG' property from '.config'
USE_PREDEFINED_KERNEL_CONFIG=`read_property USE_PREDEFINED_KERNEL_CONFIG`

if [ "$USE_PREDEFINED_KERNEL_CONFIG" = "true" -a ! -f $SRC_DIR/minimal_config/kernel.config ] ; then
  echo "Config file '$SRC_DIR/minimal_config/kernel.config' does not exist."
  USE_PREDEFINED_KERNEL_CONFIG=false
fi

if [ "$USE_PREDEFINED_KERNEL_CONFIG" = "true" ] ; then
  # Use predefined configuration file for the kernel.
  echo "Using config file '$SRC_DIR/minimal_config/kernel.config'."
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

  # Disable debug symbols in kernel => smaller kernel binary.
  sed -i "s/^CONFIG_DEBUG_KERNEL.*/\\# CONFIG_DEBUG_KERNEL is not set/" .config

  # Disable Apple Properties (Useful for Macs but useless in general)
  echo "CONFIG_APPLE_PROPERTIES=n" >> .config

  # Read the 'USE_BOOT_LOGO' property from '.config'
  USE_BOOT_LOGO=`read_property USE_BOOT_LOGO`
  if [ "$USE_BOOT_LOGO" = "true" ] ; then
    sed -i "s/.*CONFIG_LOGO_LINUX_CLUT224.*/CONFIG_LOGO_LINUX_CLUT224=y/" .config
    echo "Boot logo is enabled."
  else
    sed -i "s/.*CONFIG_LOGO_LINUX_CLUT224.*/\\# CONFIG_LOGO_LINUX_CLUT224 is not set/" .config
    echo "Boot logo is disabled."
  fi

  # Read the 'FORCE_UEFI' property from '.config'
  FORCE_UEFI=`read_property FORCE_UEFI`
  if [ "$FORCE_UEFI" = "true" ] ; then
    # Enable the EFI stub
    sed -i "s/.*CONFIG_EFI_STUB.*/CONFIG_EFI_STUB=y/" .config

    # Request that the firmware clear the contents of RAM after reboot (4.14+).
    echo "CONFIG_RESET_ATTACK_MITIGATION=y" >> .config

    # Check if we are building 64-bit kernel.
    if [ "`grep "CONFIG_X86_64=y" .config`" = "CONFIG_X86_64=y" ] ; then
      # Enable the mixed EFI mode when building 64-bit kernel.
      echo "CONFIG_EFI_MIXED=y" >> .config
    fi
    
    # Embed the initramfs in the kernel
    sed -i "s|.*CONFIG_INITRAMFS_SOURCE.*|CONFIG_INITRAMFS_SOURCE=\"$WORK_DIR/rootfs.cpio\"|" .config
    
    # Set initramfs default UID/GID for 'root'.
    echo "CONFIG_INITRAMFS_ROOT_UID=0" >> .config
    echo "CONFIG_INITRAMFS_ROOT_GID=0" >> .config
  
    echo "UEFI kernel features are enabled."
  else
    echo "UEFI features are disabled."
  fi
fi

cd $SRC_DIR

echo "*** CONFIG KERNEL END ***"
