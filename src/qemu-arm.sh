#!/bin/sh

# --- Configuration ---
KERNEL_IMAGE="./work/kernel/kernel_installed/kernel"  # Replace with the path to your kernel image
INITRAMFS_IMAGE="./work/rootfs.cpio.xz" # Replace with the path to your initramfs image
MACHINE_TYPE="virt"                  # A versatile machine type for virtualization
CPU_CORES=4                          # Number of CPU cores to emulate
RAM_SIZE="256M"                      # Amount of RAM to allocate

# --- QEMU Command ---
qemu-system-aarch64 \
    -machine ${MACHINE_TYPE} \
    -cpu cortex-a57 \
    -smp ${CPU_CORES} \
    -m ${RAM_SIZE} \
    -kernel ${KERNEL_IMAGE} \
    -initrd ${INITRAMFS_IMAGE} \
    -append "console=ttyAMA0" \
    -nographic

echo "QEMU started. You should see output in this terminal."
echo "Press Ctrl+A then X to exit QEMU."

