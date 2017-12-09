#!/bin/sh

set -e

# This script is useful if you have already built MLL and
# you want to perform fast rebuilding of all components.

./19_cleanup.sh
./09_config_kernel.sh
./10_prepare_bundles.sh
./11_generate_rootfs.sh
./12_pack_rootfs.sh
./13_generate_overlay.sh
./14_build_kernel.sh
./16_prepare_iso_bios.sh
./16_prepare_iso_uefi.sh
./17_generate_iso_bios.sh
./17_generate_iso_uefi.sh
./18_generate_image.sh
./19_cleanup.sh
