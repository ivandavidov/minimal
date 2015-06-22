#!/bin/sh

. $(dirname $(readlink -f $0 2>/dev/null))/.config

# Downloading kernel file
wget -c -N --progress=bar:force --content-disposition --trust-server-names -P ${SCRIPTDIR}/source "${KERNEL_SOURCE_URL}"

# Delete folder with previously extracted kernel
mkdir -p ${SCRIPTDIR}/work/kernel
rm -rf ${SCRIPTDIR}/work/kernel/linux-*

# Extract kernel to folder 'kernel'
# Full path will be something like 'work/kernel/linux-3.16.1'
tar -xvf ${SCRIPTDIR}/source/${KERNEL_FILE} -C ${SCRIPTDIR}/work/kernel
