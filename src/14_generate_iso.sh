#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** GENERATE ISO BEGIN ***"

if [ ! -d $ISOIMAGE ] ; then
  echo "Cannot locate ISO image work folder. Cannot continue."
  exit 1
fi

cd $ISOIMAGE

# Now we generate 'hybrid' ISO image file which can also be used on
# USB flash drive, e.g. 'dd if=minimal_linux_live.iso of=/dev/sdb'.
xorriso -as mkisofs \
  -isohybrid-mbr $WORK_DIR/syslinux/syslinux-*/bios/mbr/isohdpfx.bin \
  -c boot/syslinux/boot.cat \
  -b boot/syslinux/isolinux.bin \
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

echo "*** GENERATE ISO END ***"
