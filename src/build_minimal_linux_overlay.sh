#!/bin/sh

set -e

# Read the 'OVERLAY_BUNDLES' property from '.config'
OVERLAY_BUNDLES="$(grep -i ^OVERLAY_BUNDLES .config | cut -f2 -d'=')"

if [ "$OVERLAY_BUNDLES" = "" ] ; then
  echo "There are no overlay bundles to build."
else
  time sh overlay_00_clean.sh

  OVERLAY_BUNDLES_LIST="$(echo $OVERLAY_BUNDLES | tr ',' ' ')"

  for BUNDLE in $OVERLAY_BUNDLES_LIST
  do
    OVERLAY_SCRIPT=overlay_$BUNDLE.sh
    
    if [ ! -f $OVERLAY_SCRIPT ] ; then
      echo "Error - cannot find overlay script file '$OVERLAY_SCRIPT'."
    else
      echo "Building overlay bundle '$BUNDLE'..."
      time sh $OVERLAY_SCRIPT
    fi
  done
fi

