#!/bin/sh

. $(dirname $(readlink -f $0 2>/dev/null))/.config

( cd ${SCRIPTDIR}/work/rootfs && find . | cpio -H newc -o | gzip > ${SCRIPTDIR}/work/rootfs.cpio.gz )
