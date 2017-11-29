#!/bin/sh

set -e

# This script is useful if you have already built MLL and
# you want to perform fast repackaging of all components.
#
# Note: this will also rebuild all overlay bundles.

./08_prepare_bundles.sh
./09_generate_rootfs.sh
./10_pack_rootfs.sh
./12_generate_iso.sh
./13_generate_image.sh
