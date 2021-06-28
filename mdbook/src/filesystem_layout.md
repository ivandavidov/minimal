# MLL ISO Image Structure

* [BIOS](#bios)
* [UEFI](#uefi)

---

The default build process generates a bootable ISO image file named ``minimal_linux_live.iso``.

### BIOS

When the property ``FIRMWARE_TYPE`` in the configuration file ``.config`` is set to ``bios``, the generated ISO image has the following structure.

```
# FIRMWARE_TYPE=bios

minimal_linux_live.iso
├── boot/
│   ├── kernel.xz
│   ├── rootfs.xz
│   └── syslinux/
├── EFI/
└── minimal/
```

#### boot/

This folder contains all files that are necessary for the proper BIOS boot process. More precisely, you can find the Linux kernel, the initial RAM filesystem (initramfs) and the boot loader.

#### boot/kernel.xz

This is the Linux kernel. The kernel detects the available hardware, loads necessary drivers and then it passes the execution control to the initramfs.

#### boot/rootfs.xz

This is the initial RAM filesystem. The initramfs file is an archive, automatically unpacked by the kernel in the RAM. The actual execution control is passed to the shell script file ``/init``, which must be present in the initramfs file.

#### boot/syslinux/

This folder contains the [ISOLINUX](https://wiki.syslinux.org/wiki/index.php?title=ISOLINUX) boot loader (binaries and configuration files), part of the [Syslinux](https://syslinux.org) project.

#### EFI/

This folder contains a simple ``.nsh`` script which allows MLL to boot on EFI based machines, provided that these machines support UEFI shell.

#### minimal/

This folder contains all MLL overlay bundles (i.e. additional software prepared during the build process).

### UEFI

When the property ``FIRMWARE_TYPE`` in the configuration file ``.config`` is set to ``uefi``, the generated ISO image has the following structure.

```
# FIRMWARE_TYPE=uefi

minimal_linux_live.iso
├── boot/
│   └── uefi.img
└── minimal/
```

#### boot/

This folder contains all files that are necessary for the proper UEFI boot process. More precisely, you can find the EFI boot image.

#### boot/uefi.img

This is the EFI boot image. It contains the [systemd-boot](https://github.com/ivandavidov/systemd-boot) UEFI boot manager, corresponding boot configurations, the Linux kernel and the initramfs.

#### minimal/

This folder contains all MLL overlay bundles (i.e. additional software prepared during the build process).

