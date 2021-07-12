#!/bin/sh

set -e

. ../../common.sh

./01_get.sh
./02_build_python.sh
./03_build_pip.sh
./04_build_packages.sh
./05_install.sh

cd $SRC_DIR
