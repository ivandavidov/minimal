# Minimal Linux Live

* [Overview](#overview)
* [Current development state](#current-development-state)
* [Future improvements](#future-improvements)
* [How to build](#how-to-build)
* [Overlay bundles](#overlay-bundles)
* [Runtime software](#runtime-software)
* [GraalVM](#graalvm)
* [BIOS and UEFI](#bios-and-uefi)
* [Installation](#installation)
* [Other projects](#other-projects)
* [Thank you!](#thank-you)

### Stargazers over time

[![Stargazers over time](https://starchart.cc/ivandavidov/minimal.svg)](https://starchart.cc/ivandavidov/minimal)

---

### Overview

The hosting space for [Minimal Linux Live](http://minimal.idzona.com "Minimal Linux Live") is provided by the cool guys at [Microweber](http://microweber.com "Microweber - Website Builder and Laravel CMS") - check them out. :)

Website mirrors are available here:

* [skamilinux.hu/minimal](http://skamilinux.hu/minimal "Minimal Linux Live")
* [minimal.linux-bg.org](http://minimal.linux-bg.org "Minimal Linux Live")
* [linux.idzona.com](http://linux.idzona.com "Minimal Linux Live")
* [ivandavidov.github.io/minimal](http://ivandavidov.github.io/minimal "Minimal Linux Live")

The [README](https://github.com/ivandavidov/minimal/blob/master/src/README) document and the main [.config](https://github.com/ivandavidov/minimal/blob/master/src/.config) file provide extensive documentation regarding the Minimal Linux Live features.

[The DAO of Minimal Linux Live](http://minimal.idzona.com/the_dao_of_minimal_linux_live.txt "The DAO of Minimal Linux Live") - this tutorial explains step by step what you need to do in order to create your own minimalistic live Linux OS. The tutorial is based on the first published version of Minimal Linux Live.

[Component Architecture of Minimal Linux Live](http://blog.idzona.com/2016/04/component-architecture-of-minimal-linux-live.html "Component Architecture of Minimal Linux Live") - this publication describes the high level components included in the '03-Apr-2016' version of Minimal Linux Live.

Did I mention the [YouTube channel](https://youtu.be/u5KYDaCLChc?list=PLe3TW5jDbUAiN9E9lvYFLIFFqAjjZS9xS "Minimal Linux Live - YouTube channel") where you can watch some of the cool Minimal Linux Live features? No? Well, now you know about it! :)

### Current development state

As of **02-Nov-2019**:

* Linux kernel 5.3.8 (stable)
* GNU C Library 2.30 (stable)
* Busybox 1.31.1 (stable)
* Stable build on default Ubuntu 18.04.3 installation with applied system updates.

Here are some screenshots of the current development version of Minimal Linux Live:

![Minimal Linux Live](docs/www/assets/img/nikola.png)

![Minimal Linux Live Readme](docs/www/assets/img/readme_in_mll.png)

You can experiment with Minimal Linux Live directly in your browser by using [JavaScript PC Emulator](http://minimal.idzona.com/emulator "Minimal Linux Live in JavaScript PC emulator"). Here is a screenshot:

![Minimal Linux Live JavaScript Emulator](docs/www/assets/img/emulator_01.jpg)

### Future improvements

Take a look at the [issues](http://github.com/ivandavidov/minimal/issues) page where all future MLL improvements are tracked.

### How to build

The section below is for Ubuntu and other Debian based distros.

```
# Resolve build dependencies
sudo apt-get update
sudo apt install wget make gawk gcc bc bison flex xorriso libelf-dev libssl-dev

# Build everything and produce ISO image.
cd src
./build_minimal_linux_live.sh
```

The default build process uses some custom provided ``CFLAGS``. They can be found in the ``.config`` file. Some of these additional flags were introduced in order to fix different issues which were reported during the development phase. However, there is no guarantee that the build process will run smoothly on your system with these particular flags. If you get compilation issues (please note that I'm talking about compilation issues, not about general shell script issues), you can try to disable these flags and then start the build process again. It may turn out that on your particular host system you don't need these flags.

### Overlay bundles

**Important note!** Most of the overlay bundles come with no support since the build process for almost all of them is host specific and can vary significantly between different machines. Some overlay bundles have no dependencies to the host machine, e.g. the bundles which provide the DHCP functionality and the MLL source code. These bundles are enabled by default.

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

Take a look at the [mll_hello](src/minimal_overlay/bundles/mll_hello/bundle.sh) overlay bundle which compiles simple C program (it prints one line in the console) and installs it properly in the MLL overlay structure.

### Runtime software

Another way to add software in MLL is at runtime by using slightly modified version of [static-get](http://s.minos.io) which is provided as additional overlay bundle. The ``static_get`` overlay bundle is not enabled by default. You can enable it in the main ``.config`` file. Here are some examples with static-get:

```
# Search for 'vim'
static-get -s vim

# Install the 'vim' package. Run 'vim' after that
static-get -i vim

# Search for 'tetris'
static-get -s tetris

# Install the 'vitetris' package. Run 'vitetris' after that
static-get -i vitetris
```

### GraalVM

The current development version of MLL partially supports [GraalVM](http://graalvm.org) (provided as overlay bundle). Note that GraalVM has runtime dependencies on ``GCC`` and ``Bash`` and therefore some GraalVM feature are not supported in MLL, e.g. the ``gu`` updater and almost all GVM language wrapper scripts, including the ``R`` wrappers. Nevertheless, the core GVM features work fine. Java, Python, Ruby, Node and JavaScript work in MLL/GraalVM environment. Great, isn't it! :)

![GraalVM languages](docs/www/assets/img/graal/graal_1.jpg)

![GraalVM - Java](docs/www/assets/img/graal/graal_2.jpg)

![GraalVM - Python](docs/www/assets/img/graal/graal_3.jpg)

![GraalVM - Ruby](docs/www/assets/img/graal/graal_4.jpg)

![GraalVM - Node](docs/www/assets/img/graal/graal_5.jpg)

![GraalVM - JS](docs/www/assets/img/graal/graal_6.jpg)

### BIOS and UEFI

Minimal Linux Live can be used on UEFI systems (as of version ``28-Jan-2018``) thanks to the [systemd-boot](https://github.com/ivandavidov/systemd-boot) project. There are three build flavors that you can choose from:

* ``bios`` - MLL will be bootable only on legacy BIOS based systems. This is the default build flavor.
* ``uefi`` - MLL will be bootable only on UEFI based systems.
* ``both`` - MLL will be bootable on both legacy BIOS and modern UEFI based systems.

The generated MLL iso image is 'hybrid' which means that if it is 'burned' on external hard drive, this external hard drive will be bootable. You can use this behavior to install MLL on your USB flash device (read the next section).

The older version of Minimal Linux Live ``20-Jan-2017`` has experimental UEFI support and the MLL ISO image can be used on legacy BIOS based systems and on UEFI based systems with enabled UEFI shell (level support 1 or higher, see section ``3.1 - Levels Of Support`` of the [UEFI Shell specification](http://www.uefi.org/sites/default/files/resources/UEFI_Shell_2_2.pdf)). All newer versions of Minimal Linux Live have full UEFI support.

### Installation

The build process produces ISO image which you can use in virtual machine or you can burn it on real CD/DVD. Installing MLL on USB flash drive currently is not supported but it can be easily achieved by using ``syslinux`` or  ``extlinux`` since MLL requires just two files (one kernel file and another initramfs file). This applies for legacy BIOS based systems.

Another way to install MLL on USB flash drive is by using [YUMI](http://pendrivelinux.com/yumi-multiboot-usb-creator) or other similar tools. This applies for legacy BIOS based systems.

Yet another way to install MLL on USB flash drive is by using the ``dd`` tool:

```
# Directly write the ISO image to your USB flash device (e.g. /dev/xxx)
dd if=minimal_linux_live.iso of=/dev/xxx
```

The USB flash device will be recognized as bootable device and you should be able to boot MLL successfully from it. If you have chosen the 'combined' build flavor (i.e. value ``both`` for the corresponding configuration property), then your USB flash device will be bootable on both legacy BIOS and modern UEFI based systems.

The build process also generates image the file ``mll_image.tgz``. This image contains everything from the initramfs area and everything from the overlay area, i.e. all overlay bundles that have been installed during the MLL build process. You can import and use the image in Docker like this:

```
# Import the MLL image in Docker.
docker import mll_image.tgz minimal-linux-live:latest

# Run MLL shell in Docker:
docker run -it minimal-linux-live /bin/sh
```

### Other projects

* [Minimal Linux Script](https://github.com/ivandavidov/minimal-linux-script) - very simplified and minimalistic version of MLL. This project is recommended as a starting point for beginners.

* [systemd-boot](https://github.com/ivandavidov/systemd-boot) - this project provides the UEFI boot loader images that MLL relies on. It also provides helper shell scripts which generate UEFI compatible MLL ISO images out of the already existing BIOS compatible MLL ISO images.

* [Bare Minimal Linux](https://github.com/sapcc/bare-minimal-linux) - fork of minimal linux for baremetal debugging. This project is part of the [SAP Converged Cloud](https://en.wikipedia.org/wiki/SAP_Converged_Cloud) ecosystem.

* [Minimal Container Linux](https://github.com/prologic/minimal-container-linux) - a Linux host OS designed to run Containers with a minimalist design and small footprint.

* [RedoxOS Installer](https://github.com/RedoxOS/installer) - the original installer for [Redox OS](www.redox-os.org) is based on simplified version of Minimal Linux Live.

* [Boot2Minc](https://github.com/mhiramat/boot2minc) - this fork adds [Mincs](https://github.com/mhiramat/mincs) and as result you can run Linux containers inside MLL. One interesting Mincs feature - it provides tools which allow you to reuse alredy existing Docker containers.

* [K1773R's MLL](https://github.com/K1773R/minimal) - PowerPC version of Minimal Linux Live with [memtester](http://pyropus.ca/software/memtester) as additional software. Impressive work!

* [Ladiko's MLL](https://github.com/ladiko/minimal) - this fork automatically downloads and uses the latest available Kernel and Busybox sources. By default there is NTFS and SquashFS support. The fork also provides an installer which can be used to put MLL on USB flash device.

* [AwlsomeLinux](https://github.com/AwlsomeAlex/AwlsomeLinux) - MLL fork which provides additional overlay bundles (ncurses and Nano).

* [StarLinux](https://github.com/AwlsomeAlex/StarLinux) - the successor of [AwlsomeLinux](https://github.com/AwlsomeAlex/AwlsomeLinux). StarLinux aims at making the build process user friendly.

* [prologic's MLL](https://github.com/prologic/minimal) - this fork adds Python support to the MLL runtime environment.

* [KernelISO](https://github.com/rleon/kerneliso) - extended version of MLL, based on older version of MLL.

* [diaob's MLL](https://github.com/Diaob/minimal) - MLL translation to Simplified Chinese.

* [bdheeman's MLL](https://bitbucket.org/bdheeman/minimal) - MLL KISS fork (Keep It, Simple, Safe/Secure/Stupid).

* [Runlinux](https://github.com/cirosantilli/runlinux) - environment to build and test Linux kernels.

### Thank you!

Do you like this project? Yes? Well, in that case I would very much appreciate it if you give your honest opinion about MLL in [DistroWatch](http://distrowatch.com/dwres.php?resource=ratings&distro=mll). And don't forget to check the Minimal Linux Live page on [Facebook](http://facebook.com/MinimalLinuxLive).

Thank you!
