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
#
# 'Ctrl + A' then 'C' to toggle between guest system console and QEMU monitor.
# 'Ctrl + A' then 'X' to terminate the QEMU instance.
#
# In nographic mode, qemu disables virtual console. To obtain a system console,
# the virtual serial port can be used. In this mode, the virtual serial port is
# redirected to the host's stdio by default. Pass "console=ttySn" (PC) or
# "console=ttyAMAn" (on ARM) where n is 0, 1, ... on the kernel command line.

cat << CEOF

  'Ctrl + A' then 'C' to toggle between guest system console and QEMU monitor.
  'Ctrl + A' then 'X' to terminate the QEMU instance.

  Type 'console' in the boot menu to run MLL in QEMU console mode.

CEOF

if [ "`uname -m`" = "x86_64" ] ; then
  ARCH="x86_64"
else
  ARCH="i386"
fi

cmd="qemu-system-$ARCH -m 128M -cdrom minimal_linux_live.iso -boot d -nographic"

if [ "$1" = "-hdd" -o "$1" = "-h" ] ; then
  echo "Starting QEMU with attached ISO image and hard disk."
  echo 'console' | $cmd -hda hdd.img
else
  echo "Starting QEMU with attached ISO image."
  echo 'console' | $cmd
fi
