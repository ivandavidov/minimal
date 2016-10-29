#!/bin/sh

echo "*** BUILD KERNEL BEGIN ***"

SRC_DIR=$(pwd)

# Read the 'JOB_FACTOR' property from '.config'
JOB_FACTOR="$(grep -i ^JOB_FACTOR .config | cut -f2 -d'=')"

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

yconfig() { # yes configs
while [ $# -ne 0 ]; do
  sed -i "s/.*CONFIG_$1\ .*/CONFIG_$1=y/" .config
  grep ^"CONFIG_$1=y" .config || echo "CONFIG_$1=y" >> .config
  shift 1
done
}

nconfig() { # no configs
while [ $# -ne 0 ]; do
  sed -i "s/.*CONFIG_$1\ .*/CONFIG_$1/" .config
  grep ^"# CONFIG_$1 is not set" .config || echo "# CONFIG_$1 is not set" >> .config
  shift 1
done
}


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

  # Enable overlay support, e.g. merge ro and rw directories.
  sed -i "s/.*CONFIG_OVERLAY_FS.*/CONFIG_OVERLAY_FS=y/" .config
  
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

  # Check if we are building 32-bit kernel. The exit code is '1' when we are
  # building 64-bit kernel, otherwise the exit code is '0'.
  grep -q "CONFIG_X86_32=y" .config

  # The '$?' variable holds the exit code of the last issued command.
  if [ $? = 1 ] ; then
    # Enable the mixed EFI mode when building 64-bit kernel.
    echo "CONFIG_EFI_MIXED=y" >> .config
  fi

  # MINCS configuration BEGIN

  # Config for Virtio environment
  echo "CONFIG_VIRTIO=y" >> .config
  echo "CONFIG_VIRTIO_PCI=y" >> .config
  echo "CONFIG_VIRTIO_MMIO=y" >> .config
  echo "CONFIG_VIRTIO_CONSOLE=y" >> .config
  echo "CONFIG_VIRTIO_BLK=y" >> .config
  echo "CONFIG_VIRTIO_NET=y" >> .config
  
  # Config adding Realtek NIC
  echo "CONFIG_8139TOO=y" >> .config
  echo "CONFIG_8139CP=y" >> .config

  sed -i "s/.*CONFIG_SQUASHFS\ .*/CONFIG_SQUASHFS=y/" .config

  yconfig CGROUPS EVENTFD CGROUP_DEVICE CPUSETS CGROUP_CPUACCT \
          PAGE_COUNTER MEMCG MEMCG_SWAP MEMCG_SWAP_ENABLED \
          CGROUP_PERF CGROUP_SCHED CGROUP_HUGETLB FAIR_GROUP_SCHED \
          CFS_BANDWIDTH RT_GROUP_SCHED BLK_CGROUP VIRTIO_PCI_LEGACY \
          SQUASHFS_FILE_CACHE SQUASHFS_DECOMP_SINGLE SQUASHFS_ZLIB \
          

  nconfig DEBUG_BLK_CGROUP BLK_DEV_THROTTLING CFQ_GROUP_IOSCHED \
          HW_RANDOM_VIRTIO DRM_VIRTIO_GPU VIRTIO_BALLOON VIRTIO_INPUT \
          VIRTIO_MMIO_CMDLINE_DEVICES SQUASHFS_XATTR SQUASHFS_LZ4 \
          SQUASHFS_LZO SQUASHFS_XZ SQUASHFS_4K_DEVBLK_SIZE \
          SQUASHFS_EMBEDDED SQUASHFS_FILE_DIRECT SQUASHFS_DECOMP_MULTI \
          SQUASHFS_DECOMP_MULTI_PERCPU

  # MINCS configuration END
fi

# Compile the kernel with optimization for 'parallel jobs' = 'number of processors'.
# Good explanation of the different kernels:
# http://unix.stackexchange.com/questions/5518/what-is-the-difference-between-the-following-kernel-makefile-terms-vmlinux-vmlinux
echo "Building kernel..."
make \
  CFLAGS="-Os -s -fno-stack-protector -U_FORTIFY_SOURCE" \
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

