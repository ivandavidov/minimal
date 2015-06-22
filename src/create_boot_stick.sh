#!/bin/sh

. ./.config

for DRIVE in /sys/block/sd? ; do
	if [ "$(cat ${DRIVE}/removable)" -eq 1 ] ; then
		DEVICE="/dev/${DRIVE##*/}"
		MOUNTPATH="$(mount | grep -Po "(?<=${DEVICE} on |${DEVICE}. on )\S+" | tail -1)"
		break
	fi
done

if [ ! "${MOUNTPATH}" ] ; then
	echo "no pen drive found"
	exit 1
fi

if mount | grep -q ${MOUNTPATH} ; then
	umount ${MOUNTPATH}
fi

fdisk ${DEVICE%[0-9]} <<EOF
o
n
p
1
2048

t
c
w
EOF

COUNT=0
until MOUNTPATH="$(mount | grep -Po "(?<=${DEVICE%[0-9]}1 on )\S+")" ; do
	COUNT=$((COUNT+1))
	if [ ${COUNT} -eq 10 ] ; then
		echo "${DEVICE%[0-9]}1 could not be mounted."
		break
	fi
	echo "wait for automount of ${DEVICE%[0-9]}1"
	sleep 1
done

umount ${DEVICE%[0-9]}1 || true
mkdosfs -F 32 ${DEVICE%[0-9]}1 -n CCUPDATE

COUNT=0
until MOUNTPATH="$(mount | grep -Po "(?<=${DEVICE%[0-9]}1 on )\S+")" ; do
	COUNT=$((COUNT+1))
	if [ ${COUNT} -eq 10 ] ; then
		echo "${DEVICE%[0-9]}1 could not be mounted."
		break
	fi
	echo "wait for automount of ${DEVICE%[0-9]}1"
	sleep 1
done

dd if=/usr/lib/syslinux/mbr.bin of=${DEVICE%[0-9]} bs=440 count=1 conv=notrunc 
if ! fdisk -l ${DEVICE%[0-9]} | grep -q "${DEVICE%[0-9]}1   \*" ; then
fdisk ${DEVICE%[0-9]} <<EOF
a
1
w
EOF
fi

7z x -y -x\!isolinux.bin -x\!boot.cat -x\![BOOT] -o"${MOUNTPATH}/" ${SCRIPTDIR}/${TARGETFILE}
mv -f "${MOUNTPATH}/isolinux.cfg" "${MOUNTPATH}/syslinux.cfg"
sync
sudo syslinux ${DEVICE%[0-9]}1
