#!/bin/sh

set -e

. ../../common.sh

echo "Removing previous work area."
rm -rf $WORK_DIR/overlay/$BUNDLE_NAME
mkdir -p $WORK_DIR/overlay/$BUNDLE_NAME
cd $WORK_DIR/overlay/$BUNDLE_NAME

# nweb
gcc $CFLAGS $SRC_DIR/nweb23.c -o nweb

echo "'nweb' has been compiled."

install -d -m755 "$OVERLAY_ROOTFS/usr"
install -d -m755 "$OVERLAY_ROOTFS/usr/bin"
install -m755 nweb "$OVERLAY_ROOTFS/usr/bin/nweb"
install -d -m755 "$OVERLAY_ROOTFS/srv/www" # FHS compliant location
install -m644 "$SRC_DIR/index.html" "$OVERLAY_ROOTFS/srv/www/index.html"
install -m644 "$SRC_DIR/favicon.ico" "$OVERLAY_ROOTFS/srv/www/favicon.ico"
install -d -m755 "$OVERLAY_ROOTFS/etc"
install -d -m755 "$OVERLAY_ROOTFS/etc/autorun"
install -m755 "$SRC_DIR/90_nweb.sh" "$OVERLAY_ROOTFS/etc/autorun/90_nweb.sh"

echo "Bundle 'nweb' has been installed."
echo "It will be autostarted on boot."
