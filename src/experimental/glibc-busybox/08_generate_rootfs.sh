#!/bin/sh

cd work/glibc
cd $(ls -d *)
cd glibc_installed
GLIBC_INSTALLED=$(pwd)

cd ../../../..

cd work

rm -rf rootfs

cd busybox
cd $(ls -d *)

# Copy all BusyBox generated stuff to the location of our "initramfs" folder.
cp -R _install ../../rootfs
cd ../../rootfs

# Remove "linuxrc" which is used when we boot in "RAM disk" mode. 
rm -f linuxrc

# Create root FS folders
mkdir dev
mkdir etc
mkdir proc
mkdir root
mkdir src
mkdir sys
mkdir tmp

# "1" means that only the owner of a file/directory (or root) can remove it.
chmod 1777 tmp

cd etc

# The script "/etc/bootscript.sh" is automatically executed as part of the
# "init" proess. We suppress most kernel messages, mount all crytical file
# systems, loop through all available network devices and we configure them
# through DHCP.
cat > bootscript.sh << EOF
#!/bin/sh

dmesg -n 1
mount -t devtmpfs none /dev
mount -t proc none /proc
mount -t sysfs none /sys

for DEVICE in /sys/class/net/* ; do
  ip link set \${DEVICE##*/} up
  [ \${DEVICE##*/} != lo ] && udhcpc -b -i \${DEVICE##*/} -s /etc/rc.dhcp
done

EOF

chmod +x bootscript.sh

# The script "/etc/rc.dhcp" is automatically invoked for each network device. 
cat > rc.dhcp << EOF
#!/bin/sh

ip addr add \$ip/\$mask dev \$interface

if [ "\$router" ]; then
  ip route add default via \$router dev \$interface
fi

EOF

chmod +x rc.dhcp

# DNS resolving is done by using Google's public DNS servers
cat > resolv.conf << EOF
nameserver 8.8.8.8
nameserver 8.8.4.4

EOF

# The file "/etc/welcome.txt" is displayed on every boot of the system in each
# available terminal.
cat > welcome.txt << EOF

  #####################################
  #                                   #
  #  Welcome to "Minimal Linux Live"  #
  #                                   #
  #####################################

EOF

# The file "/etc/inittab" contains the configuration which defines how the
# system will be initialized. Check the following URL for more details:
# http://git.busybox.net/busybox/tree/examples/inittab
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

cat > nsswitch.conf << EOF
passwd:     db files nis
shadow:     files
group:      db files nis

hosts:      files nisplus nis dns
networks:   nisplus [NOTFOUND=return] files

ethers:     nisplus [NOTFOUND=return] db files
protocols:  nisplus [NOTFOUND=return] db files
rpc:        nisplus [NOTFOUND=return] db files
services:   nisplus [NOTFOUND=return] db files

EOF

cd ..

# The "/init" script passes the execution to "/sbin/init" which in turn looks
# for the configuration file "/etc/inittab".
cat > init << EOF
#!/bin/sh
echo "1111111111111111"
echo "1111111111111111"
echo "1111111111111111"
PATH=/lib:$PATH
export PATH
exec /sbin/init

EOF

chmod +x init

# Copy all source files to "/src". Note that the scripts won't work there.
cp ../../*.sh src
cp ../../.config src
cp ../../*.txt src
chmod +rx src/*.sh
chmod +r src/.config
chmod +r src/*.txt

#cd bin
#cp -r $GLIBC_INSTALLED/lib/* .
#cd ..
cp -r $GLIBC_INSTALLED/* .

cd ../..

