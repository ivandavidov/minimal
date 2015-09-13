#!/bin/sh

# Grab everything after the '=' character.
DOWNLOAD_URL=$(grep -i TOYBOX_SOURCE_URL .config | cut -f2 -d'=')

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

cd source

# Downloading ToyBox source.
# -c option allows the download to resume.
wget -c $DOWNLOAD_URL

# Delete folder with previously extracted ToyBox.
rm -rf ../work/toybox
mkdir ../work/toybox

# Extract toybox to folder 'toybox'.
# Full path will be something like 'work/toybox/toybox-0.6.0'.
tar -xvf $ARCHIVE_FILE -C ../work/toybox

cd ..

