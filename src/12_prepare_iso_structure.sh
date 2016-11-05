echo "*** PREPARE ISO STRUCTURE BEGIN ***"

SRC_DIR=$(pwd)

# Save the kernel installation directory.
KERNEL_INSTALLED=$SRC_DIR/work/kernel/kernel_installed

# Find the Syslinux build directory.
cd work/syslinux
cd $(ls -d *)
WORK_SYSLINUX_DIR=$(pwd)
cd $SRC_DIR

# Remove the old ISO generation area if it exists.
echo "Removing old ISO image work area. This may take a while..."
rm -rf work/isoimage

# This is the root folder of the ISO image.
mkdir work/isoimage
echo "Prepared new ISO image work area."

# Read the 'COPY_SOURCE_ISO' property from '.config'
COPY_SOURCE_ISO="$(grep -i ^COPY_SOURCE_ISO .config | cut -f2 -d'=')"

if [ "$COPY_SOURCE_ISO" = "true" ] ; then
  # Copy all prepared source files and folders to '/src'. Note that the scripts
  # will not work there because you also need proper toolchain.
  cp -r work/src work/isoimage
  echo "Source files and folders have been copied to '/src'."
else
  echo "Source files and folders have been skipped."
fi

cd work/isoimage

# Now we copy the kernel.
cp $KERNEL_INSTALLED/kernel ./kernel.xz

# Now we copy the root file system.
cp ../rootfs.cpio.xz ./rootfs.xz

# Copy the precompiled files 'isolinux.bin' and 'ldlinux.c32' in the ISO image
# root folder.
cp $WORK_SYSLINUX_DIR/bios/core/isolinux.bin .
cp $WORK_SYSLINUX_DIR/bios/com32/elflink/ldlinux/ldlinux.c32 .

# Create the ISOLINUX configuration file.
echo 'default /kernel.xz initrd=/rootfs.xz vga=ask' > ./syslinux.cfg

# Create UEFI start script.
mkdir -p efi/boot
cat << CEOF > ./efi/boot/startup.nsh
echo -off
echo Minimal Linux Live is starting...
\\kernel.xz initrd=\\rootfs.xz
CEOF

cd $SRC_DIR

echo "*** PREPARE ISO STRUCTURE END ***"

