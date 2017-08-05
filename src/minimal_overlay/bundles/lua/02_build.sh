#!/bin/sh

# TODO: compile the gnu readline library for line editing support

SRC_DIR=$(pwd)

. ../../common.sh

cd $WORK_DIR/overlay/lua

DESTDIR="$PWD/lua_installed"

# Change to the Lua source directory which ls finds, e.g. 'lua-5.3.4'.
cd $(ls -d lua-*)

echo "Preparing Lua work area. This may take a while..."
# we install lua to /usr and not to /usr/local so we need to fix luaconf.h so lua can find modules, etc ...
sed -i 's/#define LUA_ROOT.*/#define LUA_ROOT \"\/usr\/\"/' src/luaconf.h
make -j $NUM_JOBS clean
rm -rf $DESTDIR

echo "Building Lua..."
make -j $NUM_JOBS posix CFLAGS="$CFLAGS"

make -j $NUM_JOBS install INSTALL_TOP="$DESTDIR/usr"

echo "Reducing Lua size..."
strip -g $DESTDIR/usr/bin/* 2>/dev/null

ROOTFS="$WORK_DIR/src/minimal_overlay/rootfs"
mkdir -p $ROOTFS/usr/
cp -r $DESTDIR/usr/* $ROOTFS/usr/

echo "Lua has been installed."

cd $SRC_DIR
