#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** BUILD KERNEL BEGIN ***"

# Change to the kernel source directory which ls finds, e.g. 'linux-4.4.6'.
cd `ls -d $WORK_DIR/kernel/linux-*`

# Compile the kernel with optimization for 'parallel jobs' = 'number of processors'.
# Good explanation of the different kernels:
# http://unix.stackexchange.com/questions/5518/what-is-the-difference-between-the-following-kernel-makefile-terms-vmlinux-vmlinux
echo "Building kernel."
make \
  CFLAGS="$CFLAGS" \
  bzImage -j $NUM_JOBS

# Prepare the kernel install area.
echo "Removing old kernel artifacts. This may take a while."
rm -rf $KERNEL_INSTALLED/kernel
mkdir -p $KERNEL_INSTALLED

# Install the kernel file.
cp arch/x86/boot/bzImage \
  $KERNEL_INSTALLED/kernel

cd $SRC_DIR

echo "*** BUILD KERNEL END ***"
