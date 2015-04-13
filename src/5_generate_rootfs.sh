#!/bin/sh

if [ -z "$BASE_DIR" ]; then
	# Standalone execution
	BASE_DIR="`pwd`"
	. $BASE_DIR/.vars
fi

cd $WORK_DIR

rm -rf rootfs

cd $BUSYBOX_DIR

cp -R _install $ROOTFS
cd $ROOTFS

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

cat > bootscript.sh << EOF
#!/bin/sh

dmesg -n 1
mount -t devtmpfs none /dev
mount -t proc none /proc
mount -t sysfs none /sys

EOF

chmod +x bootscript.sh

cat > welcome.txt << EOF

  #####################################
  #                                   #
  #  Welcome to "Minimal Linux Live"  #
  #                                   #
  #####################################

EOF

cat > inittab << EOF
::sysinit:/etc/bootscript.sh
::restart:/sbin/init
::ctrlaltdel:/sbin/reboot
::once:cat /etc/welcome.txt
::respawn:/bin/cttyhack /bin/sh
tty2::once:cat /etc/welcome.txt
tty2::respawn:/bin/sh
tty3::once:cat /etc/welcome.txt
tty3::respawn:/bin/sh
tty4::once:cat /etc/welcome.txt
tty4::respawn:/bin/sh

EOF

cd ..

cat > init << EOF
#!/bin/sh

exec /sbin/init

EOF

chmod +x init

cp $BASE_DIR/*.sh src
cp $BASE_DIR/.config src
cp $BASE_DIR/.vars src
chmod +r src/*.sh
chmod +r src/.config

cd $BASE_DIR

