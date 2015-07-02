#!/bin/sh

. $(dirname $(readlink -f $0 2>/dev/null))/.config

if [ "$(uname -m)" = "x86_64" ] ; then
	BINARY="qemu-system-x86_64"
else
	BINARY="qemu-system-i386"
fi

${BINARY} -cdrom ${SCRIPTDIR}/${TARGETFILE}
