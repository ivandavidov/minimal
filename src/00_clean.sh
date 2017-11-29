#!/bin/sh
set -e

echo "*** CLEAN BEGIN ***"

echo "Cleaning up the main work area. This may take a while."
rm -rf work
mkdir work
mkdir -p source

echo "*** CLEAN END ***"

