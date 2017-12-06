#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** GET GLIBC BEGIN ***"

# Read the 'GLIBC_SOURCE_URL' property from '.config'.
DOWNLOAD_URL=`read_property GLIBC_SOURCE_URL`

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

# Download glibc source archive in the 'source' directory.
download_source $DOWNLOAD_URL $SOURCE_DIR/$ARCHIVE_FILE

# Extract the glibc sources in the 'work/glibc' directory.
extract_source $SOURCE_DIR/$ARCHIVE_FILE glibc

# We go back to the main MLL source folder.
cd $SRC_DIR

echo "*** GET GLIBC END ***"
