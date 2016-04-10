#!/bin/sh

# Find the glibc installation area.
cd work/glibc
cd $(ls -d *)
cd glibc_installed
GLIBC_INSTALLED=$(pwd)

cd ../../../..

cd work

rm -rf rootfs

cd busybox

# Change to the first directory ls finds, e.g. 'busybox-1.24.2'.
cd $(ls -d *)

# Copy all BusyBox generated stuff to the location of our 'initramfs' folder.
cp -R _install ../../rootfs
cd ../../rootfs

# Remove 'linuxrc' which is used when we boot in 'RAM disk' mode. 
rm -f linuxrc

# Create the missing root FS folders.
mkdir etc
mkdir dev
mkdir lib
mkdir mnt
mkdir proc
mkdir root
mkdir src
mkdir sys
mkdir tmp

cd etc

# The script '/etc/prepare.sh' is automatically executed as part of the '/init'
# process. We suppress most kernel messages and mount all cryitical file systems.
cat > prepare.sh << EOF
#!/bin/sh

dmesg -n 1

mount -t devtmpfs none /dev
mount -t proc none /proc
mount -t tmpfs none /tmp -o mode=1777
mount -t sysfs none /sys

EOF

chmod +x prepare.sh

# The script '/etc/switch.sh' is automatically executed as part of the '/init'
# process. We overlay the '/minimal/rootfs' folder from the boot media, copy all
# files and folders to new mountpoint and then execute the command 'switch_root'.
cat > switch.sh << EOF
#!/bin/sh

# Create the new mountpoint in RAM.
mount -t tmpfs none /mnt

# Create folders for all critical file systems.
echo "Create folders for all critical file systems..."
mkdir /mnt/dev
mkdir /mnt/sys
mkdir /mnt/proc
mkdir /mnt/tmp
echo "...done."

# Copy root folders in the new mountpoint.
echo "Copying the root file system to /mnt..."
cp -a bin etc lib lib64 root sbin src usr /mnt
echo "...done."

mkdir /tmp/mnt
echo "Searching available devices for /minimal/rootfs folder..."
for DEVICE in /dev/* ; do
  DEV=\$(echo "\${DEVICE##*/}")
  SYSDEV=\$(echo "/sys/class/block/\$DEV")

  case \$DEV in
    *loop*) continue ;;
  esac

  if [ ! -d "\$SYSDEV" ] ; then
    continue
  fi

  mount \$DEVICE /tmp/mnt 2>/dev/null
  if [ -d /tmp/mnt/minimal/rootfs ] ; then
    echo "  Found /minimal/rootfs folder on device \$DEV."
    
    touch /tmp/mnt/minimal/rootfs/minimal.pid 2>/dev/null
    if [ -f /tmp/mnt/minimal/rootfs/minimal.pid ] ; then
      echo "  Trying to overlay in read/write mode..."
      rm -f /tmp/mnt/minimal/rootfs/minimal.pid
      mount -t overlay -o lowerdir=/mnt,upperdir=/tmp/mnt/minimal/rootfs,workdir=/tmp/mnt/minimal/work none /mnt
      OUT=\$?
      if [ ! "\$OUT" = "0" ] ; then
        echo "  Mount failed (probably on vfat), moving on with other devices."
        continue
      fi
    else
      echo "  Trying to overlay in read only mode..."
      mkdir -p /tmp/minimal/work
      mkdir -p /tmp/minimal/rootfs
      mount -t overlay -o lowerdir=/mnt:/tmp/mnt/minimal/rootfs,upperdir=/tmp/minimal/rootfs,workdir=/tmp/minimal/work none /mnt
    fi
    
    echo "  ...done."
    
    break
  else
    umount /tmp/mnt 2>/dev/null
  fi
done
echo "...done."

# Move critical file systems to the new mountpoint.
echo "Remounting /dev, /sys, /tmp and /proc in /mnt..."
mount --move /dev /mnt/dev
mount --move /sys /mnt/sys
mount --move /proc /mnt/proc
mount --move /tmp /mnt/tmp
echo "...done."

# The new mountpoint becomes file system root. All original root folders are
# deleted automatically as part of the command execution. The '/sbin/init' 
# process is invoked and it becomes the new PID 1 parent process.
exec switch_root /mnt /sbin/init

echo "You can never see this... unless there is a serious bug..."
sleep 99999

EOF

chmod +x switch.sh

# The script '/etc/bootscript.sh' is automatically executed as part of the
# '/sbin/init' proess. All core boot configuration has been completed and now we
# need to do the rest of the configuration on the user space level. Here we loop
# through all available network devices and we configure them through DHCP.
cat > bootscript.sh << EOF
#!/bin/sh

echo "Welcome to \"Minimal Linux Live\" (/sbin/init)"

for DEVICE in /sys/class/net/* ; do
  echo "Found network device \${DEVICE##*/}" 
  ip link set \${DEVICE##*/} up
  [ \${DEVICE##*/} != lo ] && udhcpc -b -i \${DEVICE##*/} -s /etc/rc.dhcp
done

EOF

chmod +x bootscript.sh

# The script '/etc/rc.dhcp' is automatically invoked for each network device. 
cat > rc.dhcp << EOF
#!/bin/sh

ip addr add \$ip/\$mask dev \$interface

if [ "\$router" ]; then
  ip route add default via \$router dev \$interface
fi

if [ "\$ip" ]; then
  echo "DHCP configuration for device \$interface"
  echo "ip:     \$ip"
  echo "mask:   \$mask"
  echo "router: \$router"
fi

EOF

chmod +x rc.dhcp

# DNS resolving is done by using Google's public DNS servers.
cat > resolv.conf << EOF
nameserver 8.8.8.8
nameserver 8.8.4.4

EOF

# The file '/etc/welcome.txt' is displayed on every boot of the system in each
# available terminal.
cat > welcome.txt << EOF

  #####################################
  #                                   #
  #  Welcome to "Minimal Linux Live"  #
  #                                   #
  #####################################

EOF

# The file '/etc/inittab' contains the configuration which defines how the
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

cd ..

# The '/init' script is the first place where we gain execution control after
# the kernel has been loaded. This script prepares the core file systems, then
# creates new mountpoint in RAM which we use as new root location and finally
# the execution is passed to the script '/sbin/init' which in turn looks for
# the configuration file '/etc/inittab'.
cat > init << EOF
#!/bin/sh

echo "Welcome to \"Minimal Linux Live\" (/init)"

# Let's mount all core file systems.
/etc/prepare.sh

# Now let's create new mountpoint in RAM and make it our new root location.
exec /etc/switch.sh

EOF

chmod +x init

# Copy all source files to '/src'. Note that the scripts won't work there.
cp ../../*.sh src
cp ../../.config src
cp ../../*.txt src
chmod +rx src/*.sh
chmod +r src/.config
chmod +r src/*.txt

# Copy all necessary 'glibc' libraries to '/lib' BEGIN.

# This is the dynamic loader. The file name is different for 32-bit and 64-bit machines.
cp $GLIBC_INSTALLED/lib/ld-linux* ./lib

# BusyBox has direct dependencies on these libraries.
cp $GLIBC_INSTALLED/lib/libm.so.6 ./lib
cp $GLIBC_INSTALLED/lib/libc.so.6 ./lib

# These libraries are necessary for the DNS resolving.
cp $GLIBC_INSTALLED/lib/libresolv.so.2 ./lib
cp $GLIBC_INSTALLED/lib/libnss_dns.so.2 ./lib

# Make sure the dynamic loader is visible on 64-bit machines.
ln -s lib lib64

# Copy all necessary 'glibc' libraries to '/lib' END.

cd ../..

