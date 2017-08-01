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
install -m644 "$SRC_DIR/resolv.conf" "$DESTDIR/etc/resolv.conf"
install -d -m755 "$DESTDIR/etc/autorun"
install -m755 "$SRC_DIR/01_network.sh" "$DESTDIR/etc/autorun/01_network.sh"
install -m755 "$SRC_DIR/05_rc.dhcp" "$DESTDIR/etc/05_rc.dhcp"

# These libraries are necessary for the DNS resolving.
install -d -m755 "$DESTDIR/lib"
install -m755 "$SYSROOT/lib/libresolv.so.2" "$DESTDIR/lib/libresolv.so.2"
install -m755 "$SYSROOT/lib/libnss_dns.so.2" "$DESTDIR/lib/libnss_dns.so.2"
strip -g "$DESTDIR/lib/*" 2>/dev/null

echo "dhcp scripts and libraries have been installed"
