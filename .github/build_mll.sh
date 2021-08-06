#!/bin/sh

# This script is supposed to be executed by GitHub workflow.

set -e

cd ../src
./build_minimal_linux_live.sh

set +e
