#!/bin/sh

set -e

. ../../common.sh

./01_get.sh
./02_install.sh

cd $SRC_DIR
