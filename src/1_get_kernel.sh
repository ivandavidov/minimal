#!/bin/sh

if [ -z "$BASE_DIR" ]; then
	BASE_DIR="`pwd`"
fi

. $BASE_DIR/.vars
. $BASE_DIR/.config

# Grab everything after the last '/' character
ARCHIVE_FILE=${KERNEL_SOURCE_URL##*/}

cd $SRC_DIR

# Downloading kernel file
# -c option allows the download to resume
wget -c $KERNEL_SOURCE_URL

# Delete folder with previously extracted kernel
rm -rf $LINUX_BUILD_DIR
mkdir $LINUX_BUILD_DIR

# Extract kernel to folder 'work/kernel'
# Full path will be something like 'work/kernel/linux-3.16.1'
tar -xvf $ARCHIVE_FILE -C $LINUX_BUILD_DIR

cd $BASE_DIR

