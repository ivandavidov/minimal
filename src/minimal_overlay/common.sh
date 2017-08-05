#!/bin/sh
# common code used by all bundles
# should be included at the top of every *.sh file of each bundle

export MAIN_SRC_DIR=$(realpath --no-symlinks $PWD/../../../)
export WORK_DIR="$MAIN_SRC_DIR/work"
export SRC_DIR=$(pwd)
export CONFIG="$MAIN_SRC_DIR/.config"
export SYSROOT="$WORK_DIR/sysroot"
export SYSROOT_SPECS="$WORK_DIR/sysroot.specs"

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

