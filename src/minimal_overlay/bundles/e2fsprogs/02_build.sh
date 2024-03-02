#!/bin/sh

set -e

. ../../common.sh
. ../../../settings

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the util-linux source directory which ls finds, e.g. 'util-linux-2.34'.
cd $(ls -d e2fsprogs-$E2FSPROGS_VERSION)

if [ -f Makefile ] ; then
  echo "Preparing '$BUNDLE_NAME' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for '$BUNDLE_NAME' has been skipped."
fi

rm -rf $DEST_DIR
mkdir -p $DEST_DIR/bin
mkdir -p $DEST_DIR/lib

echo "Configuring '$BUNDLE_NAME'."

CFLAGS="$CFLAGS" ./configure --prefix=/usr           \
             --bindir=/bin \
             --sysconfdir=/etc       \
             --enable-elf-shlibs     \
             #--disable-libblkid      \
             #--disable-libuuid       \
             #--disable-uuidd         \
             #--disable-fsck

echo "Building '$BUNDLE_NAME'."
make -j $NUM_JOBS

echo "Installing '$BUNDLE_NAME'."
make check
#make -j $NUM_JOBS install

cp -r misc/mke2fs $DEST_DIR/bin/mke2fs
cp -r lib/libext2fs.so.2.4 $DEST_DIR/lib/libext2fs.so.2.4
cp -r lib/libext2fs.so.2 $DEST_DIR/lib/libext2fs.so.2
cp -r lib/libext2fs.so $DEST_DIR/lib/libext2fs.so
cp -r lib/libcom_err.so.2.1 $DEST_DIR/lib/libcom_err.so.2.1
cp -r lib/libcom_err.so.2 $DEST_DIR/lib/libcom_err.so.2
cp -r lib/libcom_err.so $DEST_DIR/lib/libcom_err.so
cp -r lib/libe2p.so.2.3 $DEST_DIR/lib/libe2p.so.2.3
cp -r lib/libe2p.so.2 $DEST_DIR/lib/libe2p.so.2
cp -r lib/libe2p.so $DEST_DIR/lib/libe2p.so
cd $DEST_DIR/bin
ln mke2fs mkfs.ext2
ln mke2fs mkfs.ext3
ln mke2fs mkfs.ext4
cd $(ls -d e2fsprogs-$E2FSPROGS_VERSION)

echo "Reducing '$BUNDLE_NAME' size."
reduce_size $DEST_DIR

install_to_overlay bin
install_to_overlay lib

echo "Bundle '$BUNDLE_NAME' has been installed."

cd $SRC_DIR

