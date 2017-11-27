#!/bin/sh

SRC_DIR=$(pwd)

. ../../common.sh

echo "removing previous work area"
rm -rf $WORK_DIR/overlay/dhcp
mkdir -p $WORK_DIR/overlay/dhcp
cd $WORK_DIR/overlay/dhcp

DESTDIR="$MAIN_SRC_DIR/work/src/minimal_overlay/rootfs"
mkdir -p "$DESTDIR"

install -d -m755 "$DESTDIR/etc"
install -m644 "$SRC_DIR/hosts" "$DESTDIR/etc/hosts"
install -m644 "$SRC_DIR/nsswitch.conf" "$DESTDIR/etc/nsswitch.conf"
install -m644 "$SRC_DIR/resolv.conf" "$DESTDIR/etc/resolv.conf"
install -d -m755 "$DESTDIR/etc/autorun"
install -m755 "$SRC_DIR/01_network.sh" "$DESTDIR/etc/autorun/01_network.sh"
install -m755 "$SRC_DIR/05_rc.dhcp" "$DESTDIR/etc/05_rc.dhcp"

echo "dhcp scripts and libraries have been installed"
