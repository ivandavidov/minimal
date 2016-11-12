#!/bin/sh

echo "*** BUILD KERNEL FIRMWARE BEGIN ***"

SRC_DIR=$(pwd)

# Read the 'JOB_FACTOR' property from '.config'
JOB_FACTOR="$(grep -i ^JOB_FACTOR .config | cut -f2 -d'=')"

# Find the number of available CPU cores.
NUM_CORES=$(grep ^processor /proc/cpuinfo | wc -l)

# Calculate the number of 'make' jobs to be used later.
NUM_JOBS=$((NUM_CORES * JOB_FACTOR))

cd work/kernel

# Change to the kernel source directory which ls finds, e.g. 'linux-4.4.6'.
cd $(ls -d linux-*)

# Install kernel firmware.
echo "Generating kernel firmware..."
make \
  INSTALL_FW_PATH=$SRC_DIR/work/kernel/kernel_installed/lib/firmware \
  firmware_install -j $NUM_JOBS

cd $SRC_DIR

echo "*** BUILD KERNEL FIRMWARE END ***"

