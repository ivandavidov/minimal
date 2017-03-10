#!/bin/sh
SRC_DIR=$(PWD)

mkdir -p ../../../work/src/minimal_overlay/rootfs/

cd ../../../work/src/minimal_overlay/rootfs/

# download static-get
wget -O usr/bin/static-get http://raw.githubusercontent.com/minos-org/minos-static/master/static-get
chmod +rx usr/bin/static-get
