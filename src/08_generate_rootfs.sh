#!/bin/sh

# Find the glibc installation area.
cd work/glibc
cd $(ls -d *)
cd glibc_installed
GLIBC_INSTALLED=$(pwd)

cd ../../../..

cd work

echo "Preparing initramfs work area..."
rm -rf rootfs

cd busybox

# Change to the first directory ls finds, e.g. 'busybox-1.24.2'.
cd $(ls -d *)

# Copy all BusyBox generated stuff to the location of our 'initramfs' folder.
cp -r _install ../../rootfs

# Copy all rootfs resources to the location of our 'initramfs' folder.
cp -r ../../../08_generate_rootfs/* ../../rootfs

cd ../../rootfs

# Remove 'linuxrc' which is used when we boot in 'RAM disk' mode. 
rm -f linuxrc

# Copy all source files to '/src'. Note that the scripts won't work there.
cp ../../*.sh src
cp ../../.config src
cp ../../*.txt src
cp -r ../../08_generate_rootfs src
cp -r ../../11_generate_iso src

# Make all files readable and all scripts executable.
chmod -R +rx **/*.sh
chmod -R +r **/.config
chmod -R +r **/*.txt

# Copy all necessary 'glibc' libraries to '/lib' BEGIN.

# This is the dynamic loader. The file name is different for 32-bit and 64-bit machines.
cp $GLIBC_INSTALLED/lib/ld-linux* ./lib

# BusyBox has direct dependencies on these libraries.
cp $GLIBC_INSTALLED/lib/libm.so.6 ./lib
cp $GLIBC_INSTALLED/lib/libc.so.6 ./lib

# These libraries are necessary for the DNS resolving.
cp $GLIBC_INSTALLED/lib/libresolv.so.2 ./lib
cp $GLIBC_INSTALLED/lib/libnss_dns.so.2 ./lib

# Make sure the dynamic loader is visible on 64-bit machines.
ln -s lib lib64

# Copy all necessary 'glibc' libraries to '/lib' END.

# Delete the '.gitignore' files which we use in order to keep track of otherwise
# empty folders.
find * -type f -name '.gitignore' -exec rm {} +

echo "The initramfs area has been generated."

cd ../..

