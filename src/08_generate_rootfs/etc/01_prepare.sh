#!/bin/sh

echo "Suppress most kernel messages."
dmesg -n 1

echo "Mount all core filesystems."
mount -t devtmpfs none /dev
mount -t proc none /proc
mount -t tmpfs none /tmp -o mode=1777
mount -t sysfs none /sys

