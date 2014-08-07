#!/bin/sh

./0_prepare.sh
./1_get_kernel.sh
./2_build_kernel.sh
./3_get_busybox.sh
./4_build_busybox.sh
./5_generate_rootfs.sh
./6_pack_rootfs.sh
./7_generate_iso.sh
