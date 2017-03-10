#!/bin/sh
SRC_DIR=$(pwd)

mkdir -p ../../../work/src/minimal_overlay/rootfs/usr/bin

cd ../../../work/src/minimal_overlay/rootfs/

# download static-get
wget -O usr/bin/static-get http://raw.githubusercontent.com/minos-org/minos-static/master/static-get
chmod +rx usr/bin/static-get
