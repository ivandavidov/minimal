#!/bin/sh

set -e

# This script is useful if you have already built MLL and
# you want to perform fast repackaging of all components.
#
# Note: this will also rebuild all overlay bundles.

./08_prepare_bundles.sh
./09_generate_rootfs.sh
./10_pack_rootfs.sh
./11_generate_overlay.sh
./12_get_syslinux.sh
./12_get_systemd-boot.sh
./13_prepare_iso.sh
./14_generate_iso.sh
./15_generate_image.sh
./16_cleanup.sh
