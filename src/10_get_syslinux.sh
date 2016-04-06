#!/bin/sh

# Grab everything after the '=' character.
DOWNLOAD_URL=$(grep -i SYSLINUX_SOURCE_URL .config | cut -f2 -d'=')

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

cd source

# Downloading Syslinux file.
# -c option allows the download to resume.
wget -c $DOWNLOAD_URL

# Delete folder with previously extracted Syslinux.
rm -rf ../work/syslinux
mkdir ../work/syslinux

# Extract Syslinux to folder 'work/syslinux'.
# Full path will be something like 'work/syslinux/syslinux-6.03'.
tar -xvf $ARCHIVE_FILE -C ../work/syslinux

cd ..

