#!/bin/sh

qemu-system-aarch64 -machine virt -cpu cortex-a57 -machine type=virt -smp 2 -m 4096 \
  -kernel work/kernel/kernel_installed/kernel \
  -initrd work/rootfs.cpio.xz \
  -append "vga=ask"

