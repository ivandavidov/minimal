#!/bin/sh

SRC_DIR=$(pwd)

time ./01_prepare.sh
time ./02_disk_erase.sh
time ./03_installer.sh
time ./04_install.sh

cd $SRC_DIR

