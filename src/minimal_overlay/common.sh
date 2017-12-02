#!/bin/sh

set -e

# common code used by all bundles
# should be included at the top of every *.sh file of each bundle

export MAIN_SRC_DIR=`realpath --no-symlinks $PWD/../../../`
export WORK_DIR=$MAIN_SRC_DIR/work
export SRC_DIR=`realpath --no-symlinks $PWD`
export OVERLAY_ROOTFS=$WORK_DIR/overlay_rootfs
export BUNDLE_NAME=`basename $SRC_DIR`
export DEST_DIR=$WORK_DIR/overlay/$BUNDLE_NAME/${BUNDLE_NAME}_installed
export CONFIG=$MAIN_SRC_DIR/.config
export SYSROOT=$WORK_DIR/sysroot
#export SYSROOT_SPECS=$WORK_DIR/sysroot.specs

# This function reads property from the main '.config' file.
# If there is local '.config' file in the current directory
# the property value is overridden with the value found in
# the local '.config' file, if the property is present there.
#
# Using () instead of {} for the function body is a POSIX
# compliant way to execute subshell and as consequence all
# variables in the function will become effectively in local
# scope. Note that the 'local' keyword is supported by most
# shells but it is not POSIX compliant.
read_property() (
  # The property we are looking for.
  prop_name=$1

  # The value of the property set initially to empty string.
  prop_value=

  if [ ! "$prop_name" = "" ] ; then
    # Search in the main '.config' file.
    prop_value=`grep -i ^${prop_name}= $CONFIG | cut -f2- -d'=' | xargs`

    if [ -f $SRC_DIR/.config ] ; then
      # Search in the local '.config' file.
      prop_value_local=`grep -i ^${prop_name}= $SRC_DIR/.config | cut -f2- -d'=' | xargs`

      if [ ! "$prop_value_local" = "" ] ; then
        # Override the original value with the local value.
        prop_value=$prop_value_local
      fi
    fi
  fi

  echo $prop_value
)

# Read the 'JOB_FACTOR' property from $CONFIG
export JOB_FACTOR="$(grep -i ^JOB_FACTOR $CONFIG | cut -f2 -d'=')"

# Read the 'CFLAGS' property from $CONFIG
export CFLAGS="$(grep -i ^CFLAGS $CONFIG | cut -f2 -d'=')"

# Find the number of available CPU cores
export NUM_CORES="$(grep ^processor /proc/cpuinfo | wc -l)"

# Calculate the number of make "jobs"
export NUM_JOBS=$((NUM_CORES * JOB_FACTOR))

# Ideally we would export MAKE at this point with -j etc to allow programs to just run $(MAKE) and not worry about extra flags that need to be passed
#  export MAKE="${MAKE-make} -j $NUM_JOBS"

# sysroot flags for the compiler

#-Wl,-nostdlib is required to make ld / gcc ignore the host's /usr/lib and /lib
#ld_flags="-Wl,-nostdlib $(grep -- \"-L\" $SYSROOT_SPECS)"
#-static-libgcc is neeeded since we don't have the gcc-libs in our sysroot
#gcc_flags="-specs=$SYSROOT_SPECS -static-libgcc"

# $ld_flags is passed 2 times because sometimes bundles ignore one of the variables
#export CC="${CC-gcc} $gcc_flags $ld_flags"
#export CFLAGS="$CFLAGS"
#export LDFLAGS="$LDFLAGS $ld_flags"

