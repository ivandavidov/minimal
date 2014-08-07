#!/bin/sh

cd work

rm -rf rootfs

cd busybox
cd $(ls -d *)

cp -R _install ../../rootfs
cd ../../rootfs

rm -f linuxrc

mkdir dev
mkdir etc
mkdir proc
mkdir root
mkdir src
mkdir sys
mkdir tmp
chmod 1777 tmp

cd etc

touch bootscript.sh
echo '#!/bin/sh' >> bootscript.sh
echo 'dmesg -n 1' >> bootscript.sh
echo 'mount -t devtmpfs none /dev' >> bootscript.sh
echo 'mount -t proc none /proc' >> bootscript.sh
echo 'mount -t sysfs none /sys' >> bootscript.sh
echo >> bootscript.sh
chmod +x bootscript.sh

touch welcome.txt
echo >> welcome.txt
echo '  #####################################' >> welcome.txt
echo '  #                                   #' >> welcome.txt
echo '  #  Welcome to "Minimal Linux Live"  #' >> welcome.txt
echo '  #                                   #' >> welcome.txt
echo '  #####################################' >> welcome.txt
echo >> welcome.txt

touch inittab
echo '::sysinit:/etc/bootscript.sh' >> inittab
echo '::restart:/sbin/init' >> inittab
echo '::ctrlaltdel:/sbin/reboot' >> inittab
echo '::once:cat /etc/welcome.txt' >> inittab
echo '::respawn:/bin/cttyhack /bin/sh' >> inittab
echo 'tty2::once:cat /etc/welcome.txt' >> inittab
echo 'tty2::respawn:/bin/sh' >> inittab
echo 'tty3::once:cat /etc/welcome.txt' >> inittab
echo 'tty3::respawn:/bin/sh' >> inittab
echo 'tty4::once:cat /etc/welcome.txt' >> inittab
echo 'tty4::respawn:/bin/sh' >> inittab
echo >> inittab

cd ..

touch init
echo '#!/bin/sh' >> init
echo 'exec /sbin/init' >> init
echo >> init
chmod +x init

cp ../../*.sh src
cp ../../.config src
chmod +r src/*.sh
chmod +r src/.config

cd ../..
