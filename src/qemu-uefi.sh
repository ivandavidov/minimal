#!/bin/sh

# Use this script without arguments to run the generated ISO image with QEMU.
# If you pass '-hdd' or '-h' the virtual hard disk 'hdd.img' will be attached.
# Note that this virtual hard disk has to be created in advance. You can use
# the script 'generate_hdd.sh' to generate the hard disk image file. Once you
# have hard disk image, you can use it as overlay device and persist all your
# changes. See the '.config' file for more information on the overlay support.
#
# If you get kernel panic with message "No working init found", then try to
# increase the RAM from 128M to 256M.

# Location to local file 'OVMF.fd'. You can download it from here:
#  https://sourceforge.net/projects/edk2/files/OVMF/)
OVMF_LOCATION=~/Downloads/OVMF.fd

cmd="qemu-system-$(uname -m) -pflash $OVMF_LOCATION -m 128M -cdrom minimal_linux_live.iso -boot d -vga std"

if [ "$1" = "-hdd" -o "$1" = "-h" ] ; then
  echo "Starting QEMU with attached ISO image and hard disk."
  $cmd -hda hdd.img > /dev/null 2>&1 &
else
  echo "Starting QEMU with attached ISO image."
  $cmd > /dev/null 2>&1 &
fi
