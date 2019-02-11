# Bare Minimal Linux
## Introduction
This is Bare Minimal Linux - a bootable live Linux iso of about 11MB size,
including an lldpd and a script to automatically display all lldp neighbors.

Its main purpose is baremetal debugging and cabling check. With its small size
it can be put directly into Lenovos IMM2 (which only takes images up to 50MB and
has a broken http-mount otherwise).

Bare Minimal Linux is based on [Minimal Linux Live by Ivan Davidov](https://github.com/ivandavidov/minimal/).
Additional information and also the original documentation for the project can be either
found in `README.orig` or in the upstream repository.

## Building
```
apt install automake libtool pkg-config # lldpd
apt install wget make gawk gcc bc bison flex xorriso libelf-dev libssl-dev xz-utils cpio file build-essential # minimal linux
cd src
./build_minimal_linux_live.sh
```
