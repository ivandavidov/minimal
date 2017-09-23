#!/bin/sh

SRC_DIR=$(pwd)

. ../../common.sh

cd $WORK_DIR/overlay/openjdk
mv `ls -d *` openjdk

mkdir opt
mv openjdk opt

mkdir $WORK_DIR/overlay/openjdk/bin
cd $WORK_DIR/overlay/openjdk/bin

for FILE in $(ls ../opt/openjdk/bin)
do
  ln -s ../opt/openjdk/bin/$FILE $FILE
done

cp -r $WORK_DIR/overlay/openjdk/* \
  $WORK_DIR/src/minimal_overlay/rootfs

echo "Open JDK has been installed."

cd $SRC_DIR

