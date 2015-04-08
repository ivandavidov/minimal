#!/bin/sh

if [ -z "$BASE_DIR" ]; then
	BASE_DIR="`pwd`"
fi

. ${BASE_DIR}/.vars

rm -rf $WORK_DIR
mkdir $WORK_DIR

# -p stops errors if the directory already exists
mkdir -p $SRC_DIR

