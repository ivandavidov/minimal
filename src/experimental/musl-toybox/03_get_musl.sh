#!/bin/sh

# Grab everything after the '=' character
DOWNLOAD_URL=$(grep -i MUSL_SOURCE_URL .config | cut -f2 -d'=')

# Grab everything after the last '/' character
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

cd source

# Downloading musl file
# -c option allows the download to resume
wget -c $DOWNLOAD_URL

# Delete folder with previously extracted musl
rm -rf ../work/musl
mkdir ../work/musl

# Extract musl to folder 'work/musl'
# Full path will be something like 'work/musl/musl-1.1.11'
tar -xvf $ARCHIVE_FILE -C ../work/musl

cd ..

