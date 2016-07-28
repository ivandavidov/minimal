#!/bin/sh

# Use this script without arguments to run the generated ISO image with QEMU.
# If you pass '-hdd' or '-h' the virtual hard disk 'hdd.img' will be attached.
# Note that this virtual hard disk has to be created in advance. You can use
# the script 'generate_hdd.sh' to generate the hard disk image file. Once you
# have hard disk image, you can use it as overlay device and persist all your
# changes. See the '.config' file for more information on the overlay support.

cmd="qemu-system-x86_64 -enable-kvm -m 128M -cdrom minimal_linux_live.iso -boot d -vga std"
if [ "$1" = "-hdd" -o "$1" = "-h" ] ; then
  echo "Starting QEMU with attached ISO image and hard disk."
  $cmd -hda hdd.img
else
  echo "Starting QEMU with attached ISO image."
  $cmd
fi

