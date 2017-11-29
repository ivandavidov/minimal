#!/bin/sh

set -e

. ../../common.sh

echo "Removing old Apache Felix artifacts. This may take a while..."
rm -rf $DEST_DIR
mkdir -p $DEST_DIR/opt/felix
mkdir -p $DEST_DIR/bin

cd $WORK_DIR/overlay/felix
cd $(ls -d felix-*)

cat << CEOF > bin/felix-start.sh
#!/bin/sh

cd /opt/felix
java -jar bin/felix.jar

CEOF

chmod +rx bin/felix-start.sh

cp -r * $DEST_DIR/opt/felix

cd $DEST_DIR

ln -s ../opt/felix/bin/felix-start.sh bin/felix-start

cp -r $DEST_DIR/* $OVERLAYFS_ROOT

echo "Apache Felix has been installed."

cd $SRC_DIR

