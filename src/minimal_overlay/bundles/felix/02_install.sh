#!/bin/sh

SRC_DIR=$(pwd)

echo "Removing old Apache Felix artifacts. This may take a while..."
rm -rf $SRC_DIR/work/overlay/felix/felix_installed
mkdir -p $SRC_DIR/work/overlay/felix/felix_installed/opt/felix
mkdir -p $SRC_DIR/work/overlay/felix/felix_installed/bin

cd $SRC_DIR/work/overlay/felix
cd $(ls -d felix-*)

cat << CEOF > bin/felix-start.sh
#!/bin/sh

cd /opt/felix
java -jar bin/felix.jar

CEOF

chmod +rx bin/felix-start.sh

cp -r * $SRC_DIR/work/overlay/felix/felix_installed/opt/felix

cd $SRC_DIR/work/overlay/felix/felix_installed

ln -s ../opt/felix/bin/felix-start.sh bin/felix-start

cp -r $SRC_DIR/work/overlay/felix/felix_installed/* \
  $SRC_DIR/work/src/minimal_overlay

echo "Apache Felix has been installed."

cd $SRC_DIR

