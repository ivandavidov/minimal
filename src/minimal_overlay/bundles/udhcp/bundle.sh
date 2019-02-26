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

# also add udhcpc ip config script
install -D -m755 "$(ls $WORK_DIR/busybox/busybox-*/examples/udhcp/simple.script)" "$OVERLAY_ROOTFS/usr/share/udhcpc/default.script"

echo "DHCP scripts and libraries have been installed."
