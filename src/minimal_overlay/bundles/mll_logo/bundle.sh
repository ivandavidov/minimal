#!/bin/sh

set -e

. ../../common.sh

# Uncomment this to regenerate the MLL logo. The file MLL_LOGO
# has to be existing in advance and it is your responsibility
# to provide it. It is also your responsibility to set your
# development environemnt if some of the commands are missing.
# Maximum allowed logo size is 80x80. Some useful resources:
#
# http://www.armadeus.org/wiki/index.php?title=Linux_Boot_Logo
# http://www.articleworld.org/index.php/How_to_change_the_Linux_penguin_boot_logo
#
#MLL_LOGO=/mnt/hgfs/vm_shared/tux3.ppm
#rm -rf $WORK_DIR/logo
#mkdir -p $WORK_DIR/logo
#cp $MLL_LOGO $WORK_DIR/logo/mll_logo.ppm
#ppmquant 224 $WORK_DIR/logo/mll_logo.ppm > $WORK_DIR/logo/mll_logo_224.ppm
#pnmnoraw $WORK_DIR/logo/mll_logo_224.ppm > $SRC_DIR/mll_logo_ascii_224.ppm

# Read the 'USE_BOOT_LOGO' property from '.config'
USE_BOOT_LOGO=`read_property USE_BOOT_LOGO`

if [ ! "$USE_BOOT_LOGO" = "true" ] ; then
  echo "Boot logo has been disabled. No need to generate MLL boot logo."
  exit 0
fi

if [ ! -f $WORK_DIR/kernel/linux-*/.config ] ; then
  echo "Kernel configuration does not exist. Cannot continue."
  exit 1
fi

if [ ! -f $WORK_DIR/kernel/kernel_installed/kernel ] ; then
  echo "Kernel image does not exist. Cannot continue."
  exit 1
fi

rm -f `ls -d $WORK_DIR/kernel/linux-*`/drivers/video/logo/logo_linux_clut224.ppm
cp $SRC_DIR/mll_logo_ascii_224.ppm `ls -d $WORK_DIR/kernel/linux-*`/drivers/video/logo/logo_linux_clut224.ppm
touch `ls -d $WORK_DIR/kernel/linux-*`/drivers/video/logo/logo_linux_clut224.ppm

cd `ls -d $WORK_DIR/kernel/linux-*`

make bzImage -j 4

cp arch/x86/boot/bzImage $WORK_DIR/kernel/kernel_installed/kernel

cd $SRC_DIR
