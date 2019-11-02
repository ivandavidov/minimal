#!/bin/sh

set -e

. ../../common.sh

# Read the configuration properties.
JVM_ENGINE=`read_property JVM_ENGINE`
DOWNLOAD_URL=`read_property ADOPT_OPENJDK_${JVM_ENGINE}_URL`

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

download_source $DOWNLOAD_URL $OVERLAY_SOURCE_DIR/$ARCHIVE_FILE

extract_source $OVERLAY_SOURCE_DIR/$ARCHIVE_FILE $BUNDLE_NAME

cd $SRC_DIR

