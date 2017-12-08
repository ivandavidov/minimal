#!/bin/sh

set -e

. ../../common.sh

echo "Removing previous work area."
rm -rf $WORK_DIR/overlay/$BUNDLE_NAME
mkdir -p $WORK_DIR/overlay/$BUNDLE_NAME
cd $WORK_DIR/overlay/$BUNDLE_NAME

install -d -m755 "$OVERLAY_ROOTFS/etc"
install -m644 "$SRC_DIR/hosts" "$OVERLAY_ROOTFS/etc/hosts"
install -m644 "$SRC_DIR/nsswitch.conf" "$OVERLAY_ROOTFS/etc/nsswitch.conf"
install -m644 "$SRC_DIR/resolv.conf" "$OVERLAY_ROOTFS/etc/resolv.conf"
install -d -m755 "$OVERLAY_ROOTFS/etc/autorun"
install -m755 "$SRC_DIR/20_network.sh" "$OVERLAY_ROOTFS/etc/autorun/20_network.sh"
install -m755 "$SRC_DIR/05_rc.dhcp" "$OVERLAY_ROOTFS/etc/05_rc.dhcp"

echo "DHCP scripts and libraries have been installed."
