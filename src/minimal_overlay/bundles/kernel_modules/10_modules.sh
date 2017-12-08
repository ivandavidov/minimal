#!/bin/sh

# Enable the 'mdev' hotplug manager.
echo /sbin/mdev > /proc/sys/kernel/hotplug

# Initial execution of the 'mdev' hotpug manager.
/sbin/mdev -s

cat << CEOF
[1m  The 'mdev' hotplug manager is active.[0m
CEOF
