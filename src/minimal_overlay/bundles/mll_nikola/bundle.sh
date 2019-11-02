#!/bin/sh

set -e

. ../../common.sh

mkdir -p $DEST_DIR/etc/autorun
cp $SRC_DIR/99_nikola.sh $DEST_DIR/etc/autorun
chmod +x $DEST_DIR/etc/autorun/99_nikola.sh

install_to_overlay

# In the end we print message that our bundle has been installed and we return
# to the overlay source folder.
echo "Bundle '$BUNDLE_NAME' has been installed."

cd $SRC_DIR

