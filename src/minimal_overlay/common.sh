#!/bin/sh

set -e

# Common code used by all bundles. Should be included at the
# top of every *.sh file of each bundle.

export SRC_DIR=`realpath --no-symlinks $PWD`
export MAIN_SRC_DIR=`realpath --no-symlinks $SRC_DIR/../../../`
export WORK_DIR=$MAIN_SRC_DIR/work
export SOURCE_DIR=$MAIN_SRC_DIR/source
export OVERLAY_WORK_DIR=$WORK_DIR/overlay
export OVERLAY_SOURCE_DIR=$SOURCE_DIR/overlay
export OVERLAY_ROOTFS=$WORK_DIR/overlay_rootfs
export BUNDLE_NAME=`basename $SRC_DIR`
export DEST_DIR=$WORK_DIR/overlay/$BUNDLE_NAME/${BUNDLE_NAME}_installed
export CONFIG=$MAIN_SRC_DIR/.config
export SYSROOT=$WORK_DIR/sysroot

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
    prop_value="`grep -i ^${prop_name}= $CONFIG | cut -f2- -d'=' | xargs`"

    if [ -f $SRC_DIR/.config ] ; then
      # Search in the local '.config' file.
      prop_value_local="`grep -i ^${prop_name}= $SRC_DIR/.config | cut -f2- -d'=' | xargs`"

      if [ ! "$prop_value_local" = "" ] ; then
        # Override the original value with the local value.
        prop_value="$prop_value_local"
      fi
    fi
  fi

  echo "$prop_value"
)

# Read commonly used configuration properties.
export JOB_FACTOR="`read_property JOB_FACTOR`"
export CFLAGS="`read_property CFLAGS`"
export NUM_CORES="$(grep ^processor /proc/cpuinfo | wc -l)"

# Calculate the number of make "jobs"
export NUM_JOBS="$((NUM_CORES * JOB_FACTOR))"

# Ideally we would export MAKE at this point with -j etc to allow programs to just run $(MAKE) and not worry about extra flags that need to be passed
# export MAKE="${MAKE-make} -j $NUM_JOBS"

download_source() (
  url=$1  # Download from this URL.
  file=$2 # Save the resource in this file.

  local=`read_property USE_LOCAL_SOURCE`

  if [ "$local" = "true" -a ! -f $file  ] ; then
    echo "Source file '$file' is missing and will be downloaded."
    local=false
  fi

  if [ ! "$local" = "true" ] ; then
    echo "Downloading overlay source file from '$url'."
    echo "Saving overlay source file in '$file'".
    wget -O $file -c $url
  else
    echo "Using local overlay source file '$file'."
  fi
)

extract_source() (
  file=$1
  name=$2

  # Delete folder with previously extracted source.
  echo "Removing overlay work area for '$name'. This may take a while."
  rm -rf $OVERLAY_WORK_DIR/$name
  mkdir -p $OVERLAY_WORK_DIR/$name

  # Extract source to folder 'work/overlay/$source'.
  tar -xvf $file -C $OVERLAY_WORK_DIR/$name
)

make_target() (
  make -j $NUM_JOBS "$@"
)

make_clean() (
  target=$1

  if [ "$target" = "" ] ; then
    target=clean
  fi

  if [ -f Makefile ] ; then
    echo "Preparing '$BUNDLE_NAME' work area. This may take a while."
    make_target $target
  else
    echo "The clean phase for '$BUNDLE_NAME' has been skipped."
  fi
)

reduce_size() (
  while [ ! "$1" = "" ] ; do
    if [ -d $1 ] ; then
      for file in $1/* ; do
        reduce_size $file
      done
    elif [ -f $1 ] ; then
      set +e
      strip -g $1 2>/dev/null
      set -e
    fi
    
    shift
  done
)

install_to_overlay() (
  # With '--remove-destination' all possibly existing soft links in
  # $OVERLAY_ROOTFS will be overwritten correctly.

  if [ "$#" = "2" ] ; then
    cp -r --remove-destination \
      $DEST_DIR/$1 \
      $OVERLAY_ROOTFS/$2
  elif [ "$#" = "1" ] ; then
    cp -r --remove-destination \
      $DEST_DIR/$1 \
      $OVERLAY_ROOTFS
  elif [ "$#" = "0" ] ; then
    cp -r --remove-destination \
      $DEST_DIR/* \
      $OVERLAY_ROOTFS
  fi
)
