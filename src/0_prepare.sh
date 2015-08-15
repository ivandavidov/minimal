#!/bin/sh

. $(dirname $(readlink -f $0 2>/dev/null))/.config

rm -rf ${SCRIPTDIR}/work
mkdir -p ${SCRIPTDIR}/work ${SCRIPTDIR}/source
