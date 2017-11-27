#!/bin/sh

SRC_DIR=$(pwd)

. ../../common.sh

cd $WORK_DIR/overlay/dropbear

DESTDIR="$PWD/dropbear_installed"

# Change to the Dropbear source directory which ls finds, e.g. 'dropbear-2016.73'.
cd $(ls -d dropbear-*)

echo "Preparing Dropbear work area. This may take a while..."
make -j $NUM_JOBS clean
rm -rf $DESTDIR

echo "Configuring Dropbear..."
./configure \
  --prefix=/usr \
  --disable-zlib \
  --disable-loginfunc
  CFLAGS="$CFLAGS"

echo "Building Dropbear..."
make -j $NUM_JOBS

echo "Installing Dropbear..."
make -j $NUM_JOBS install DESTDIR="$DESTDIR"

mkdir -p $DESTDIR/etc/dropbear

# Create Dropbear SSH configuration BEGIN

for key_type in rsa dss ecdsa; do
  echo "generating $key_type host key"
  $DESTDIR/usr/bin/dropbearkey \
    -t $key_type \
    -f $DESTDIR/etc/dropbear/dropbear_${key_type}_host_key
done

# Create user/group configuration files.
touch $DESTDIR/etc/passwd
touch $DESTDIR/etc/group

# Add group 0 for root.
echo "root:x:0:" \
  > $DESTDIR/etc/group

# Add user root with password 'toor'.
echo "root:AprZpdBUhZXss:0:0:Minimal Root,,,:/root:/bin/sh" \
  > $DESTDIR/etc/passwd

# Create home folder for root user.
mkdir -p $DESTDIR/root

# Create Dropbear SSH configuration END

echo "Reducing Dropbear size..."
strip -g \
  $DESTDIR/usr/bin/* \
  $DESTDIR/usr/sbin/* \
  $DESTDIR/lib/*

ROOTFS=$WORK_DIR/src/minimal_overlay/rootfs

mkdir -p $ROOTFS/usr
cp -r $DESTDIR/etc $ROOTFS
cp -r $DESTDIR/usr/bin $ROOTFS/usr
cp -r $DESTDIR/usr/sbin $ROOTFS/usr
cp -r $DESTDIR/lib $ROOTFS
mkdir -p "$ROOTFS/etc/autorun"
install -m 0755 "$SRC_DIR/20_dropbear.sh" "$ROOTFS/etc/autorun/"

echo "Dropbear has been installed."

cd $SRC_DIR

