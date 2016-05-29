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
#      JAVA_ARCHIVE=/home/myself/Downloads/jdk-8u91-linux-x64.tar.gz
#
# 3) Run this script. Note that the script will fail with error message if the
#    'JAVA_ARCHIVE' property is not set or if it points to invalid file.

SRC_DIR=$(pwd)

# Read the 'JAVA_ARCHIVE' property from '.config'
JAVA_ARCHIVE="$(grep -i ^JAVA_ARCHIVE .config | cut -f2 -d'=')"

if [ "$JAVA_ARCHIVE" = "" ] ; then
  echo "ERROR: configuration property 'JAVA_ARCHIVE' is not set."
  exit 1
elif [ ! -f "$JAVA_ARCHIVE" ] ; then
  echo "ERROR: configuration property 'JAVA_ARCHIVE' points to non existent file."
  exit 1
fi

rm -rf $SRC_DIR/work/overlay/java
mkdir -p $SRC_DIR/work/overlay/java/opt

tar -xvf \
  $JAVA_ARCHIVE \
  -C $SRC_DIR/work/overlay/java/opt

cd $SRC_DIR/work/overlay/java/opt
mv $(ls -d *) java

mkdir $SRC_DIR/work/overlay/java/bin

for FILE in $(ls java/bin)
do
  ln -s ../opt/java/bin/$FILE ../bin/$FILE
done

cp -r $SRC_DIR/work/overlay/java/* $SRC_DIR/work/src/minimal_overlay

echo "Java has been installed."

cd $SRC_DIR

