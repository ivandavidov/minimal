#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** GET KERNEL BEGIN ***"

# Read the 'KERNEL_SOURCE_URL' property from '.config'.
DOWNLOAD_URL=`read_property KERNEL_SOURCE_URL`

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

# Download kernel source archive in the 'source' directory.
download_source $DOWNLOAD_URL $SOURCE_DIR/$ARCHIVE_FILE

# Extract the kernel sources in the 'work/kernel' directory.
extract_source $SOURCE_DIR/$ARCHIVE_FILE kernel

# We go back to the main MLL source folder.
cd $SRC_DIR

echo "*** GET KERNEL END ***"
