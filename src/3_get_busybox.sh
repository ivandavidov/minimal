#!/bin/sh

. ./.config

# Grab everything after the '=' character
DOWNLOAD_URL=${BUSYBOX_SOURCE_URL}

# Grab everything after the last '/' character
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

# Downloading busybox source
# -c option allows the download to resume
wget -c -N --progress=bar:force --content-disposition --trust-server-names -P ${SCRIPTDIR}/source ${DOWNLOAD_URL}

# Delete folder with previously extracted busybox
mkdir -p ${SCRIPTDIR}/work/busybox
rm -rf ${SCRIPTDIR}/work/busybox/busybox-*

# Extract busybox to folder 'busybox'
# Full path will be something like 'work/busybox/busybox-1.23.1'
tar -xvf ${SCRIPTDIR}/source/${ARCHIVE_FILE} -C ${SCRIPTDIR}/work/kernel
