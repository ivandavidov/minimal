#!/bin/sh

echo "*** BUILD BUSYBOX BEGIN ***"

SRC_DIR=$(pwd)

# Read the 'JOB_FACTOR' property from '.config'
JOB_FACTOR="$(grep -i ^JOB_FACTOR .config | cut -f2 -d'=')"

# Find the number of available CPU cores.
NUM_CORES=$(grep ^processor /proc/cpuinfo | wc -l)

# Calculate the number of 'make' jobs to be used later.
NUM_JOBS=$((NUM_CORES * JOB_FACTOR))

# Remember the sysroot
SYSROOT=$(pwd)/work/sysroot

cd work/busybox

# Remove the old BusyBox install area
rm -rf busybox_installed

# Change to the source directory ls finds, e.g. 'busybox-1.24.2'.
cd $(ls -d busybox-*)

# Remove previously generated artifacts.
echo "Preparing BusyBox work area. This may take a while..."
make distclean -j $NUM_JOBS

# Read the 'USE_PREDEFINED_BUSYBOX_CONFIG' property from '.config'
USE_PREDEFINED_BUSYBOX_CONFIG="$(grep -i ^USE_PREDEFINED_BUSYBOX_CONFIG $SRC_DIR/.config | cut -f2 -d'=')"

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
  echo "Generating default BusyBox configuration..."  
  make defconfig -j $NUM_JOBS
  
  # The 'inetd' applet fails to compile because we use the glibc installation area as
  # main pointer to the kernel headers (see 05_prepare_glibc.sh) and some headers are
  # not resolved. The easiest solution is to ignore this particular applet. 
  sed -i "s/.*CONFIG_INETD.*/CONFIG_INETD=n/" .config
fi

# This variable holds the full path to the glibc installation area as quoted string.
# All back slashes are escaped (/ => \/) in order to keep the 'sed' command stable.
SYSROOT_ESCAPED=$(echo \"$SYSROOT\" | sed 's/\//\\\//g')

# Now we tell BusyBox to use the glibc prepared area.
sed -i "s/.*CONFIG_SYSROOT.*/CONFIG_SYSROOT=$SYSROOT_ESCAPED/" .config

# Read the 'CFLAGS' property from '.config'
CFLAGS="$(grep -i ^CFLAGS .config | cut -f2 -d'=')"

# Compile busybox with optimization for "parallel jobs" = "number of processors".
echo "Building BusyBox..."
make \
  EXTRA_CFLAGS="$CFLAGS" \
  busybox -j $NUM_JOBS

# Create the symlinks for busybox. The file 'busybox.links' is used for this.
echo "Generating BusyBox based initramfs area..."
make \
  CONFIG_PREFIX="../busybox_installed" \
  install -j $NUM_JOBS

cd $SRC_DIR

echo "*** BUILD BUSYBOX END ***"

