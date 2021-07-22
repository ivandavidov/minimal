#!/bin/sh

# This script is supposed to be executed by GitHub workflow.

set -e

# Apply GitHub workflow specific patches
mkdir -p ../src/minimal_overlay/rootfs/etc/autorun
cp 99_autoshutdown.sh ../src/minimal_overlay/rootfs/etc/autorun
chmod +x ../src/minimal_overlay/rootfs/etc/autorun/99_autoshutdown.sh
cp -f syslinux.cfg ../src/minimal_boot/bios/boot/syslinux/syslinux.cfg
sed -i "s|OVERLAY_LOCATION.*|OVERLAY_LOCATION=rootfs|" ../src/.config

sudo apt-get -qq -y update
sudo apt-get -qq -y upgrade

set +e
