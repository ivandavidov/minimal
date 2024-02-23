#!/bin/sh

set -e

mkdir -p minimal_overlay/rootfs/etc/autorun
cat << CEOF > minimal_overlay/rootfs/etc/autorun/99_autoshutdown.sh
#!/bin/sh

# This script shuts down the OS automatically.
sleep 10 && poweroff &

echo "  Minimal Linux Live will shut down in 10 seconds."

CEOF
chmod +x minimal_overlay/rootfs/etc/autorun/99_autoshutdown.sh

cat <<CEOF > minimal_boot/bios/boot/syslinux/syslinux.cfg
SERIAL 0
DEFAULT operatingsystem
LABEL operatingsystem
    LINUX /boot/kernel.xz
    APPEND console=tty0 console=ttyS0
    INITRD /boot/rootfs.xz

CEOF

./repackage.sh
qemu-system-x86_64 -m 128M -cdrom minimal_linux_live.iso -boot d -nographic &
QEMU_PID=$!

sleep 5
if [ "`ps -ef | grep $QEMU_PID | grep -v grep | wc -l`" -eq 0 ] ; then
  echo "`date` | !!! FAILURE !!! Minimal Linux Live is not running in QEMU."
  exit 1
else
  echo "`date` | Minimal Linux Live is running in QEMU. Waiting for automatic shutdown."
fi

RETRY=10
while [ ! "$RETRY" = "0" ] ; do
  echo "`date` | Countdown: $RETRY"
  if [ "`ps -ef | grep $QEMU_PID | grep -v grep | wc -l`" -eq 0 ] ; then
    break
  fi
  sleep 30
  RETRY=$(($RETRY - 1))
done

if [ "`ps -ef | grep $QEMU_PID | grep -v grep | wc -l`" -eq 0 ] ; then
  echo "`date` | Minimal Linux Live is not running in QEMU."
else
  echo "`date` | !!! FAILURE !!! Minimal Linux Live is still running in QEMU."
  kill $QEMU_PID
  exit 1
fi

cat << CEOF

  ##################################################################
  #                                                                #
  #  QEMU test passed. Clean manually the affected MLL artifacts.  #
  #                                                                #
  ##################################################################

CEOF

echo "`date` | *** MLL QEMU test - END ***"

set +e
