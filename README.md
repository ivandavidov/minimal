## Minimal Linux Live

**Current development state**

* Linuk kernel 4.4.40 (longterm)
* GNU C Library 2.24 (stable)
* BusyBox 1.26.1 (stable)
* Stable build on default Ubuntu 16.04.1 installation (64-bit) with applied system updates (08-Jan-2017).
* Stable build on default Ubuntu 16.04.1 installation (32-bit) with applied system updates (10-Jan-2017).

You can find the main website here:

[Minimal Linux Live](http://minimal.idzona.com "Minimal Linux Live")

If the above link doesn't work, website mirrors are available [here](http://skamilinux.hu/minimal "Minimal Linux Live"), [here](http://linux.idzona.com "Minimal Linux Live") and [here](http://minimal.linux-bg.org "Minimal Linux Live").

[The DAO of Minimal Linux Live](http://minimal.idzona.com/the_dao_of_minimal_linux_live.txt "The DAO of Minimal Linux Live") - this tutorial explains step by step what you need to do in order to create your own minimalistic live Linux OS. The tutorial is based on the first published version of Minimal Linux Live.

[Component Architecture of Minimal Linux Live](http://blog.idzona.com/2016/04/component-architecture-of-minimal-linux-live.html "Component Architecture of Minimal Linux Live") - this publication describes the high level components included in the "03-Apr-2016" version of Minimal Linux Live.

You can experiment with Minimal Linux Live directly in your browser by using [JavaScript PC Emulator](http://minimal.idzona.com/emulator "Minimal Linux Live in JavaScript PC emulator"). Here is a screenshot:

![Minimal Linux Live JavaScript Emulator](http://minimal.idzona.com/assets/img/minimal_linux_live_javascript_emulator.png)

Did I mention the [YouTube channel](https://youtu.be/u5KYDaCLChc?list=PLe3TW5jDbUAiN9E9lvYFLIFFqAjjZS9xS "Minimal Linux Live - YouTube channel") where you can watch some of the cool Minimal Linux Live features? No? Well, now you know about it! :)

This is a screenshot of the current development version of Minimal Linux Live:

![Minimal Linux Live](http://minimal.idzona.com/assets/img/minimal_linux_live.png)

## Notable projects based on Minimal Linux Live:

* [Redox OS Installer](https://github.com/redox-os/installer) - Minimal Linux Live has been chosen by the [Redox OS](https://www.redox-os.org) developers to build the installer part of the operating system.

* [Boot2Minc](https://github.com/mhiramat/boot2minc) - this fork adds [Mincs](https://github.com/mhiramat/mincs) and as result you can run Linux containers. One interesting Mincs feature - it provides tools which allow you to reuse alredy existing Docker containers.

* [K1773R's MLL](https://github.com/K1773R/minimal) - PowerPC version of Minimal Linux Live with [memtester](http://pyropus.ca/software/memtester) as additional software. Impressive work!

## Other projects based on Minimal Linux Live

* [Minimal Linux Script](https://github.com/ivandavidov/minimal-linux-script) - very simplified and minimalistic version of MLL.

* [Ladiko's MLL](https://github.com/ladiko/minimal) - This fork automatically downloads and uses the latest available Kernel and BusyBox sources. By default there is NTFS and SquashFS support. The fork also provides an installer which can be used to put MLL on USB flash device.

* [AwlsomeLinux](https://github.com/AwlsomeAlex/AwlsomeLinux) - MLL fork which provides additional overlay bundles (ncurses and Nano).

* [prologic's MLL](https://github.com/prologic/minimal) - this fork adds Python support to the MLL runtime environment.

* [KernelISO](https://github.com/rleon/kerneliso) - extended version of MLL.

* [diaob's MLL](https://github.com/Diaob/minimal) - MLL translation to Simplified Chinese.

* [bdheeman's MLL](https://bitbucket.org/bdheeman/minimal) - MLL KISS fork (Keep It, Simple, Safe/Secure/Stupid).

* [Runlinux](https://github.com/cirosantilli/runlinux) - environment to build and test Linux kernels.
