#!/bin/sh -e

time sh 00_clean.sh
time sh 01_get_kernel.sh
time sh 02_build_kernel.sh
time sh 03_get_glibc.sh
time sh 04_build_glibc.sh
time sh 05_prepare_glibc.sh
time sh 06_get_busybox.sh
time sh 07_build_busybox.sh
time sh 08_prepare_src.sh
time sh 09_generate_rootfs.sh
time sh 10_pack_rootfs.sh
time sh 11_get_syslinux.sh
time sh 12_generate_iso.sh

