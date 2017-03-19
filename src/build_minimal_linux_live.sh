#!/bin/sh

time bash 00_clean.sh
time bash 01_get_kernel.bash
time bash 02_build_kernel.sh
time bash 03_get_glibc.bash
time bash 04_build_glibc.sh
time bash 05_prepare_glibc.sh
time bash 06_get_busybox.bash
time bash 07_build_busybox.sh
time bash 08_prepare_src.sh
time bash 09_generate_rootfs.sh
time bash 10_pack_rootfs.sh
time bash 11_get_syslinux.sh
time bash 12_generate_iso.sh

