#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** CLEAN KERNEL BEGIN ***"

# Change to the kernel source directory which ls finds, e.g. 'linux-4.4.6'.
cd `ls -d $WORK_DIR/kernel/linux-*`

# Cleans up the kernel sources, including configuration files.
echo "Preparing kernel work area."
make mrproper -j $NUM_JOBS

cd $SRC_DIR

echo "*** CLEAN KERNEL END ***"
