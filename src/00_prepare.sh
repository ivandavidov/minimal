#!/bin/sh

echo "Cleaning up the work area. This may take a while..."
rm -rf work
mkdir work

# -p stops errors if the directory already exists
mkdir -p source

