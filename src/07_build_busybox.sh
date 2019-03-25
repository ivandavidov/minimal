#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** BUILD BUSYBOX BEGIN ***"

# Remove the old Busybox install area.
echo "Removing old Busybox artifacts. This may take a while."
rm -rf $BUSYBOX_INSTALLED

# Change to the source directory ls finds, e.g. 'busybox-1.24.2'.
cd `ls -d $WORK_DIR/busybox/busybox-*`

# Remove previously generated artifacts.
echo "Preparing Busybox work area. This may take a while."
make distclean -j $NUM_JOBS

# Read the 'USE_PREDEFINED_BUSYBOX_CONFIG' property from '.config'
USE_PREDEFINED_BUSYBOX_CONFIG=`read_property USE_PREDEFINED_BUSYBOX_CONFIG`

if [ "$USE_PREDEFINED_BUSYBOX_CONFIG" = "true" -a ! -f $SRC_DIR/minimal_config/busybox.config ] ; then
  echo "Config file $SRC_DIR/minimal_config/busybox.config does not exist."
  USE_PREDEFINED_BUSYBOX_CONFIG="false"
fi

if [ "$USE_PREDEFINED_BUSYBOX_CONFIG" = "true" ] ; then
  # Use predefined configuration file for Busybox.
  echo "Using config file $SRC_DIR/minimal_config/busybox.config"
  cp -f $SRC_DIR/minimal_config/busybox.config .config
else
  # Create default configuration file.
  echo "Generating default Busybox configuration."
  make defconfig -j $NUM_JOBS
fi

# Now we tell Busybox to use the sysroot area.
sed -i "s|.*CONFIG_SYSROOT.*|CONFIG_SYSROOT=\"$SYSROOT\"|" .config

# Configure the compiler flags and explicitly link Busybox with GLIBC from sysroot.
sed -i "s|.*CONFIG_EXTRA_CFLAGS.*|CONFIG_EXTRA_CFLAGS=\"$CFLAGS -L$SYSROOT/lib\"|" .config

# Compile busybox with optimization for "parallel jobs" = "number of processors".
echo "Building Busybox."
make \
  busybox -j $NUM_JOBS

# Create the symlinks for busybox. The file 'busybox.links' is used for this.
echo "Generating Busybox based initramfs area."
make \
  CONFIG_PREFIX="$BUSYBOX_INSTALLED" \
  install -j $NUM_JOBS

cd $SRC_DIR

echo "*** BUILD BUSYBOX END ***"
