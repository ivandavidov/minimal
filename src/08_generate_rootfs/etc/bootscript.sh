#!/bin/sh

echo "Welcome to \"Minimal Linux Live\" (/sbin/init)"

for DEVICE in /sys/class/net/* ; do
  echo "Found network device ${DEVICE##*/}" 
  ip link set ${DEVICE##*/} up
  [ ${DEVICE##*/} != lo ] && udhcpc -b -i ${DEVICE##*/} -s /etc/rc.dhcp
done

