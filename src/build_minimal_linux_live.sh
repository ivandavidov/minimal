#!/bin/sh

sh 00_clean.sh
sh 01_prepare_src.sh
sh 02_get_kernel.sh
sh 03_build_kernel.sh
sh 04_get_glibc.sh
sh 05_build_glibc.sh
sh 06_prepare_glibc.sh
sh 07_get_busybox.sh
sh 08_build_busybox.sh
sh 09_generate_rootfs.sh
sh 10_pack_rootfs.sh
sh 11_get_syslinux.sh
sh 12_generate_iso.sh

