#!/bin/sh

SRC_DIR=$(pwd)

. ../../common.sh

if [ ! -d $SYSROOT ] ; then
  echo "Cannot continue - GLIBC is missing. Please buld GLIBC first."
  exit 1
fi

echo "Preparing the overlay glibc folder. This may take a while..."
rm -rf $WORK_DIR/overlay/glibc
mkdir -p $WORK_DIR/overlay/glibc/lib

cd $SYSROOT

find . -type l -exec cp {} $WORK_DIR/overlay/glibc/lib \;
echo "All libraries have been copied."

cd $WORK_DIR/overlay/glibc/lib

for FILE_DEL in $(ls *.so)
do
  FILE_KEEP=$(ls $FILE_DEL.*)

  if [ ! "$FILE_KEEP" = "" ] ; then
    # We remove the shorter file and replace it with symbolic link.
    rm $FILE_DEL
    ln -s $FILE_KEEP $FILE_DEL
  fi
done
echo "Duplicate libraries have been replaced with soft links."

strip -g *
echo "All libraries have been optimized for size."

cp -r $WORK_DIR/overlay/glibc/lib $WORK_DIR/src/minimal_overlay/rootfs

echo "All GNU C libraries have been installed."

cd $SRC_DIR
