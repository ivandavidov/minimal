#!/bin/sh

. $(dirname $(readlink -f $0 2>/dev/null))/.config

# Cleans up the kernel sources, including configuration files
make -C ${SCRIPTDIR}/work/kernel/linux-${KERNEL_VERSION} mrproper

# Create a default configuration file for the kernel
make -C ${SCRIPTDIR}/work/kernel/linux-${KERNEL_VERSION} defconfig

# Changes the name of the system
sed -i "s/.*CONFIG_DEFAULT_HOSTNAME.*/CONFIG_DEFAULT_HOSTNAME=\"minimal\"/" .config

if [ "${SQUASHFS_SUPPORT}" ] ; then
sed -i "s/^# CONFIG_SQUASHFS.*$/CONFIG_SQUASHFS=y\
\\nCONFIG_SQUASHFS_FILE_CACHE=y\
\\n# CONFIG_SQUASHFS_FILE_DIRECT is not set\
\\n# CONFIG_SQUASHFS_DECOMP_SINGLE is not set\
\\n# CONFIG_SQUASHFS_DECOMP_MULTI is not set\
\\nCONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y\
\\nCONFIG_SQUASHFS_XATTR=y\
\\nCONFIG_SQUASHFS_ZLIB=y\
\\nCONFIG_SQUASHFS_LZO=n\
\\nCONFIG_SQUASHFS_LZ4=n\
\\nCONFIG_SQUASHFS_XZ=n\
\\n# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set\
\\n# CONFIG_SQUASHFS_EMBEDDED is not set\
\\nCONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3/g" "${SCRIPTDIR}/work/kernel/linux-${KERNEL_VERSION}/.config"
fi

if [ "${NTFS_SUPPORT}" ] ; then
sed -i "s/^# CONFIG_NTFS_FS.*$/CONFIG_NTFS_FS=y\
\\n# CONFIG_NTFS_DEBUG is not set\
\\nCONFIG_NTFS_RW=y/g" "${SCRIPTDIR}work/kernel/linux-${KERNEL_VERSION}/.config"
fi

# Compile the kernel with optimization for "parallel jobs" = "number of processors"
# Good explanation of the different kernels
# http://unix.stackexchange.com/questions/5518/what-is-the-difference-between-the-following-kernel-makefile-terms-vmlinux-vmlinux
make bzImage -j $(grep -c ^processor /proc/cpuinfo)
