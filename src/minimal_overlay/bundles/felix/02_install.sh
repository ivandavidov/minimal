#!/bin/sh

SRC_DIR=$(pwd)

. ../../common.sh

echo "Removing old Apache Felix artifacts. This may take a while..."
rm -rf $WORK_DIR/overlay/felix/felix_installed
mkdir -p $WORK_DIR/overlay/felix/felix_installed/opt/felix
mkdir -p $WORK_DIR/overlay/felix/felix_installed/bin

cd $WORK_DIR/overlay/felix
cd $(ls -d felix-*)

cat << CEOF > bin/felix-start.sh
#!/bin/sh

cd /opt/felix
java -jar bin/felix.jar

CEOF

chmod +rx bin/felix-start.sh

cp -r * $WORK_DIR/overlay/felix/felix_installed/opt/felix

cd $WORK_DIR/overlay/felix/felix_installed

ln -s ../opt/felix/bin/felix-start.sh bin/felix-start

cp -r $WORK_DIR/overlay/felix/felix_installed/* \
  $WORK_DIR/src/minimal_overlay/rootfs

echo "Apache Felix has been installed."

cd $SRC_DIR

