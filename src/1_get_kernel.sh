#!/bin/sh

. $(dirname $(readlink -f $0 2>/dev/null))/.config

# Grab everything after the '=' character
DOWNLOAD_URL=${KERNEL_SOURCE_URL}

# Grab everything after the last '/' character
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

# Downloading kernel file
wget -c -N --progress=bar:force --content-disposition --trust-server-names -P ${SCRIPTDIR}/source "$DOWNLOAD_URL"

# Delete folder with previously extracted kernel
mkdir -p ${SCRIPTDIR}/work/kernel
rm -rf ${SCRIPTDIR}/work/kernel/linux-*

# Extract kernel to folder 'kernel'
# Full path will be something like 'kernel\linux-3.16.1'
tar -xvf ${SCRIPTDIR}/source/${ARCHIVE_FILE} -C ${SCRIPTDIR}/work/kernel
