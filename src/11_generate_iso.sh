#!/bin/sh

SRC_DIR=$(pwd)

# Find the kernel build directory.
cd work/kernel
cd $(ls -d *)
WORK_KERNEL_DIR=$(pwd)
cd ../../..

# Find the Syslinux build directory.
cd work/syslinux
cd $(ls -d *)
WORK_SYSLINUX_DIR=$(pwd)
cd ../../..

# Remove the old ISO file if it exists.
rm -f minimal_linux_live.iso
echo "Old ISO image files has been removed."

# Remove the old ISO generation area if it exists.
echo "Removing old ISO image work area..."
rm -rf work/isoimage

# This is the root folder of the ISO image.
mkdir work/isoimage
cd work/isoimage
echo "Prepared new ISO image work area."

# Copy the precompiled files 'isolinux.bin' and 'ldlinux.c32' in the ISO image root folder.
cp $WORK_SYSLINUX_DIR/bios/core/isolinux.bin .
cp $WORK_SYSLINUX_DIR/bios/com32/elflink/ldlinux/ldlinux.c32 .

# Now we copy the kernel.
cp $WORK_KERNEL_DIR/arch/x86/boot/bzImage ./kernel.xz

# Now we copy the root file system.
cp ../rootfs.cpio.xz ./rootfs.xz

# Copy all source files to '/src'. Note that the scripts won't work there.
mkdir src
cp ../../*.sh src
cp ../../.config src
cp ../../*.txt src
chmod +rx src/*.sh
chmod +r src/.config
chmod +r src/*.txt

# Read the 'OVERLAY_TYPE' property from '.config'
OVERLAY_TYPE="$(grep -i OVERLAY_TYPE $SRC_DIR/.config | cut -f2 -d'=')"

if [ "$OVERLAY_TYPE" = "sparse" -a "$(id -u)" = "0" ] ; then
  # Use sparse file as storage place. The above check guarantees that the whole
  # script is executed with root permissions or otherwise this block is skipped.
  # All files and folders located in the folder '11_generate_iso' will be merged
  # with the root folder on boot.
  
  echo "Using sparse file for overlay."
  
  # This is the BusyBox executable that we have already generated.
  BUSYBOX=../rootfs/bin/busybox  
  
  # Create sparse image file with 1MB size. Note that this increases the ISO image size.
  $BUSYBOX truncate -s 1M minimal.img
  
  # Find available loop device.
  LOOP_DEVICE=$($BUSYBOX losetup -f)
  
  # Associate the available loop device with the sparse image file.
  $BUSYBOX losetup $LOOP_DEVICE minimal.img
  
  # Format the sparse image file with Ext2 file system. 
  $BUSYBOX mkfs.ext2 $LOOP_DEVICE
  
  # Mount the sparse file in folder 'sparse".
  mkdir sparse
  $BUSYBOX mount minimal.img sparse
  
  # Create the overlay folders.
  mkdir -p sparse/rootfs
  mkdir -p sparse/work  
  
  # Copy the overlay content.
  cp -r $SRC_DIR/11_generate_iso/* sparse/rootfs/
  
  # Unmount the sparse file and delete the temporary folder.
  $BUSYBOX umount sparse
  rm -rf sparse
  
  # Detach the loop device since we no longer need it.
  $BUSYBOX losetup -d $LOOP_DEVICE
elif [ "$OVERLAY_TYPE" = "folder" ] ; then
  # Use normal folder structure for overlay. All files and folders located in
  # the folder '11_generate_iso' will be merged with the root folder on boot.
  
  echo "Using folder structure for overlay."
  
  mkdir -p minimal/rootfs
  mkdir -p minimal/work  
  
  cp -rf $SRC_DIR/11_generate_iso/* minimal/rootfs/
else
  echo "Generating ISO image with no overlay structure..."
fi

# Create ISOLINUX configuration file.
echo 'default kernel.xz  initrd=rootfs.xz' > ./isolinux.cfg

# Delete the '.gitignore' files which we use in order to keep track of otherwise
# empty folders.
find * -type f -name '.gitignore' -exec rm {} +

# Now we generate the ISO image file.
genisoimage -J -r -o ../minimal_linux_live.iso -b isolinux.bin -c boot.cat -input-charset UTF-8 -no-emul-boot -boot-load-size 4 -boot-info-table ./

# This allows the ISO image to be bootable if it is burned on USB flash drive.
isohybrid ../minimal_linux_live.iso 2>/dev/null || true

# Copy the ISO image to the root project folder.
cp ../minimal_linux_live.iso ../../

if [ "$(id -u)" = "0" ] ; then
  # Apply ownership back to original owner for all affected files.
  chown $(logname) ../../minimal_linux_live.iso
  chown $(logname) ../../work/minimal_linux_live.iso
  chown -R $(logname) .
  echo "Applied original ownership to all affected files and folders."
fi

cd ../..

