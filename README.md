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
* [Publications](#publications)
* [Related projects](#related-projects)
* [Thank you!](#thank-you)

### Stargazers over time

[![Stargazers over time](https://starchart.cc/ivandavidov/minimal.svg)](https://starchart.cc/ivandavidov/minimal)

---

### Overview

Minimal Linux Live (MLL) is a tiny educational Linux distribution, which is designed to be built from scratch by using a collection of automated shell scripts. Minimal Linux Live offers a core environment with just the Linux kernel, GNU C library, and Busybox userland utilities. Additional software can be included in the ISO image at build time by using a well-documented [configuration file](src/.config).

The generated ISO image file contains Linux kernel, GNU C library compiled with default options, Busybox compiled with default options, quite simple initramfs structure and some "overlay bundles" (the default build process provides few overlay bundles). You don't get Windows support out of the box, nor you get any fancy desktop environment (refer to the [Debootstrap Live](https://github.com/zac87/debootstrap_live) project if you need minimal system with network and UI). All you get is a simple shell console with default Busybox applets, network support via DHCP and... well, that's all. This is why it's called "minimal".
 
Note that by default Minimal Linux Live provides support for legacy BIOS systems. You can change the build configuration settings in the [.config](src/.config) file and rebuild MLL with support for modern UEFI systems.
 
All build scripts are well organized and quite small in size. You can easily learn from the scripts, reverse engineer the build process and later modify them to include more stuff (I encourage you to do so). After you learn the basics, you will have all the necessary tools and skills to create your own fully functional Linux based operating system which you have built entirely from scratch.

The [guidebook](https://ivandavidov.github.io/minimal/book) explains in details the MLL architecture and the build process. This is the recommended documentation resource if you want to have complete understanding of the MLL ecosystem.

You are encouraged to read the [tutorial](src/the_dao_of_minimal_linux_live.txt) which explains the minimalistic MLL build process. The same tutorial, along with all MLL source code, can be found in the ISO image structure in the ``/minimal/rootfs/usr/src directory``.

The hosting space for [Minimal Linux Live](http://minimal.idzona.com "Minimal Linux Live") is provided by the cool guys at [Microweber](http://microweber.com "Microweber - Website Builder and Laravel CMS") - check them out. :)

Website mirrors are available here:

* [ivandavidov.github.io/minimal](http://ivandavidov.github.io/minimal "Minimal Linux Live")
* [skamilinux.hu/minimal](http://skamilinux.hu/minimal "Minimal Linux Live")
* [linux.idzona.com](http://linux.idzona.com "Minimal Linux Live")
* [minimal.linux-bg.org](http://minimal.linux-bg.org "Minimal Linux Live")

List of [related projects](#related-projects) is available in the end of this document. If you don't find what you're looking for in MLL, perhaps you'll find it in the related projects, e.g. minimal Linux system with graphical user interface (GUI), or perhaps minimal Linux system with option to run Docker containers.

The [README](src/README) document and the main [.config](src/.config) file provide extensive documentation regarding the Minimal Linux Live features.

[The DAO of Minimal Linux Live](http://minimal.idzona.com/the_dao_of_minimal_linux_live.txt "The DAO of Minimal Linux Live") - this tutorial explains step by step what you need to do in order to create your own minimalistic live Linux OS. The tutorial is based on the first published version of Minimal Linux Live.

[Component Architecture of Minimal Linux Live](http://blog.idzona.com/2016/04/component-architecture-of-minimal-linux-live.html "Component Architecture of Minimal Linux Live") - this publication describes the high level components included in the '03-Apr-2016' version of Minimal Linux Live.

Did I mention the [YouTube channel](https://youtu.be/u5KYDaCLChc?list=PLe3TW5jDbUAiN9E9lvYFLIFFqAjjZS9xS "Minimal Linux Live - YouTube channel") where you can watch some of the cool Minimal Linux Live features? No? Well, now you know about it! :)

### Current development state

As of **27-Mar-2021**:

* Linux kernel 5.11.10
* GNU C Library 2.33
* Busybox 1.32.1

Stable build on default Ubuntu 20.04 installation with applied system updates.

Here are some screenshots of the latest published version of Minimal Linux Live:

![Minimal Linux Live](docs/assets/img/minimal_linux_live.png)

![Minimal Linux Live Readme](docs/assets/img/readme_in_mll.png)

You can experiment with Minimal Linux Live directly in your browser by using [JavaScript PC Emulator](http://minimal.idzona.com/emulator "Minimal Linux Live in JavaScript PC emulator"). Here is a screenshot:

![Minimal Linux Live JavaScript Emulator](docs/assets/img/emulator_01.jpg)

### Future improvements

Take a look at the [issues](http://github.com/ivandavidov/minimal/issues) page where all future MLL improvements are tracked.

### How to build

The section below is for Ubuntu and other Debian based distros.

```
# Update all repositories and upgrade all packages
sudo apt update
sudo apt upgrade -y

# Resolve build dependencies
sudo apt install -y wget make gawk gcc bc bison flex xorriso libelf-dev libssl-dev

# Build everything and produce ISO image.
./build_minimal_linux_live.sh
```

The section below is for SUSE.

```
# Refresh all repositeries and update all packages
sudo zypper refresh
sudo zypper update -y

# Resolve build dependencies
sudo zypper install -y make gcc flex bison libelf-devel libopenssl-devel bc xorriso

# Build everything and produce ISO image.
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

![GraalVM languages](docs/assets/img/graal/graal_1.jpg)

![GraalVM - Java](docs/assets/img/graal/graal_2.jpg)

![GraalVM - Python](docs/assets/img/graal/graal_3.jpg)

![GraalVM - Ruby](docs/assets/img/graal/graal_4.jpg)

![GraalVM - Node](docs/assets/img/graal/graal_5.jpg)

![GraalVM - JS](docs/assets/img/graal/graal_6.jpg)

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

The build process also generates a compressed filesystem image file ``mll_image.tgz`` which contains everything from the initramfs area and everything from the overlay area, i.e. all overlay bundles that have been installed during the MLL build process. You can import and use the filesystem image in Docker like this:

```
# Import the MLL filesystem image in Docker.
docker import mll_image.tgz minimal-linux-live:latest

# Run MLL shell in Docker:
docker run -it minimal-linux-live /bin/sh
```

It is also possible to start MLL over network, using PXE mechanism (often called PXE diskless boot). To achieve that, before building MLL, edit src/.config and set ``OVERLAY_LOCATION`` to ``rootfs`` instead of default ``iso``. Then follow build process, which will build the minimal_linux_live.iso. Extract kernel and rootfs from this iso, and assuming webserver is using ``/var/www/html/`` folder as index, copy files here:

```
mount minimal_linux_live.iso /mnt
cp -a /mnt/boot/kernel.xz /var/www/html/
cp -a /mnt/boot/rootfs.xz /var/www/html/
```

Note: on RHEL systems, remember to restore SELinux contexts using ``restorecon -Rv /var/www/html/``.

Then assuming you are using iPXE as a PXE rom, and that your webserver ip is 10.0.0.1, create file ``/var/www/html/MLL.ipxe`` with the following content:

```
#!ipxe
echo Booting MLL
kernel http://10.0.0.1/kernel.xz initrd=rootfs.xz
initrd http://10.0.0.1/rootfs.xz
imgstat
echo All files downloaded, booting in 2s...
sleep 2
boot
```

Note: append your console parameter on the kernel line if using a remote IPMI console.

And chainload your mail iPXE to this file.

### Publications

Case studies, research papers, publications, presentations, etc. regarding [Minimal Linux Live](https://github.com/ivandavidov/minimal) and [Minimal Linux Script](https://github.com/ivandavidov/minimal-linux-script).

* [Software and Hardware Test - Minimal Linux](https://www.dotsource.de/labs/wp-content/uploads/sites/4/2019/06/Software-und-Hardwaretest-Minimal-Linux.pdf) (PDF, German language, [dotSource Labs](https://www.dotsource.de/labs/2019/06/17/software-und-hardwaretest-minimal-linux/))
* [MINCS - Containers in the Shell Script](https://www.slideshare.net/mhiramat/mincs-containers-in-the-shell-script-54420001) (presentation, English language, reference to Minimal Linux Live)
* [The Evolution of Minimal Linux Live](https://softuni.bg/downloads/svn/seminars/Minimal-Linux-Live-25-June-2016/Minimal-Linux-Live.pptx) (Power Point, Bulgarian language, [SoftUni seminar](https://softuni.bg/trainings/1409/minimal-linux-live-the-easy-way-to-create-a-minimal-linux-based-operating-system))
* [Considerations for the SDP Operating System](http://ska-sdp.org/sites/default/files/attachments/sdp_memo_063_os_signed_21.10.18.pdf) (PDF, English language, reference to Minimal Linux Live)

### Related projects

List of cool forks, spin-offs and other related projects inspired by Minimal Linux Live.

* [Minimal Linux Script](https://github.com/ivandavidov/minimal-linux-script) - very simplified and minimalistic version of MLL. This project is recommended as a starting point for beginners.

* [systemd-boot](https://github.com/ivandavidov/systemd-boot) - this project provides the UEFI boot loader images that MLL relies on. It also provides helper shell scripts which generate UEFI compatible MLL ISO images out of the already existing BIOS compatible MLL ISO images.

* [Bare Minimal Linux](https://github.com/sapcc/bare-minimal-linux) - fork of minimal linux for baremetal debugging. This project is part of the [SAP Converged Cloud](https://en.wikipedia.org/wiki/SAP_Converged_Cloud) ecosystem.

* [Minimal Linux FIRESTARTER](https://github.com/tud-zih-energy/minimal-linux-FIRESTARTER) - minimal Linux distribution with integrated [FIRESTARTER](https://tu-dresden.de/zih/forschung/projekte/firestarter) processor stress test utility. This project is developed at [TU Dresden - Centre for Information Services and High Performance Computing](https://tu-dresden.de/zih).

* [Prognostic Linux Live](https://github.com/ouyangjn/PrognosticLinux) - stripped down Linux environment for the development and experiments at the [Prognostic Lab](http://www.prognosticlab.org) at the University of Pittsburgh.

* [Minimal Container Linux](https://github.com/prologic/minimal-container-linux) - a Linux host OS designed to run Containers with a minimalist design and small footprint.

* [Debootstrap Live](https://github.com/zac87/debootstrap_live) - this spin-off of MLL generates bootable ISO with current kernel and [debootstrap](https://wiki.debian.org/Debootstrap) base system.

* [Boot2Minc](https://github.com/mhiramat/boot2minc) - this fork adds [Mincs](https://github.com/mhiramat/mincs) and as result you can run Linux containers inside MLL. One interesting Mincs feature - it provides tools which allow you to reuse already existing Docker containers.

* [K1773R's MLL](https://github.com/K1773R/minimal) - PowerPC version of Minimal Linux Live with [memtester](http://pyropus.ca/software/memtester) as additional software. Impressive work!

* [Ladiko's MLL](https://github.com/ladiko/minimal) - this fork automatically downloads and uses the latest available Kernel and Busybox sources. By default there is NTFS and SquashFS support. The fork also provides an installer which can be used to put MLL on USB flash device.

* [StelaLinux](https://github.com/AwlsomeAlex/stelalinux) - the successor of [StarLinux](https://github.com/AwlsomeAlex/StarLinux) and [AwlsomeLinux](https://github.com/AwlsomeAlex/AwlsomeLinux). These projects are spin-offs of MLL that take different build approach.

* [prologic's MLL](https://github.com/prologic/minimal) - this fork adds Python support to the MLL runtime environment.

* [KernelISO](https://github.com/rleon/kerneliso) - extended version of MLL, based on older version of MLL.

* [diaob's MLL](https://github.com/Diaob/minimal) - MLL translation to Simplified Chinese.

* [bdheeman's MLL](https://bitbucket.org/bdheeman/minimal) - MLL KISS fork (Keep It, Simple, Safe/Secure/Stupid).

* [Runlinux](https://github.com/cirosantilli/runlinux) - environment to build and test Linux kernels.

* [Ersoy Kardesler Minimal Linux System](https://notabug.org/ersoy-kardesler/minimal-linux-system) - A minimal Linux script fork, adds custom Linux and BusyBox configs, NCURSES and GNU nano.

### Thank you!

Don't miss the chance to share your honest opinion about MLL in [DistroWatch](http://distrowatch.com/dwres.php?resource=ratings&distro=mll). And don't forget to check the Minimal Linux Live page on [Facebook](http://facebook.com/MinimalLinuxLive).

Thank you for your support!
