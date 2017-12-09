#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** GENERATE ISO (BIOS) BEGIN ***"

FORCE_UEFI=`read_property FORCE_UEFI`

if [ "$FORCE_UEFI" = "true" ] ; then
  echo "Skipping ISO image preparation for BIOS systems."
  exit 0
fi

if [ ! -d $ISOIMAGE ] ; then
  echo "ISO image work folder does not exist. Cannot continue."
  exit 1
fi

# Now we generate the ISO image file.
xorriso -as mkisofs \
  -c boot.cat \
  -b isolinux.bin \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
  -o $SRC_DIR/minimal_linux_live.iso \
  $ISOIMAGE

cd $SRC_DIR

cat << CEOF

  #################################################################
  #                                                               #
  #  ISO image file 'minimal_linux_live.iso' has been generated.  #
  #                                                               #
  #################################################################

CEOF

echo "*** GENERATE ISO (BIOS) END ***"
