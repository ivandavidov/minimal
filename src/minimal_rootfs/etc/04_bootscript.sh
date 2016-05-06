#!/bin/sh

# System initialization sequence:
#
# /init
#  |
#  +--(1) /etc/01_prepare.sh
#  |
#  +--(2) /etc/02_overlay.sh
#          |
#          +-- /etc/03_init.sh
#               |
#               +-- /sbin/init
#                    |
#                    +--(1) /etc/04_bootscript.sh (this file)
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

echo "Welcome to \"Minimal Linux Live\" (/sbin/init)"

for DEVICE in /sys/class/net/* ; do
  echo "Found network device ${DEVICE##*/}" 
  ip link set ${DEVICE##*/} up
  [ ${DEVICE##*/} != lo ] && udhcpc -b -i ${DEVICE##*/} -s /etc/05_rc.dhcp
done

