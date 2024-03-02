#!/bin/sh

set -e

. ../../common.sh
. ../../../settings

# Read the 'pkg_config' download URL from '.config'.
DOWNLOAD_URL=`read_property PKG_CONFIG_SOURCE_URL`

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

# Download 'pkg_config' source archive in the 'source/overlay' directory.
download_source $DOWNLOAD_URL $OVERLAY_SOURCE_DIR/$ARCHIVE_FILE

# Extract all 'coreutils' sources in the 'work/overlay/pkg_config' directory.
extract_source $OVERLAY_SOURCE_DIR/$ARCHIVE_FILE pkg_config

cd $SRC_DIR
