#!/bin/sh

# needed for iso creation
sudo aptitude install -y -q=2 wget make gcc bc syslinux genisoimage 7z
# needed for make menuconfig
#sudo aptitude install -y -q=2 libncurses5-dev libncursesw5-dev

. ./.config

set -ve

. ${SCRIPTDIR}/0_prepare.sh
. ${SCRIPTDIR}/1_get_kernel.sh
. ${SCRIPTDIR}/2_build_kernel.sh
. ${SCRIPTDIR}/3_get_busybox.sh
. ${SCRIPTDIR}/4_build_busybox.sh
. ${SCRIPTDIR}/5_generate_rootfs.sh
. ${SCRIPTDIR}/6_pack_rootfs.sh
. ${SCRIPTDIR}/7_generate_iso.sh
