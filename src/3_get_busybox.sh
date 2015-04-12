#!/bin/sh

if [ -z "$BASE_DIR" ]; then
	BASE_DIR="`pwd`"
fi

. $BASE_DIR/.vars
. $BASE_DIR/.config

# Grab everything after the last '/' character
ARCHIVE_FILE=${BUSYBOX_SOURCE_URL##*/}

cd $SRC_DIR

# Downloading busybox source
# -c option allows the download to resume
wget -c $BUSYBOX_SOURCE_URL

# Delete folder with previously extracted busybox
rm -rf $BUSYBOX_BUILD_DIR
mkdir $BUSYBOX_BUILD_DIR

# Extract busybox to folder 'busybox'
# Full path will be something like 'work/busybox/busybox-1.23.1'
tar -xvf $ARCHIVE_FILE -C $BUSYBOX_BUILD_DIR

cd $BASE_DIR

