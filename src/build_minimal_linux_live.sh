#!/bin/sh

sh time 00_clean.sh
sh time 01_get_kernel.sh
sh time 02_build_kernel.sh
sh time 03_get_glibc.sh
sh time 04_build_glibc.sh
sh time 05_prepare_glibc.sh
sh time 06_get_busybox.sh
sh time 07_build_busybox.sh
sh time 08_prepare_src.sh
sh time 09_generate_rootfs.sh
sh time 10_pack_rootfs.sh
sh time 11_get_syslinux.sh
sh time 12_generate_iso.sh

