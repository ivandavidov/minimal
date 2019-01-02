#!/bin/sh

# This script is supposed to be executed by Travis CI.

set -e

cd ../src

echo "`date` | *** MLL Docker test - BEGIN ***"

docker import mll_image.tgz minimal-linux-live:latest
docker run minimal-linux-live /bin/cat /etc/motd

echo "`date` | *** MLL Docker test - END ***"

cat << CEOF

  #########################
  #                       #
  #  Docker test passed.  #
  #                       #
  #########################

CEOF

set +e

