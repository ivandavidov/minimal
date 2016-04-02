#!/bin/sh

# Grab everything after the '=' character.
DOWNLOAD_URL=$(grep -i GLIBC_SOURCE_URL .config | cut -f2 -d'=')

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

cd source

# Downloading glibc file.
# -c option allows the download to resume.
wget -c $DOWNLOAD_URL

# Delete folder with previously extracted glibc.
rm -rf ../work/glibc
mkdir ../work/glibc

# Extract glibc to folder 'work/glibc'.
# Full path will be something like 'work/glibc/glibc-2.23'.
tar -xvf $ARCHIVE_FILE -C ../work/glibc

cd ..

