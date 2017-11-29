#!/bin/sh

# TODO: compile the gnu readline library for line editing support

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the Lua source directory which ls finds, e.g. 'lua-5.3.4'.
cd $(ls -d lua-*)

echo "Preparing Lua work area. This may take a while."
# we install lua to /usr and not to /usr/local so we need to fix luaconf.h so lua can find modules, etc.
sed -i 's/#define LUA_ROOT.*/#define LUA_ROOT \"\/usr\/\"/' src/luaconf.h
make -j $NUM_JOBS clean
rm -rf $DEST_DIR

echo "Building Lua."
make -j $NUM_JOBS posix CFLAGS="$CFLAGS"

make -j $NUM_JOBS install INSTALL_TOP="$DEST_DIR/usr"

echo "Reducing Lua size."
strip -g $DEST_DIR/usr/bin/* 2>/dev/null

mkdir -p $OVERLAY_ROOTFS/usr/
cp -r $DEST_DIR/usr/* $OVERLAY_ROOTFS/usr/

echo "Lua has been installed."

cd $SRC_DIR
