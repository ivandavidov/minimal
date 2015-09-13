#!/bin/sh

cd work/toybox

# Change to the first directory ls finds, e.g. 'toybox-0.6.0'
cd $(ls -d *)

# Remove previously generated artefacts
make distclean

# Create a default configuration file
make allyesconfig

export LDFLAGS="--static"

# Compile toybox with optimization for "parallel jobs" = "number of processors"
make toybox -j $(grep ^processor /proc/cpuinfo | wc -l)

unset LDFLAGS

rm -rf rootfs
mkdir rootfs
export PREFIX=rootfs
# Create the symlinks for toybox
make install_flat
unset PREFIX

cd ../../..

