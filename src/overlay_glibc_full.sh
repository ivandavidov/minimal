#!/bin/sh

set -e

SRC_DIR=$(pwd)

if [ ! -d $SRC_DIR/work/glibc/glibc_prepared ] ; then
  echo "Cannot continue - GLIBC is missing. Please buld GLIBC first."
  exit 1
fi

echo "Preparing the overlay glibc folder. This may take a while..."
rm -rf work/overlay/glibc
mkdir -p work/overlay/glibc/lib

cd work/glibc/glibc_prepared/lib

find . -type l -exec cp {} $SRC_DIR/work/overlay/glibc/lib \;
echo "All libraries have been copied."

cd $SRC_DIR/work/overlay/glibc/lib

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

cp -r $SRC_DIR/work/overlay/glibc/lib $SRC_DIR/work/src/minimal_overlay
echo "All libraries have been installed."

cd $SRC_DIR

