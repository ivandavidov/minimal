#!/bin/sh

# A minimal script which writes the produced iso into usb
# with the help of the dd command

set -e

. ./common.sh

ISO_NAME=$SRC_DIR/minimal_linux_live.iso

if ! [ -e $ISO_NAME ]; then 
	echo "You have to build the iso before running this script!"
	exit 1

elif [ "$#" -ne 1 ]; then
	echo "Invocation: $0 [DEVICE_NAME] "
	echo "Example: $0 /dev/sda "
	exit 1
else 
	sudo dd if=$ISO_NAME of=$1 bs=4M && sync
fi

