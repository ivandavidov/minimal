#!/bin/sh

set -e

. ../../common.sh

mkdir "$OVERLAY_ROOTFS/sbin" || true

install -m755 "$SRC_DIR/bin/neigh" "$OVERLAY_ROOTFS/sbin/neigh"
install -m755 "$SRC_DIR/bin/15_bring_up_everything.sh" "$OVERLAY_ROOTFS/etc/autorun/15_bring_up_everything.sh"
install -m755 "$SRC_DIR/bin/40_auto_lldpd.sh" "$OVERLAY_ROOTFS/etc/autorun/40_auto_lldpd.sh"
install -m755 "$SRC_DIR/bin/99_auto_neighbors.sh" "$OVERLAY_ROOTFS/etc/autorun/99_auto_neighbors.sh"

cd $SRC_DIR
