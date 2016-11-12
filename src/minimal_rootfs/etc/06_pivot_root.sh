#!/bin/sh

cd /

mkdir n

mount -t tmpfs none /n

cp -a bin sbin usr lib lib64 var /n

cd n

mkdir -p dev/pts proc sys tmp old

mount --move /dev/pts dev/pts
mount --move /dev dev
mount --move /proc proc
mount --move /sys sys
mount --move /tmp tmp

pivot_root . old

chroot . /bin/sh

