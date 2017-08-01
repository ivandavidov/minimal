#!/bin/sh

# System initialization sequence:
#
# /init
#  |
#  +--(1) /etc/01_prepare.sh (this file)
#  |
#  +--(2) /etc/02_overlay.sh
#          |
#          +-- /etc/03_init.sh
#               |
#               +-- /sbin/init
#                    |
#                    +--(1) /etc/04_bootscript.sh
#                    |       |
#                    |       +-- /etc/autorun/* (all scripts)
#                    |
#                    +--(2) /bin/sh (Alt + F1, main console)
#                    |
#                    +--(2) /bin/sh (Alt + F2)
#                    |
#                    +--(2) /bin/sh (Alt + F3)
#                    |
#                    +--(2) /bin/sh (Alt + F4)

dmesg -n 1
echo "Most kernel messages have been suppressed."

mount -t devtmpfs none /dev
mount -t proc none /proc
mount -t tmpfs none /tmp -o mode=1777
mount -t sysfs none /sys

mkdir -p /dev/pts

mount -t devpts none /dev/pts

echo "Mounted all core filesystems. Ready to continue."

