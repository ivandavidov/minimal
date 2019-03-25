#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** GET BUSYBOX BEGIN ***"

# Read the 'BUSYBOX_SOURCE_URL' property from '.config'.
DOWNLOAD_URL=`read_property BUSYBOX_SOURCE_URL`

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

# Download Busybox source archive in the 'source' directory.
download_source $DOWNLOAD_URL $SOURCE_DIR/$ARCHIVE_FILE

# Extract the Busybox sources in the 'work/busybox' directory.
extract_source $SOURCE_DIR/$ARCHIVE_FILE busybox

# We go back to the main MLL source folder.
cd $SRC_DIR

echo "*** GET BUSYBOX END ***"
