#!/bin/sh

# Create sparse file of 20MB which can be used by QEMU.

rm -f hdd.img
truncate -s 20M hdd.img

