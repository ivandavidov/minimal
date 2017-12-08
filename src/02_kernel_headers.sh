#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** KERNEL HEADERS BEGIN ***"

# Prepare the kernel install area.
echo "Removing old kernel artifacts. This may take a while."
rm -rf $KERNEL_INSTALLED/include
mkdir -p $KERNEL_INSTALLED/include

# Change to the kernel source directory which ls finds, e.g. 'linux-4.4.6'.
cd `ls -d $WORK_DIR/kernel/linux-*`

# Install kernel headers which are used later when we build and configure the
# GNU C library (glibc).
echo "Generating kernel headers."
make \
  INSTALL_HDR_PATH=$KERNEL_INSTALLED \
  headers_install -j $NUM_JOBS

cd $SRC_DIR

echo "*** KERNEL HEADERS END ***"
