#!/bin/sh

for iface in /sys/class/net/*; do
	iface=${iface##*/}
	echo "Bringing up interface $iface"
	ip link set $iface up
done
