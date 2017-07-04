#!/bin/sh
# common code use by almost all bundles
# this should be sourced in bundle.sh of every bundle

# Read the 'JOB_FACTOR' property from '.config'
JOB_FACTOR="$(grep -i ^JOB_FACTOR $MAIN_SRC_DIR/.config | cut -f2 -d'=')"

# Read the 'CFLAGS' property from '.config'
CFLAGS="$(grep -i ^CFLAGS $MAIN_SRC_DIR/.config | cut -f2 -d'=')"

# Find the number of available CPU cores.
NUM_CORES=$(grep ^processor /proc/cpuinfo | wc -l)

# Calculate the number of 'make' jobs to be used later.
NUM_JOBS=$((NUM_CORES * JOB_FACTOR))

# sysroot

# some of these are duplicate, but there are always bad packages that ignore one of these
SPECS=$PWD/../../../work/sysroot.specs
CC="gcc -specs=$SPECS -static-libgcc -Wl,-nostdlib"
CFLAGSC="-specs=$SPECS -static-libgcc $CFLAGS -Wl,-nostdlib"
CPPFLAGS="-specs=$SPECS -static-libgcc $CPPFLAGS -Wl,-nostdlib"
LDFLAGS="-Wl,-nostdlib $(grep -- \"-L\" $SPECS)"
