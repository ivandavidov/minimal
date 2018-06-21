#!/bin/sh

# This script is supposed to be executed by Travis CI.

set -e

cd ../src

apt-get -qq -y install wget make gawk gcc bc xz-utils bison flex xorriso libelf-dev libssl-dev

PREFIXES="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16"

for PREFIX in ${PREFIXES}
do
  SCRIPTS=`ls ${PREFIX}_*.sh`
  for SCRIPT in ${SCRIPTS}
  do
    echo "`date` | Running script '${SCRIPT}'."
    set +e
    ./${SCRIPT} > /tmp/mll.log 2>&1
    set -e

    if [ "$?" = "0" ] ; then
      echo "`date` | Success."
    else
      echo "`date` | !!! FAILURE !!!"
      tail -n 1000 /tmp/mll.log
      exit 1
    fi
  done
done

cat << CEOF

  ######################
  #                    #
  #  MLL build is OK.  #
  #                    #
  ######################

CEOF

set +e
