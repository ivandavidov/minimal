#!/bin/sh

qemu-system-x86_64 -m 64M -cdrom minimal_linux_live.iso -boot d

# Use this when you want to play with hard disk content. You can manually create
# sparse file (/minimal.img) and put overlay content (/minimal.img/rootfs) in it.
#
# qemu-system-x86_64 -m 64M -hda hdd.img -cdrom minimal_linux_live.iso -boot d
