#!/bin/sh

echo "*** GET DOCKER BEGIN ***"

SRC_DIR=$(pwd)

# Grab everything after the '=' character.
DOWNLOAD_URL=$(grep -i ^DOCKER_BINARIES_URL .config | cut -f2 -d'=')

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

cd source

rm docker.tar.gz

wget -c $DOWNLOAD_URL -O docker.tar.gz

tar -xvf docker.tar.gz

cd $SRC_DIR

echo "*** GET DOCKER END ***"
