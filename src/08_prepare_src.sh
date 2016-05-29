#!/bin/sh

echo "*** PREPARE SRC BEGIN ***"

SRC_DIR=$(pwd)

cd work

echo "Preparing source files and folders. This may take a while..."

# Remove old sources (if they exist)
rm -rf src
mkdir src

# Copy all source files and folders to 'work/src'.
cp ../*.sh src
cp ../.config src
cp ../README src
cp ../*.txt src
cp -r ../minimal_rootfs src
cp -r ../minimal_overlay src
cp -r ../minimal_config src

# Delete the '.gitignore' files which we use in order to keep track of otherwise
# empty folders.
find * -type f -name '.gitignore' -exec rm {} +

echo "Source files and folders have been prepared."

cd $SRC_DIR

echo "*** PREPARE SRC END ***"

