#!/bin/sh

qemu-system-x86_64 -m 64M -hda hdd.img -cdrom minimal_linux_live.iso -boot d

