# Boot Process

* [BIOS](#bios)
* [UEFI](#uefi)
* [init](#init)

---

### BIOS

0. The machine passes the execution control to the BIOS firmware.
1. BIOS passes the execution control to the Syslinux boot loader, which is present in the MLL ISO image.
2. The Syslinux boot loader has special configuration file ``syslinux.cfg`` which describes where the Linux kernel (kernel.xz) and the initramfs (rootfs.xz) files are located in the ISO image.
3. Syslinux loads both the kernel and the initramfs files in the RAM and then passes the execution control to the kernel.
4. The kernel detects the available hardware and loads the corresponding necessary drivers.
5. The kernel unpacks the initramfs archive (already loaded in the RAM by Syslinux) and then passes the execution control to the initramfs.
6. At this point the actual execution control is passed to the shell script file ``/init``, which is present in the initramfs file.

Refer to the [init](#init) section below for more details on how ``/init`` handles the OS preparation.

### UEFI

0. The machine passes the execution control to the UEFI firmware.
1. UEFI detects properly configured EFI boot image that is present in the MLL ISO image.
2. UEFI loads the EFI boot image from the MLL ISO image in the RAM.
3. UEFI passes the execution control to the special EFI file ``EFI/BOOT/BOOTx64.EFI`` (for 64-bit machines) from the previously described EFI boot image. This special file is the entry point of the [systemd-boot](https://github.com/ivandavidov/systemd-boot) UEFI boot manager.
4. The ``systemd-boot`` UEFI boot manager has special configuration files (loader.conf and all files in the entries/ folder) which describe where the Linux kernel (kernel.xz) and the initramfs (rootfs.xz) files are located in the EFI boot image.
5. ``systemd-boot`` loads the kernel in the RAM.
6. The kernel detects the available hardware and loads the corresponding necessary drivers.
7. The kernel loads the initramfs file in the RAM. Refer to the [kernel EFI stub documentation](https://www.kernel.org/doc/Documentation/efi-stub.txt) for more details.
8. The kernel unpacks the initramfs archive (already loaded in the RAM by the kernel) and then passes the execution control to the initramfs.
9. At this point the actual execution control is passed to the shell script file ``/init``, which is present in the initramfs file.

Refer to the [init](#init) section below for more details on how ``/init`` handles the OS preparation.

### INIT

The ``/init`` shell script is responsible to prepare the actual OS environment and to present the user with functional shell prompt.

The base initramfs structure is located here:

[https://github.com/ivandavidov/minimal/tree/master/src/minimal_rootfs](https://github.com/ivandavidov/minimal/tree/master/src/minimal_rootfs)

The actual ``/init`` script is located here:

[https://github.com/ivandavidov/minimal/blob/master/src/minimal_rootfs/init](https://github.com/ivandavidov/minimal/blob/master/src/minimal_rootfs/init)

This is what happens when ``/init`` is executed:

1. All core filesystems (i.e. /dev, /sys, /proc) are mounted.
2. The overlay system is prepared. At this point the initramfs structure and the overlay bundles are merged.
3. The execution control is passed to ``/sbin/init`` which is located in the initramfs.
4. ``/sbin/init`` uses the special configuration file [/etc/inittab](https://github.com/ivandavidov/minimal/blob/master/src/minimal_rootfs/etc/inittab) which describes the system initialization actions.
5. All autorun scripts are executed one by one.
6. Welcome message is displayed and the user is presented with functional shell prompt.
