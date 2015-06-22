#!/bin/sh

. $(dirname $(readlink -f $0 2>/dev/null))/.config

# Downloading busybox source
wget -c -N --progress=bar:force --content-disposition --trust-server-names -P ${SCRIPTDIR}/source "${BUSYBOX_SOURCE_URL}"

# Delete folder with previously extracted busybox
mkdir -p ${SCRIPTDIR}/work/busybox
rm -rf ${SCRIPTDIR}/work/busybox/busybox-*

# Extract busybox to folder 'busybox'
# Full path will be something like 'work/busybox/busybox-1.23.1'
tar -xvf ${SCRIPTDIR}/source/${BUSYBOX_FILE} -C ${SCRIPTDIR}/work/kernel
