#!/bin/sh

set -e

SRC_DIR=$(pwd)

# Find the main source directory
cd ..
MAIN_SRC_DIR=$(pwd)
cd $SRC_DIR

if [ "$1" = "--skip-clean" ] ; then
  SKIP_CLEAN=true
  shift
fi

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

if [ ! "$SKIP_CLEAN" = "true" ] ; then
  ./overlay_clean.sh
fi

if [ "$OVERLAY_BUNDLES" = "all" ] ; then
  BUNDLES_LIST=`ls $SRC_DIR/bundles`
else
  BUNDLES_LIST="$(echo $OVERLAY_BUNDLES | tr ',' ' ')"
fi

for BUNDLE in $BUNDLES_LIST
do
  BUNDLE_DIR=$SRC_DIR/bundles/$BUNDLE

  if [ ! -d $BUNDLE_DIR ] ; then
      echo "Error - cannot find overlay bundle directory '$BUNDLE_DIR'."
      exit 1
  fi

  # Deal with dependencies BEGIN
  if [ -f $BUNDLE_DIR/bundle_deps ] ; then
    echo "Overlay bundle '$BUNDLE' depends on the following overlay bundles:"
    cat $BUNDLE_DIR/bundle_deps

    while read line; do
      # Trim all white spaces in bundle name
      BUNDLE_DEP=`echo $line | awk '{print $1}'`

      case "$BUNDLE_DEP" in
      \#*)
        # This is comment line.
        continue
        ;;
      esac

      if [ "$BUNDLE_DEP" = "" ] ; then
        continue
      elif [ -d $MAIN_SRC_DIR/work/overlay/$BUNDLE_DEP ] ; then
        echo "Overlay bundle '$BUNDLE_DEP' has already been prepared."
      else
        echo "Preparing overlay bundle '$BUNDLE_DEP'."
        cd $SRC_DIR
        ./overlay_build.sh --skip-clean $BUNDLE_DEP
        echo "Overlay bundle '$BUNDLE_DEP' has been prepared."
      fi
    done < $BUNDLE_DIR/bundle_deps
  fi
  # Deal with dependencies END

  BUNDLE_SCRIPT=$BUNDLE_DIR/bundle.sh

  if [ ! -f $BUNDLE_SCRIPT ] ; then
    echo "Error - cannot find overlay bundle script file '$BUNDLE_SCRIPT'."
    exit 1
  fi

  cd $BUNDLE_DIR

  echo "Building overlay bundle '$BUNDLE'."
  $BUNDLE_SCRIPT

  cd $SRC_DIR
done

cd $SRC_DIR
