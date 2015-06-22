#!/bin/sh

. $(dirname $(readlink -f $0 2>/dev/null))/.config

rm -f ${SCRIPTDIR}/${TARGETFILE}

# Generate the ISO image with optimization for "parallel jobs" = "number of processors"
make isoimage FDINITRD=${SCRIPTDIR}/work/rootfs.cpio.gz -j $(grep -c ^processor /proc/cpuinfo)

cp ${SCRIPTDIR}/work/kernel/linux-${KERNEL_VERSION}/arch/x86/boot/image.iso ${SCRIPTDIR}/${TARGETFILE}
