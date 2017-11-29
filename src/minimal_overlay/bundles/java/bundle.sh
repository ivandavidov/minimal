#!/bin/sh

# This script installs Oracle's JRE or JDK from already downloaded 'tar.gz'
# archive. Oracle's license doesn't allow direct downloads, so you need to do
# the following:
#
# 1) Download JRE or JDK from http://oracle.com
# 2) Add the following property in the '.config' file:
#
#      JAVA_ARCHIVE=/absolute/path/to/java/archive.tar.gz
#
#    Example:
#
#      JAVA_ARCHIVE=/home/ivan/Downloads/jdk-8u102-linux-x64.tar.gz
#
# 3) Run this script. Note that the script will fail with error message if the
#    'JAVA_ARCHIVE' property is not set or if it points to invalid file.

set -e

. ../../common.sh

# Read the 'JAVA_ARCHIVE' property from '.config'
JAVA_ARCHIVE="$(grep -i ^JAVA_ARCHIVE $MAIN_SRC_DIR/.config | cut -f2 -d'=')"

if [ "$JAVA_ARCHIVE" = "" ] ; then
  echo "ERROR: configuration property 'JAVA_ARCHIVE' is not set."
  exit 1
elif [ ! -f "$JAVA_ARCHIVE" ] ; then
  echo "ERROR: configuration property 'JAVA_ARCHIVE' points to nonexistent file."
  exit 1
fi

rm -rf $DEST_DIR
mkdir -p $DEST_DIR/opt

tar -xvf \
  $JAVA_ARCHIVE \
  -C $DEST_DIR/opt

cd $DEST_DIR/opt
mv $(ls -d *) java

mkdir $DEST_DIR/bin

for FILE in $(ls java/bin)
do
  ln -s ../opt/$BUNDLE_NAME/bin/$FILE ../bin/$FILE
done

cp -r $DEST_DIR/* $OVERLAY_ROOTFS

echo "Java has been installed."

cd $SRC_DIR
