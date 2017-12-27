## Minimal Linux Live

You can find the main website here:

[Minimal Linux Live](http://minimal.idzona.com "Minimal Linux Live")

If the above link doesn't work, website mirrors are available [here](http://skamilinux.hu/minimal "Minimal Linux Live"), [here](http://minimal.linux-bg.org "Minimal Linux Live") and [here](http://ivandavidov.github.io/minimal "Minimal Linux Live").

The [README](https://github.com/ivandavidov/minimal/blob/master/src/README) document and the main [.config](https://github.com/ivandavidov/minimal/blob/master/src/.config) file provide extensive documentation regarding the Minimal Linux Live features.

[The DAO of Minimal Linux Live](http://minimal.idzona.com/the_dao_of_minimal_linux_live.txt "The DAO of Minimal Linux Live") - this tutorial explains step by step what you need to do in order to create your own minimalistic live Linux OS. The tutorial is based on the first published version of Minimal Linux Live.

[Component Architecture of Minimal Linux Live](http://blog.idzona.com/2016/04/component-architecture-of-minimal-linux-live.html "Component Architecture of Minimal Linux Live") - this publication describes the high level components included in the '03-Apr-2016' version of Minimal Linux Live.

You can experiment with Minimal Linux Live directly in your browser by using [JavaScript PC Emulator](http://minimal.idzona.com/emulator "Minimal Linux Live in JavaScript PC emulator"). Here is a screenshot:

![Minimal Linux Live JavaScript Emulator](http://ivandavidov.github.io/minimal/www/assets/img/emulator_01.jpg)

Did I mention the [YouTube channel](https://youtu.be/u5KYDaCLChc?list=PLe3TW5jDbUAiN9E9lvYFLIFFqAjjZS9xS "Minimal Linux Live - YouTube channel") where you can watch some of the cool Minimal Linux Live features? No? Well, now you know about it! :)

This is a screenshot of the current development version of Minimal Linux Live:

![Minimal Linux Live](http://ivandavidov.github.io/minimal/www/assets/img/minimal_linux_live_3.jpg)

## Current development state (26-Dec-2017)

* Linux kernel 4.14.8 (longterm)
* GNU C Library 2.26 (stable)
* BusyBox 1.27.2 (stable)
* Stable on default Ubuntu 16.04 installation with applied system updates.

## Future improvements

* Add kernel modules and firmware.
* Allow individual overlay bundles to be downloaded and installed.
* Add more overlay bundles.

The above list is not fixed and it may be updated at any time. Refer to the [issues](https://github.com/ivandavidov/minimal/issues) page
where most of the MLL feature development is tracked.

## How to build

The section below is for Ubuntu and other Debian based distros.

```
# Resove build dependencies
sudo apt install wget make gawk gcc bc xorriso

# Build everything and produce ISO image.
./build_minimal_linux_live.sh
```

The default build process uses some custom provided ``CFLAGS``. They can be found in the ``.config`` file. Some of these additional flags were introduced in order to fix different issues which were reported during the development phase. However, there is no guarantee that the build process will run smoothly on your system with these particular flags. If you get compilation issues (please note that I'm talking about compilation issues, not about general shell script issues), you can try to disable these flags and then start the build process again. It may turn out that on your particular host system you don't need these flags. 

## Overlay bundles

**Important note!** Most of the overlay bundles come without support since the build process for almost all of them is host specific and can vary significantly between different machines. Some overlay bundles have no dependencies to the host machine, e.g. the bundles which provide the DHCP functionality and the MLL source code. These bundles are enabled by default.

Minimal Linux Live has the concept of ``overlay bundles``. During the boot process the ``OverlayFS`` driver merges the initramfs with the content of these bundles. This is the mechanism which allows you to provide additional software on top of MLL without touching the core build process. In fact the overlay bundle system has been designed to be completely independent from the MLL build process. You can build one or more overlay bundles without building MLL at all. However, some of the overlay bundles have dependencies on the software pieces provided by the MLL build process, so it is recommended to use the overlay build subsystem after you have produced the 'initramfs' area.

The overlay bundle system provides dependency management. If bundle 'b' depends on bundle 'a' you don't need to build bundle 'a' manually in advance. The bundle dependencies are described in special metadata file ``bundle_deps`` and all such dependencies are prepared automatically.

```
# How to build all overlay bundles.

cd minimal_overlay
./overlay_build.sh
```

```
# How to build specific overlay bundle. The example is for 'Open JDK'
# which depends on many GNU C libraries and on ZLIB. All dependencies
# are handled automatically by the overlay bundle system.

cd minimal_overlay
./overlay_build.sh openjdk
```

## BIOS and UEFI

The latest verson of Minimal Linux Live (20-Jan-2017) provides experimental UEFI support and the MLL ISO image can be used on legacy BIOS based systems and on UEFI based systems with enabled UEFI shell (level support 1 or higher, see section ``3.1 - Levels Of Support`` of the [UEFI Shell specification](http://www.uefi.org/sites/default/files/resources/UEFI_Shell_2_2.pdf)).

The current development version of Minimal Linux Live provides full UEFI support, thanks to the [systemd-boot](https://github.com/ivandavidov/systemd-boot) project. There are three build flavors that you can choose from:

* ``bios`` - MLL will be bootbale only on legacy BIOS based systems. This is the default build flavor.
* ``uefi`` - MLL will be bootable only on UEFI based systems.
* ``both`` - MLL will be bootable on both legacy BIOS and modern UEFI based systems.

The generated MLL iso image is 'hybrid' which means that if it is 'burned' on external hard drive, this external hard drive will be bootable. You can use this behavior to install MLL on your USB flash device (read the next section).

## Installation

The build process produces ISO image which you can use in virtual machine or you can burn it on real CD/DVD. Installing MLL on USB flash drive currently is not supported but it can be easily achieved by using ``syslinux`` or  ``extlinux`` since MLL requires just two files (one kernel file and another initramfs file). This applies for legacy BIOS based systems.

Another way to install MLL on USB flash drive is by using [YUMI](http://pendrivelinux.com/yumi-multiboot-usb-creator) or other similar tools. This applies for legacy BIOS based systems.

Yet another way to install MLL on USB flash drive is by using the ``dd`` tool:

```
# Directly write the ISO image to your USB flash device (e.g. /dev/xxx)
dd if=minimal_linux_live.iso of=/dev/xxx
```

The USB flash device will be recognezed as bootable device and you should be able to boot MLL successfully from it. If you have chosen the 'combined' build flavor (i.e. value ``both`` for the corresponding configuration property), then your USB flash device will be bootable on both legacy BIOS and modern UEFI based systems.

The build process also generates image the file ``mll_image.tgz``. This image contains everything from the initramfs area and everything from the overlay area, i.e. all overlay bundles that have been installed during the MLL build process. You can import and use the image in Docker like this:

```
# Import the MLL image in Docker.
docker import mll_image.tgz minimal-linux-live:latest

# Run MLL shell in Docker:
docker run -it minimal-linux-live /bin/sh
```

## Projects based on Minimal Linux Live:

* [Minimal Linux Script](https://github.com/ivandavidov/minimal-linux-script) - very simplified and minimalistic version of MLL. This project is recommended as a starting point for beginners.

* [systemd-boot](https://github.com/ivandavidov/systemd-boot) - this project provides the UEFI boot loader images that MLL relies on. It also provides helper shell scripts which generate UEFI compatible MLL ISO images out of the already existing BIOS compatible MLL ISO images.

* [RedoxOS Installer](https://github.com/RedoxOS/installer) - the original installer for [Redox OS](www.redox-os.org) is based on simplified version of Minimal Linux Live.

* [Boot2Minc](https://github.com/mhiramat/boot2minc) - this fork adds [Mincs](https://github.com/mhiramat/mincs) and as result you can run Linux containers inside MLL. One interesting Mincs feature - it provides tools which allow you to reuse alredy existing Docker containers.

* [K1773R's MLL](https://github.com/K1773R/minimal) - PowerPC version of Minimal Linux Live with [memtester](http://pyropus.ca/software/memtester) as additional software. Impressive work!

* [Ladiko's MLL](https://github.com/ladiko/minimal) - this fork automatically downloads and uses the latest available Kernel and BusyBox sources. By default there is NTFS and SquashFS support. The fork also provides an installer which can be used to put MLL on USB flash device.

* [AwlsomeLinux](https://github.com/AwlsomeAlex/AwlsomeLinux) - MLL fork which provides additional overlay bundles (ncurses and Nano).

* [StarLinux](https://github.com/AwlsomeAlex/StarLinux) - the successor of [AwlsomeLinux](https://github.com/AwlsomeAlex/AwlsomeLinux). StarLinux aims at making the build process user friendly.

* [prologic's MLL](https://github.com/prologic/minimal) - this fork adds Python support to the MLL runtime environment.

* [KernelISO](https://github.com/rleon/kerneliso) - extended version of MLL.

* [diaob's MLL](https://github.com/Diaob/minimal) - MLL translation to Simplified Chinese.

* [bdheeman's MLL](https://bitbucket.org/bdheeman/minimal) - MLL KISS fork (Keep It, Simple, Safe/Secure/Stupid).

* [Runlinux](https://github.com/cirosantilli/runlinux) - environment to build and test Linux kernels.

## Thank you!

Do you like this project? Yes? Well, in that case I would very much appreciate it if you give your honest opinion about MLL in [DistroWatch](http://distrowatch.com/dwres.php?resource=ratings&distro=mll). And don't forget to check the Minimal Linux Live page on [Facebook](http://facebook.com/MinimalLinuxLive). Thank you!
