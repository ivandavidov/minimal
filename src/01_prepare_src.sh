#!/bin/sh

SRC_DIR=$(pwd)

cd work

rm -rf src
mkdir src

# Copy all source files and folders to 'work/src'.
cp ../*.sh src
cp ../.config src
cp ../README src
cp ../*.txt src
cp -r ../09_generate_rootfs src
cp -r ../12_generate_iso src
cp -r ../config_predefined src

# Delete the '.gitignore' files which we use in order to keep track of otherwise
# empty folders.
find * -type f -name '.gitignore' -exec rm {} +

echo "Source files and folders have been prepared."

cd $SRC_DIR

