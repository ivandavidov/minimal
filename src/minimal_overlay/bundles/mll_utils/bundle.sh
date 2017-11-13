#!/bin/sh

SRC_DIR=$(pwd)

./01_prepare.sh
./02_disk_erase.sh
./03_installer.sh
./04_install.sh

cd $SRC_DIR

