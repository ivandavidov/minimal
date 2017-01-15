#!/bin/sh

SRC_DIR=$(pwd)

time sh 01_prepare.sh
time sh 02_disk_erase.sh
time sh 03_installer.sh
time sh 04_install.sh

cd $SRC_DIR

