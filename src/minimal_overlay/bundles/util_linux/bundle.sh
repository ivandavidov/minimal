#!/bin/sh

SRC_DIR=$(pwd)

time sh 01_get.sh
time sh 02_build.sh

cd $SRC_DIR

