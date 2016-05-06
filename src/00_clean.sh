#!/bin/sh

echo "*** CLEAN BEGIN ***"

echo "Cleaning up the main work area. This may take a while..."
rm -rf work
mkdir work

# -p stops errors if the directory already exists
mkdir -p source

echo "*** CLEAN END ***"

