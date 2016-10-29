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
#                    |       +-- udhcpc
#                    |           |
#                    |           +-- /etc/05_rc.udhcp
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

# CGROUPS BEGIN
#mount -t tmpfs tmpfs /sys/fs/cgroup

#mkdir /sys/fs/cgroup/cpu
#mount -t cgroup -o cpu cgroup /sys/fs/cgroup/cpu

#mkdir /sys/fs/cgroup/memory
#mount -t cgroup -o memory cgroup /sys/fs/cgroup/memory

# mount /sys/fs/cgroup if not already done
if ! mountpoint -q /sys/fs/cgroup; then
  mount -t tmpfs -o uid=0,gid=0,mode=0755 cgroup /sys/fs/cgroup
fi

cd /sys/fs/cgroup

# get/mount list of enabled cgroup controllers
for sys in $(awk '!/^#/ { if ($4 == 1) print $1 }' /proc/cgroups); do
  mkdir -p $sys
  if ! mountpoint -q $sys; then
    if ! mount -n -t cgroup -o $sys cgroup $sys; then
      rmdir $sys || true
    fi
fi
done

# CGROUPS END

echo "Mounted all core filesystems. Ready to continue."

