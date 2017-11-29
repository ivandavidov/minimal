#!/bin/sh

set -e

. ../../common.sh

./01_get.sh
./02_build.sh

cd $SRC_DIR
