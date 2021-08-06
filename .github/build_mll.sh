#!/bin/sh

# This script is supposed to be executed by GitHub workflow.

set -e

sudo apt-get -qq -y install wget make gawk gcc bc xz-utils bison flex xorriso libelf-dev libssl-dev

cd ../src
./build_minimal_linux_live.sh

set +e
