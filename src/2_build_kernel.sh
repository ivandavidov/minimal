#/bin/sh

cd work/kernel
cd $(ls -d *)
make clean
make defconfig
sed -i "s/.*CONFIG_DEFAULT_HOSTNAME.*/CONFIG_DEFAULT_HOSTNAME=\"minimal-linux-live\"/" .config
make vmlinux
cd ../../..

