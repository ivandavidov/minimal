#!/bin/sh

cd work/musl

# Change to the first directory ls finds, e.g. 'musl-1.1.11'
cd $(ls -d *)

make distclean

mkdir musl-installed
./configure --prefix=$(pwd)/musl-installed

make -j $(grep ^processor /proc/cpuinfo | wc -l)

make install -j $(grep ^processor /proc/cpuinfo | wc -l)

cd ../../..

