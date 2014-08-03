#/bin/sh

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
mkdir src
mkdir sys
mkdir tmp
cd etc
touch welcome.txt
echo >> welcome.txt
echo '  #####################################' >> welcome.txt
echo '  #                                   #' >> welcome.txt
echo '  #  Welcome to "Minimal Linux Live"  #' >> welcome.txt
echo '  #                                   #' >> welcome.txt
echo '  #####################################' >> welcome.txt
echo >> welcome.txt
cd ..
touch init
echo '#!/bin/sh' >> init
echo 'dmesg -n 1' >> init
echo 'mount -t devtmpfs none /dev' >> init
echo 'mount -t proc none /proc' >> init
echo 'mount -t sysfs none /sys' >> init
echo 'cat /etc/welcome.txt' >> init
echo 'while true' >> init
echo 'do' >> init
echo '  setsid cttyhack /bin/sh' >> init
echo 'done' >> init
echo >> init
chmod +x init
cp ../../*.sh src
cp ../../.config src
cd ../..

