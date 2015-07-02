#!/bin/sh

. $(dirname $(readlink -f $0 2>/dev/null))/.config

rm -rf ${SCRIPTDIR}/work/rootfs

cp -R ${SCRIPTDIR}/work/busybox/busybox-${BUSYBOX_VERSION}/_install ${SCRIPTDIR}/work/rootfs

rm -f ${SCRIPTDIR}/work/rootfs/linuxrc

mkdir -p ${SCRIPTDIR}/work/rootfs/dev ${SCRIPTDIR}/work/rootfs/etc ${SCRIPTDIR}/work/rootfs/proc ${SCRIPTDIR}/work/rootfs/root ${SCRIPTDIR}/work/rootfs/sys ${SCRIPTDIR}/work/rootfs/tmp
chmod 1777 ${SCRIPTDIR}/work/rootfs/tmp

-cat > ${SCRIPTDIR}/work/rootfs/etc/bootscript.sh << EOF
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

# add localized keymap
# create a keymap with dumpkeys | loadkeys -b > ${SCRIPTDIR}/addons/keymap.${KEYMAP}
if [ -e "${SCRIPTDIR}/addons/keymap.${KEYMAP}" ] ; then
	cp "${SCRIPTDIR}/addons/keymap.${KEYMAP}" ${SCRIPTDIR}/work/rootfs/etc/
	echo "loadkmap < /etc/keymap.${KEYMAP}" >> ${SCRIPTDIR}/work/rootfs/etc/bootscript.sh
fi

cat > ${SCRIPTDIR}/work/rootfs/etc/rc.dhcp << EOF
#!/bin/sh

ip addr add \$ip/\$mask dev \$interface

if [ -n "$router"]; then
ip route add default via \$router dev \$interface
fi

EOF

cat > ${SCRIPTDIR}/work/rootfs/etc/welcome.txt << EOF

#####################################
#                                   #
#  Welcome to "Minimal Linux Live"  #
#                                   #
#####################################

EOF

cat > ${SCRIPTDIR}/work/rootfs/etc/inittab << EOF
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

cat > ${SCRIPTDIR}/work/rootfs/init << EOF
#!/bin/sh

exec /sbin/init

EOF

cp ${SCRIPTDIR}/*.sh ${SCRIPTDIR}/.config src
chmod +r src/*.sh src/.config

chmod +x ${SCRIPTDIR}/work/rootfs/init ${SCRIPTDIR}/work/rootfs/etc/bootscript.sh ${SCRIPTDIR}/work/rootfs/etc/rc.dhcp
