# Build Process

The MLL build process can be divided in several major phases. Refer to the [common properties](./common.md#properties) for more details on the folders that are referenced below.

* [Preparations](#preparations)
* [Kernel](#kernel)
* [GNU C Library](#gnu-c-library)
* [Busybox](#busybox)
* [Overlay bundles](#overlay-bundles)
* [Initramfs](#initramfs)
* [Boot loader](#boot-loader)
* [ISO image](#iso-image)

---

## Preparations

* [00_clean.sh](./00_clean.md)

Everything from ``WORK_DIR`` is removed. All previous MLL build artifacts are lost and the MLL build process can start from scratch. The previously downloaded sources are preserved in order to speed up the process.

## Kernel

* [01_get_kernel.sh](./01_get_kernel.md)
* [02_build_kernel.sh](./02_build_kernel.md)

Linux kernel source code is downloaded. [OverlayFS](https://www.kernel.org/doc/Documentation/filesystems/overlayfs.txt) and [EFI stub](https://www.kernel.org/doc/Documentation/efi-stub.txt) are configured. Kernel is built and the kernel binary, along with the kernel header files are placed in ``KERNEL_INSTALLED``.

## GNU C Library

* [03_get_glibc.sh](./03_get_glibc.md)
* [04_build_glibc.sh](./04_build_glibc.md)
* [05_prepare_sysroot.sh](./05_prepare_sysroot.md)

GNU C Library source code is downloaded. Build preparations are made in the ``GLIBC_OBJECTS``. GLIBC is built and the final artifacts are placed in ``GLIBC_INSTALLED``. The ``.so`` files, along with all GLIBC headers and all kernel headers are placed in ``SYSROOT``.

## Busybox

* [06_get_busybox.sh](./06_get_busybox.md)
* [07_build_busybox.sh](./07_build_busybox.md)

Busybox source code is downloaded. The build configuration is tweaked to reference ``SYSROOT``. The final build artifacts are placed in ``BUSYBOX_INSTALLED``.

## Overlay bundles

* [08_prepare_bundles.sh](./08_prepare_bundles.md)

All overlay bundles that have been enabled in ``.config`` are built. The final overlay structure is generated in ``OVERLAY_ROOTFS``.

## Initramfs

* [09_generate_rootfs.sh](./09_generate_rootfs.md)
* [10_pack_rootfs.sh](./10_pack_rootfs.md)
* [11_generate_overlay.sh](./11_generate_overlay.md)

The installed Busybox artifacts and ``src/minimal_rootfs/`` are merged in ``ROOTFS``. The initramfs file ``WORK_DIR/rootfs.cpio.xz`` is generated from ``ROOTFS``. The final initramfs ISO image structure for the overlay bundles is generated in ``ISOIMAGE_OVERLAY``.

## Boot loader

* [12_get_syslinux.sh](./12_get_syslinux.md)
* [12_get_systemd-boot.sh](./12_get_systemd-boot.md)

Syslinux and/or systemd-boot are downloaded.

## ISO image

* [13_prepare_iso.sh](./13_prepare_iso.md)
* [14_generate_iso.sh](./14_generate_iso.md)
* [15_generate_image.sh](./15_generate_image.md)
* [16_cleanup.sh](./16_cleanup.md)

The boot loader for BIOS/UEFI is prepared and the boot configuration artifacts from ``src/minimal_boot/`` are properly placed. The final ISO image layout structure is prepared in ``ISOIMAGE``. This directory contains the BIOS/UEFI boot loader, Linux kernel and initramfs, along with all MLL overlay bundles (i.e. additional software and/or configurations) that have been enabled. The ISO image file ``src/minimal_linux_live.iso`` is generated. The MLL filesystem image (e.g. use in Docker) ``src/mll_image.tgz`` is generated. Final cleanup is performed.


