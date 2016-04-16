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

# Remove the old ISO generation area if it exists.
rm -rf work/isoimage

# This is the root folder of the ISO image.
mkdir work/isoimage
cd work/isoimage

# Copy the precompiled files 'isolinux.bin' and 'ldlinux.c32' in the ISO image root folder.
cp $WORK_SYSLINUX_DIR/bios/core/isolinux.bin .
cp $WORK_SYSLINUX_DIR/bios/com32/elflink/ldlinux/ldlinux.c32 .

# Now we copy the kernel.
cp $WORK_KERNEL_DIR/arch/x86/boot/bzImage ./kernel.bz

# Now we copy the root file system.
cp ../rootfs.cpio.gz ./rootfs.gz

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
  # sparse
  
  echo "Using sparse file for overlay."
  
  # This is the BusyBox executable.
  BUSYBOX=../rootfs/bin/busybox  
  
  # Create sparse image file with 1MB size.
  $BUSYBOX truncate -s 1M minimal.img
  
  # Find available loop device.
  LOOP_DEVICE=$($BUSYBOX losetup -f)
  
  # Associate loop device with the sparse image file.
  $BUSYBOX losetup $LOOP_DEVICE minimal.img
  
  # Format the sparse image file with Ext2 file system. 
  $BUSYBOX mkfs.ext2 $LOOP_DEVICE
  
  # Mount the sparse file in folder 'tmp_min".
  mkdir tmp_min
  $BUSYBOX mount minimal.img tmp_min
  
  # Create the overlay folders.
  mkdir -p tmp_min/rootfs
  mkdir -p tmp_min/work
  
  # Copy the overlay content.
  cp -r $SRC_DIR/11_generate_iso/* tmp_min/rootfs/
  
  # Unmount the sparse file and thelete the temporary folder.
  $BUSYBOX umount tmp_min
  rm -rf tmp_min
  
  # Detach the loop device.
  $BUSYBOX losetup -d $LOOP_DEVICE
elif [ "$OVERLAY_TYPE" = "folder" ] ; then
  # folder
  echo "Using folder structure for overlay."
  mkdir -p minimal/rootfs
  mkdir -p minimal/work
  
  cp -r $SRC_DIR/11_generate_iso/* minimal/rootfs/
fi

# Create the overlay directory '/minimal/rootfs'. All files in this folder are
# merged in the root folder and can be manipulated thanks to overlayfs.
#mkdir -p minimal/rootfs
#cd minimal/rootfs
#echo 'Sample file 1 from CD.' > file_from_cd_1.txt
#echo 'Sample file 2 from CD.' > file_from_cd_2.txt
#cd ../..

# Create ISOLINUX configuration file.
echo 'default kernel.bz  initrd=rootfs.gz' > ./isolinux.cfg

# Now we generate the ISO image file.
genisoimage -J -r -o ../minimal_linux_live.iso -b isolinux.bin -c boot.cat -input-charset UTF-8 -no-emul-boot -boot-load-size 4 -boot-info-table ./

# This allows the ISO image to be bootable if it is burned on USB flash drive.
isohybrid ../minimal_linux_live.iso 2>/dev/null || true

# Copy the ISO image to the root project folder.
cp ../minimal_linux_live.iso ../../

cd ../..

