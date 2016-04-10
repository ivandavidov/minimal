#!/bin/sh

qemu-system-i386 -m 64M -hda hdd.img -cdrom minimal_linux_live.iso -boot d

