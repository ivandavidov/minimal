#!/bin/sh

set -e

echo "*** GENERATE ISO BEGIN ***"

SRC_DIR=$(pwd)

if [ ! -d $SRC_DIR/work/isoimage ] ; then
  echo "Cannot locate ISO image work folder. Cannot continue."
  exit 1
fi

cd $SRC_DIR/work/isoimage

# Now we generate the ISO image file.
xorriso \
  -as mkisofs \
  -R \
  -r \
  -o ../minimal_linux_live.iso \
  -b isolinux.bin \
  -c boot.cat \
  -input-charset UTF-8 \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  ./

# Copy the ISO image to the root project folder.
cp ../minimal_linux_live.iso ../../

cd $SRC_DIR

cat << CEOF

  #################################################################
  #                                                               #
  #  ISO image file 'minimal_linux_live.iso' has been generated.  #
  #                                                               #
  #################################################################

CEOF

echo "*** GENERATE ISO END ***"
