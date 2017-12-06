#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** CLEAN BEGIN ***"

echo "Cleaning up the main work area. This may take a while."
rm -rf $WORK_DIR
mkdir $WORK_DIR
mkdir -p $SOURCE_DIR

echo "*** CLEAN END ***"
