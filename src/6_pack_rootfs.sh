#!/bin/sh

. ./.config

( cd ${SCRIPTDIR}/work/rootfs && find . | cpio -H newc -o | gzip > ${SCRIPTDIR}/work/rootfs.cpio.gz )
