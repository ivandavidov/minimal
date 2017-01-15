#!/bin/sh

SRC_DIR=$(pwd)

# Find the main source directory
cd ../../..
MAIN_SRC_DIR=$(pwd)
cd $SRC_DIR

echo "Removing old Apache Felix artifacts. This may take a while..."
rm -rf $MAIN_SRC_DIR/work/overlay/felix/felix_installed
mkdir -p $MAIN_SRC_DIR/work/overlay/felix/felix_installed/opt/felix
mkdir -p $MAIN_SRC_DIR/work/overlay/felix/felix_installed/bin

cd $MAIN_SRC_DIR/work/overlay/felix
cd $(ls -d felix-*)

cat << CEOF > bin/felix-start.sh
#!/bin/sh

cd /opt/felix
java -jar bin/felix.jar

CEOF

chmod +rx bin/felix-start.sh

cp -r * $MAIN_SRC_DIR/work/overlay/felix/felix_installed/opt/felix

cd $MAIN_SRC_DIR/work/overlay/felix/felix_installed

ln -s ../opt/felix/bin/felix-start.sh bin/felix-start

cp -r $MAIN_SRC_DIR/work/overlay/felix/felix_installed/* \
  $MAIN_SRC_DIR/work/src/minimal_overlay/rootfs

echo "Apache Felix has been installed."

cd $SRC_DIR

