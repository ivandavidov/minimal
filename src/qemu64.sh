#!/bin/sh

. $(dirname $(readlink -f $0 2>/dev/null))/.config

qemu-system-x86_64 -cdrom ${SCRIPTDIR}/${TARGET_FILE}
