#!/bin/sh

SRC_DIR=$(pwd)

# Find the main source directory
cd ..
MAIN_SRC_DIR=$(pwd)
cd $SRC_DIR

if [ "$1" = "" ] ; then
  # Read the 'OVERLAY_BUNDLES' property from '.config'
  OVERLAY_BUNDLES="$(grep -i ^OVERLAY_BUNDLES $MAIN_SRC_DIR/.config | cut -f2 -d'=')"
else
  OVERLAY_BUNDLES=$1
fi

if [ "$OVERLAY_BUNDLES" = "" ] ; then
  echo "There are no overlay bundles to build."
  exit 1
fi

time sh overlay_clean.sh

BUNDLES_LIST="$(echo $OVERLAY_BUNDLES | tr ',' ' ')"

for BUNDLE in $BUNDLES_LIST
do
  BUNDLE_DIR=$SRC_DIR/bundles/$BUNDLE

  if [ ! -d $BUNDLE_DIR ] ; then
      echo "Error - cannot find overlay bundle directory '$BUNDLE_DIR'."
      continue
  fi

  BUNDLE_SCRIPT=$BUNDLE_DIR/bundle.sh
  
  if [ ! -f $BUNDLE_SCRIPT ] ; then
    echo "Error - cannot find overlay bundle script file '$BUNDLE_SCRIPT'."
    continue
  fi

  cd $BUNDLE_DIR

  echo "Building overlay bundle '$BUNDLE'..."
  time sh $BUNDLE_SCRIPT

  cd $SRC_DIR
done

cd $SRC_DIR

