#!/bin/sh

set -e

. ../../common.sh

mkdir -p $DEST_DIR/etc
echo 'root::0:0:Superuser:/:/bin/sh' > $DEST_DIR/etc/passwd

cd $SRC_DIR
