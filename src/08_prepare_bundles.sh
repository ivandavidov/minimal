#!/bin/sh

set -e

SRC_DIR=$(pwd)

echo "*** PREPARE OVERLAY BEGIN ***"

echo "Preparing overlay work area."
rm -rf $SRC_DIR/work/overlay*

# Read the 'OVERLAY_BUNDLES' property from '.config'
OVERLAY_BUNDLES="$(grep -i ^OVERLAY_BUNDLES .config | cut -f2 -d'=')"

if [ ! "$OVERLAY_BUNDLES" = "" ] ; then
  echo "Generating additional overlay bundles. This may take a while."
  cd minimal_overlay
  ./overlay_build.sh
  cd $SRC_DIR
else
  echo "Generation of additional overlay bundles has been skipped."
fi

echo "*** PREPARE OVERLAY END ***"
