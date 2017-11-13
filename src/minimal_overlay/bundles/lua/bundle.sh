#!/bin/sh

SRC_DIR=$(pwd)

time ./01_get.sh
time ./02_build.sh

cd $SRC_DIR
