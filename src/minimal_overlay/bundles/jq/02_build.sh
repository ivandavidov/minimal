#!/bin/sh

set -e

. ../../common.sh
. ../../../settings

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the util-linux source directory which ls finds, e.g. 'util-linux-2.34'.
cd $(ls -d jq-$JQ_VERSION)

if [ -f Makefile ] ; then
  echo "Preparing '$BUNDLE_NAME' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for '$BUNDLE_NAME' has been skipped."
fi

rm -rf $DEST_DIR
mkdir -p $DEST_DIR/bin

echo "Configuring '$BUNDLE_NAME'."

CFLAGS="$CFLAGS" ./configure \
   --with-oniguruma=builtin

echo "Building '$BUNDLE_NAME'."
make -j $NUM_JOBS

echo "Installing '$BUNDLE_NAME'."
make check
make -j $NUM_JOBS install

cp -r jq $DEST_DIR/bin/jq

echo "Reducing '$BUNDLE_NAME' size."
reduce_size $DEST_DIR

install_to_overlay

echo "Bundle '$BUNDLE_NAME' has been installed."

cd $SRC_DIR

