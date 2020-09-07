# Common Properties And Functions

* [Properties](#properties)
* [Functions](#functions)

---

The shell script file [common.sh](https://github.com/ivandavidov/minimal/blob/master/src/common.sh) is sourced in all MLL scripts. It provides common properties and functions.

## Properties

#### SRC_DIR

``SRC_DIR=src/``

This is the main source directory, i.e. the property references the main project directory ``src/``.

#### CONFIG

``CONFIG=src/.config``

This is the main configuration file. The configuration properties are described [here](TODO...). 

#### SOURCE_DIR

``SOURCE_DIR=src/source/``

This is the directory where all source archives are downloaded. 

#### WORK_DIR

``WORK_DIR=src/work/``

This is the directory where all MLL artifacts are processed. All build actions happen in this directory. 

#### KERNEL_INSTALLED

``KERNEL_INSTALLED=src/work/kernel/kernel_installed/``

This is the directory where the kernel and its corresponding header files are placed after the kernel build phase has been completed. 

#### GLIBC_OBJECTS

``GLIBC_OBJECTS=src/work/glibc/glibc_objects/``

TODO...

#### GLIBC_INSTALLED

``GLIBC_INSTALLED=src/work/glibc/glibc_installed/``

TODO...

#### BUSYBOX_INSTALLED

``BUSYBOX_INSTALLED=src/work/busybox/busybox_installed/``

TODO...

#### SYSROOT

``SYSROOT=src/work/sysroot/``

TODO...

#### ROOTFS

``ROOTFS=src/work/rootfs/``

TODO...

#### OVERLAY_ROOTFS

``OVERLAY_ROOTFS=src/work/overlay_rootfs/``

TODO...

#### ISOIMAGE

``OVERLAY_ROOTFS=src/work/isoimage/``

TODO...

#### ISOIMAGE_OVERLAY

``OVERLAY_ROOTFS=src/work/isoimage_overlay/``

TODO...

## Functions

#### read_property(prop_name)

This function reads properties from the main ``.config`` file.

```bash
# Example

JOB_FACTOR=`read_property JOB_FACTOR`
```

#### download_source(url, file_to_save)

This function downloads the ``url`` resource and saves it as ``$file_to_save``.

```bash
# Example
#
# This is the filesystem structure before the execution
# of the function.
#
# src/
# └── source/
#     └── (no files/folders)

download_source \
  'https://busybox.net/downloads/busybox-1.32.0.tar.bz2' \
  $SOURCE_DIR/busybox-1.32.0.tar.bz2
  
# This is the filesystem structure after the execution
# of the function.
#
# src/
# └── source/
#     └── busybox-1.32.0.tar.bz2
```

#### extract_source(archive_file, dest_dir)

This function extracts the archive ``archive_file`` in the directory ``src/work/$dest_dir/``.

```bash
# Example
#
# This is the filesystem structure before the execution
# of the function.
#
# src/
# ├── source/
# │   └── busybox-1.32.0.tar.bz2
# └── work/
#     └── (no files/folders)

extract_source \
  $SOURCE_DIR/busybox-1.32.0.tar.bz2 \
  busybox
  
# This is the filesystem structure after the execution
# of the function.
#
# src/
# ├── source/
# │   └── busybox-1.32.0.tar.bz2
# └── work/
#     └── busybox
#         └── busybox-1.32.0/
```

