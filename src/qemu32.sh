#!/bin/sh

. $(dirname $(readlink -f $0 2>/dev/null))/.config

qemu-system-i386 -cdrom ${SCRIPTDIR}/${TARGET_FILE}
