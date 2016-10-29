#!/bin/sh

echo "*** GET MINCS BEGIN ***"

SRC_DIR=$(pwd)

# Grab everything after the '=' character.
DOWNLOAD_URL=$(grep -i ^MINCS_SOURCE_URL .config | cut -f2 -d'=')

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

cd source

rm mincs.zip
# Downloading mincs source
# -c option allows the download to resume
wget -c $DOWNLOAD_URL -O mincs.zip

# Delete folder with previously extracted mincs
rm -rf ../work/mincs
mkdir ../work/mincs

# Extract MINCS to folder 'mincs'
# Full path will be something like 'work/mincs/mincs-master'
unzip mincs.zip -x -d ../work/mincs

# Make simple mode as default
cd ../work/mincs
cd $(ls -d *)
sed -i 's/set -e/set -e;MINC_OPT_SIMPLE=y/g' libexec/minc-exec 

cd $SRC_DIR

echo "*** GET MINCS END ***"

