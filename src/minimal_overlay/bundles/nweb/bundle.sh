#!/bin/sh

SRC_DIR=$(pwd)

. ../../common.sh

echo "removing previous work area"
rm -rf $WORK_DIR/overlay/nweb
mkdir -p $WORK_DIR/overlay/nweb
cd $WORK_DIR/overlay/nweb

# nweb
$CC $CFLAGS $LDFLAGS $SRC_DIR/nweb23.c -o nweb

# client
#$CC $CFLAGS $LDFLAGS $SRC_DIR/client.c -o client

echo "nweb has been build."

DESTDIR="$MAIN_SRC_DIR/work/src/minimal_overlay/rootfs"

install -d -m755 "$DESTDIR/usr"
install -d -m755 "$DESTDIR/usr/bin"
install -m755 nweb "$DESTDIR/usr/bin/nweb"
#install -m755 client "$DESTDIR/usr/bin/client"
install -d -m755 "$DESTDIR/srv/www" # FHS compliant location
install -m644 "$SRC_DIR/index.html" "$DESTDIR/srv/www/index.html"
install -m644 "$SRC_DIR/favicon.ico" "$DESTDIR/srv/www/favicon.ico"
install -d -m755 "$DESTDIR/etc"
install -d -m755 "$DESTDIR/etc/autorun"
install -m755 "$SRC_DIR/nweb.sh" "$DESTDIR/etc/autorun/90_nweb.sh"

echo "nweb has been installed."
echo "it will be autostarted on boot"
