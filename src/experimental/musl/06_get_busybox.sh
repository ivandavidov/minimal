#!/bin/sh

# Grab everything after the '=' character
DOWNLOAD_URL=$(grep -i BUSYBOX_SOURCE_URL .config | cut -f2 -d'=')

# Grab everything after the last '/' character
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

cd source

# Downloading busybox source
# -c option allows the download to resume
wget -c $DOWNLOAD_URL

# Delete folder with previously extracted busybox
rm -rf ../work/busybox
mkdir ../work/busybox

# Extract busybox to folder 'busybox'
# Full path will be something like 'work/busybox/busybox-1.23.1'
tar -xvf $ARCHIVE_FILE -C ../work/busybox

cd ..

