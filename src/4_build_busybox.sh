#/bin/sh

cd work/busybox
cd $(ls -d *)
make clean
make defconfig
sed -i "s/.*CONFIG_STATIC.*/CONFIG_STATIC=y/" .config
make busybox
make install
cd ../../..

