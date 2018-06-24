#!/bin/sh

# This script is supposed to be executed by Travis CI.

set -e

cd ../src

apt-get -qq -y install qemu

echo "`date` | *** MLL QEMU test - BEGIN ***"

#qemu-system-x86_64 -m 256M -cdrom minimal_linux_live.iso -boot d -localtime -nographic &
qemu-system-x86_64 -m 256M -kernel work/kernel/kernel_installed/kernel -initrd work/rootfs.cpio.xz -append "console=ttyS0 console=tty0" -localtime -console

sleep 5

MLL=`ps -ef | grep -i [q]emu`
if [ "$MLL" = "" ] ; then
  echo "`date` | !!! FAILURE !!! Minimal Linux Live is not running in QEMU."
  exit 1
else
  echo "`date` | Minimal Linux Live is running in QEMU. Waiting 120 seconds for automatic shutdown."
fi

sleep 120

MLL=`ps -ef | grep -i [q]emu`
if [ "$MLL" = "" ] ; then
  echo "`date` | Minimal Linux Live is not running in QEMU."
else
  echo "`date` | !!! FAILURE !!! Minimal Linux Live is still running in QEMU."
  exit 1
fi

echo "`date` | *** MLL QEMU test - END ***"

cat << CEOF

  #######################
  #                     #
  #  QEMU test passed.  #
  #                     #
  #######################

CEOF

set +e
