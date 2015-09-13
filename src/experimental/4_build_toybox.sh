#!/bin/sh

cd work/toybox

# Change to the first directory ls finds, e.g. 'toybox-0.6.0'
cd $(ls -d *)

# Remove previously generated artefacts.
make distclean

# Create a configuration file with all possible selections.
make allyesconfig

# Static linking
export LDFLAGS="--static"

# Compile ToyBox with optimization for "parallel jobs" = "number of processors".
make toybox -j $(grep ^processor /proc/cpuinfo | wc -l)

# We no longer need flags for static linking.
unset LDFLAGS

rm -rf rootfs
mkdir rootfs

# Directory where ToyBox binary and symlink will be instaled.
export PREFIX=rootfs

# Create the symlinks for toybox in single folder.
make install_flat

# We no longer need this environment variable.
unset PREFIX

cd ../../..

