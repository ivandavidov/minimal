#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the Dropbear source directory which ls finds, e.g. 'dropbear-2016.73'.
cd $(ls -d dropbear-*)

echo "Preparing Dropbear work area. This may take a while."
make -j $NUM_JOBS clean
rm -rf $DEST_DIR

echo "Configuring Dropbear."
./configure \
  --prefix=/usr \
  --disable-zlib \
  --disable-loginfunc
  CFLAGS="$CFLAGS"

echo "Building Dropbear."
make -j $NUM_JOBS

echo "Installing Dropbear."
make -j $NUM_JOBS install DESTDIR="$DEST_DIR"

mkdir -p $DEST_DIR/etc/dropbear

# Create Dropbear SSH configuration BEGIN

for key_type in rsa dss ecdsa; do
  echo "generating $key_type host key"
  $DEST_DIR/usr/bin/dropbearkey \
    -t $key_type \
    -f $DEST_DIR/etc/dropbear/dropbear_${key_type}_host_key
done

# Create user/group configuration files.
touch $DEST_DIR/etc/passwd
touch $DEST_DIR/etc/group

# Add group 0 for root.
echo "root:x:0:" \
  > $DEST_DIR/etc/group

# Add user root with password 'toor'.
echo "root:AprZpdBUhZXss:0:0:Minimal Root,,,:/root:/bin/sh" \
  > $DEST_DIR/etc/passwd

# Create home folder for root user.
mkdir -p $DEST_DIR/root

# Create Dropbear SSH configuration END

echo "Reducing Dropbear size."
strip -g \
  $DEST_DIR/usr/bin/* \
  $DEST_DIR/usr/sbin/* \
  $DEST_DIR/lib/*

mkdir -p $OVERLAY_ROOTFS/usr
cp -r $DEST_DIR/etc $OVERLAY_ROOTFS
cp -r $DEST_DIR/usr/bin $OVERLAY_ROOTFS/usr
cp -r $DEST_DIR/usr/sbin $OVERLAY_ROOTFS/usr
cp -r $DEST_DIR/lib $OVERLAY_ROOTFS
mkdir -p "$OVERLAY_ROOTFS/etc/autorun"
install -m 0755 "$SRC_DIR/20_dropbear.sh" "$OVERLAY_ROOTFS/etc/autorun/"

echo "Dropbear has been installed."

cd $SRC_DIR
