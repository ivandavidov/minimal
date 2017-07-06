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

SRC_DIR=$(pwd)

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

rm -rf $WORK_DIR/overlay/java
mkdir -p $WORK_DIR/overlay/java/opt

tar -xvf \
  $JAVA_ARCHIVE \
  -C $WORK_DIR/overlay/java/opt

cd $WORK_DIR/overlay/java/opt
mv $(ls -d *) java

mkdir $WORK_DIR/overlay/java/bin

for FILE in $(ls java/bin)
do
  ln -s ../opt/java/bin/$FILE ../bin/$FILE
done

cp -r $WORK_DIR/overlay/java/* \
  $WORK_DIR/src/minimal_overlay/rootfs

echo "Java has been installed."

cd $SRC_DIR

