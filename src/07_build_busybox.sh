#!/bin/sh

SRC_DIR=$(pwd)

# Remember the glibc installation area.
GLIBC_PREPARED=$(pwd)/work/glibc/glibc_prepared

cd work/busybox

# Remove the old BusyBox install area
rm -rf busybox_installed

# Change to the source directory ls finds, e.g. 'busybox-1.24.2'.
cd $(ls -d busybox-*)

# Remove previously generated artifacts.
echo "Preparing BusyBox work area. This may take a while..."
make distclean

# Read the 'USE_PREDEFINED_BUSYBOX_CONFIG' property from '.config'
USE_PREDEFINED_BUSYBOX_CONFIG="$(grep -i USE_PREDEFINED_BUSYBOX_CONFIG $SRC_DIR/.config | cut -f2 -d'=')"

if [ "$USE_PREDEFINED_BUSYBOX_CONFIG" = "true" -a ! -f $SRC_DIR/config_predefined/busybox.config ] ; then
  echo "Config file $SRC_DIR/config_predefined/busybox.config does not exist."
  USE_PREDEFINED_BUSYBOX_CONFIG="false"
fi

if [ "$USE_PREDEFINED_BUSYBOX_CONFIG" = "true" ] ; then
  # Use predefined configuration file for Busybox.
  echo "Using config file $SRC_DIR/config_predefined/busybox.config"  
  cp -f $SRC_DIR/config_predefined/busybox.config .config
else
  # Create default configuration file.
  echo "Generating default BusyBox configuration..."  
  make defconfig
  
  # Set the installation folder for BusyBox.
  #sed -i "s/.*CONFIG_PREFIX.*/CONFIG_PREFIX=\"..\/busybox_installed\"/" .config  
  
  # The 'inetd' applet fails to compile because we use the glibc installation area as
  # main pointer to the kernel headers (see 05_prepare_glibc.sh) and some headers are
  # not resolved. The easiest solution is to ignore this particular applet. 
  sed -i "s/.*CONFIG_INETD.*/CONFIG_INETD=n/" .config
fi

# This variable holds the full path to the glibc installation area as quoted string.
# All back slashes are escaped (/ => \/) in order to keep the 'sed' command stable.
GLIBC_PREPARED_ESCAPED=$(echo \"$GLIBC_PREPARED\" | sed 's/\//\\\//g')

# Now we tell BusyBox to use the glibc installation area.
sed -i "s/.*CONFIG_SYSROOT.*/CONFIG_SYSROOT=$GLIBC_PREPARED_ESCAPED/" .config

# Compile busybox with optimization for "parallel jobs" = "number of processors".
echo "Building BusyBox..."
make \
  EXTRA_CFLAGS="-Os -s -fno-stack-protector -U_FORTIFY_SOURCE" \
  busybox -j $(grep ^processor /proc/cpuinfo | wc -l)

# Create the symlinks for busybox. The file 'busybox.links' is used for this.
echo "Generating BusyBox based initramfs area..."
make CONFIG_PREFIX="../busybox_installed" install

cd ../../..

