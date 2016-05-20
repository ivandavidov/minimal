#!/bin/sh

SRC_DIR=$(pwd)

if [ ! -d $SRC_DIR/work/glibc/glibc_prepared ] ; then
  echo "Cannot continue - Dropbear SSH depends on GLIBC. Please buld GLIBC first."
  exit 1
fi

cd work/overlay/dropbear

# Change to the Dropbear source directory which ls finds, e.g. 'dropbear-2016.73'.
cd $(ls -d dropbear-*)

echo "Preparing Dropbear work area. This may take a while..."
make clean 2>/dev/null

rm -rf ../dropbear_installed

echo "Configuring Dropbear..."
./configure \
  --prefix=$SRC_DIR/work/overlay/dropbear/dropbear_installed \
  --disable-zlib \
  --disable-loginfunc \
  CFLAGS="-Os -s -fno-stack-protector -U_FORTIFY_SOURCE"

echo "Building Dropbear..."
make

echo "Installing Dropbear..."
make install

mkdir -p ../dropbear_installed/lib

# Copy all dependent GLIBC libraries.
cp $SRC_DIR/work/glibc/glibc_prepared/lib/libnsl.so.1 ../dropbear_installed/lib
cp $SRC_DIR/work/glibc/glibc_prepared/lib/libnss_compat.so.2 ../dropbear_installed/lib
cp $SRC_DIR/work/glibc/glibc_prepared/lib/libutil.so.1 ../dropbear_installed/lib
cp $SRC_DIR/work/glibc/glibc_prepared/lib/libcrypt.so.1 ../dropbear_installed/lib

mkdir -p ../dropbear_installed/etc/dropbear

# Create Dropbear SSH configuration BEGIN

# Create RSA key.
../dropbear_installed/bin/dropbearkey \
  -t rsa \
  -f ../dropbear_installed/etc/dropbear/dropbear_rsa_host_key 

# Create DSS key.
../dropbear_installed/bin/dropbearkey \
  -t dss \
  -f ../dropbear_installed/etc/dropbear/dropbear_dss_host_key 

# Create ECDSA key.
../dropbear_installed/bin/dropbearkey \
  -t ecdsa \
  -f ../dropbear_installed/etc/dropbear/dropbear_ecdsa_host_key 

# Create user/group configuration files.
touch ../dropbear_installed/etc/passwd
touch ../dropbear_installed/etc/group

# Add group 0 for root.
echo "root:x:0:" \
  > ../dropbear_installed/etc/group

# Add user root with password 'toor'.
echo "root:AprZpdBUhZXss:0:0:Minimal Root,,,:/root:/bin/sh" \
  > ../dropbear_installed/etc/passwd

# Create home folder for root user.
mkdir -p ../dropbear_installed/root

# Create Dropbear SSH configuration END

echo "Reducing Dropbear size..."
strip -g \
  ../dropbear_installed/bin/* \
  ../dropbear_installed/sbin/* \
  ../dropbear_installed/lib/*

cp -r \
  ../dropbear_installed/etc \
  ../dropbear_installed/bin \
  ../dropbear_installed/sbin \
  ../dropbear_installed/lib \
  $SRC_DIR/work/src/minimal_overlay

echo "Dropbear has been installed."

cd $SRC_DIR

