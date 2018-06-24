#!/bin/sh

# This script is supposed to be executed by Travis CI.

set -e

# Apply Travis specific patches
#mkdir -p ../src/minimal_overlay/rootfs/etc/autorun
#cp 99_autoshutdown.sh ../src/minimal_overlay/rootfs/etc/autorun
#cp -f syslinux.cfg ../src/minimal_boot/bios/boot/syslinux/syslinux.cfg
#sed -i "s|OVERLAY_LOCATION.*|OVERLAY_LOCATION=rootfs|" ../src/.config

while true; do sleep 300; echo "`date` | >>> Heartbeat <<<"; done &

apt-get -qq update

./build_mll.sh
#./test_qemu.sh
#./test_docker.sh

set +e

