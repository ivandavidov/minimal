#!/bin/sh

sh 00_prepare.sh
sh 01_get_kernel.sh
sh 02_build_kernel.sh
sh 03_get_glibc.sh
sh 04_build_glibc.sh
sh 05_prepare_glibc.sh
sh 06_get_busybox.sh
sh 07_build_busybox.sh
sh 08_generate_rootfs.sh
sh 09_pack_rootfs.sh
sh 10_get_syslinux.sh
sh 11_generate_iso.sh

