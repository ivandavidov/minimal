#!/bin/sh

if [ -z "$BASE_DIR" ]; then
	# Standalone execution
	BASE_DIR="`pwd`"
	. ${BASE_DIR}/.vars
fi

rm -rf $WORK_DIR
mkdir $WORK_DIR
rm -rf $OUT_DIR
mkdir $OUT_DIR

# -p stops errors if the directory already exists
mkdir -p $SRC_DIR

