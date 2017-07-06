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
  --disable-loginfunc \
  CC="$CC" \
  CFLAGS="$CFLAGS" \
  LDFLAGS="$LDFLAGS"

echo "Building Dropbear..."
make -j $NUM_JOBS

echo "Installing Dropbear..."
make -j $NUM_JOBS install DESTDIR="$DESTDIR"

mkdir -p $DESTDIR/lib

# Copy all dependent GLIBC libraries.
cp $SYSROOT/lib/libnsl.so.1 $DESTDIR/lib
cp $SYSROOT/lib/libnss_compat.so.2 $DESTDIR/lib
cp $SYSROOT/lib/libutil.so.1 $DESTDIR/lib
cp $SYSROOT/lib/libcrypt.so.1 $DESTDIR/lib

mkdir -p $DESTDIR/etc/dropbear

# Create Dropbear SSH configuration BEGIN

# Create RSA key.
$DESTDIR/usr/bin/dropbearkey \
  -t rsa \
  -f $DESTDIR/etc/dropbear/dropbear_rsa_host_key 

# Create DSS key.
$DESTDIR/usr/bin/dropbearkey \
  -t dss \
  -f $DESTDIR/etc/dropbear/dropbear_dss_host_key 

# Create ECDSA key.
$DESTDIR/usr/bin/dropbearkey \
  -t ecdsa \
  -f $DESTDIR/etc/dropbear/dropbear_ecdsa_host_key 

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
  $DESTDIR/usr/lib/* \
  $DESTDIR/lib/*

cp -r \
  $DESTDIR/etc \
  $DESTDIR/usr/bin \
  $DESTDIR/usr/sbin \
  $DESTDIR/usr/lib \
  $DESTDIR/lib \
  $WORK_DIR/src/minimal_overlay/rootfs

echo "Dropbear has been installed."

cd $SRC_DIR

