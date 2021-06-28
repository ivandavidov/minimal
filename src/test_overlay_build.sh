#!/bin/sh

# This script tests the build process of each overlay bundle. The idea is to
# find failing bundles (wrong or outdated build dependencies, broken download
# links, other simple and stupid failures) and take action accordingly. This
# script doesn't test the actual functionality of the overlay bundles.

set -ex

cd minimal_overlay
for bundle in `ls bundles` ; do
  echo "******************************"
  echo "***** $bundle TEST BEGIN *****"
  echo "******************************"
  ./overlay_clean.sh
  ./overlay_build.sh $bundle
  echo "****************************"
  echo "***** $bundle TEST END *****"  
  echo "****************************"
done

