# The Architecture of Minimal Linux Live

Welcome to the wonderful world of [Minimal Linux Live](https://github.com/ivandavidov/minimal)! :)

Minimal Linux Live (MLL) is a tiny educational Linux distribution, which is designed to be built from scratch by using a collection of automated shell scripts. Minimal Linux Live offers a core environment with just the Linux kernel, GNU C library, and Busybox userland utilities. Additional software can be included in the ISO image at build time by using a well-documented [configuration file](TODO.md).

The generated ISO image file contains Linux kernel, GNU C library compiled with default options, Busybox compiled with default options, quite simple initramfs structure and some "overlay bundles" (the default build process provides few overlay bundles). You don't get Windows support out of the box, nor you get any fancy desktop environment. All you get is a simple shell console with default Busybox applets, network support via DHCP and... well, that's all. This is why it's called "minimal".

Note that by default Minimal Linux Live provides support for legacy BIOS systems. You can change the build configuration settings in the [.config](TODO.md) file and rebuild MLL with support for modern UEFI systems.

All build scripts are well organized and quite small in size. You can easily learn from the scripts, reverse engineer the build process and later modify them to include more stuff (I encourage you to do so). After you learn the basics, you will have all the necessary tools and skills to create your own fully functional Linux based operating system which you have built entirely from scratch.

