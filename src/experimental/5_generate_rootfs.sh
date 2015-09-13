#!/bin/sh

cd work

rm -rf rootfs
mkdir rootfs

cd toybox
cd $(ls -d *)

# Copy all toybox generated stuff to the location of our "initramfs" folder.
cp -R rootfs ../../rootfs/bin
cd ../../rootfs

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

# The file "/etc/welcome.txt" is displayed on every boot of the system in each
# available terminal.
cat > welcome.txt << EOF

  #####################################
  #                                   #
  #  Welcome to "Minimal Linux Live"  #
  #                                   #
  #####################################

EOF

cd ..

# Problem setting default path
cat > init << EOF
#!/bin/sh
dmesg -n 1

mount -t devtmpfs none /dev
mount -t proc none /proc
mount -t sysfs none /sys

ifconfig eth0 up
dhcp -i eth0

cat /etc/welcome.txt

sh

poweroff
EOF

chmod +rx init

# Copy all source files to "/src". Note that the scripts won't work there.
cp ../../*.sh src
cp ../../.config src
chmod +r src/*.sh
chmod +r src/.config

cd ../..

