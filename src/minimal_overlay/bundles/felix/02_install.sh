#!/bin/sh

set -e

. ../../common.sh

echo "Removing old 'Apache Felix' artifacts. This may take a while."
rm -rf $DEST_DIR
mkdir -p $DEST_DIR/opt/felix
mkdir -p $DEST_DIR/bin
mkdir -p $DEST_DIR/etc/autorun

cd $WORK_DIR/overlay/felix
cd $(ls -d felix-*)

cat << CEOF > bin/felix-start.sh
#!/bin/sh

cd /opt/felix
java -jar bin/felix.jar

CEOF

chmod +rx bin/felix-start.sh

cp -r * $DEST_DIR/opt/felix
cp $SRC_DIR/90_felix.sh $DEST_DIR/etc/autorun

cd $DEST_DIR

ln -s ../opt/felix/bin/felix-start.sh bin/felix-start

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/* \
  $OVERLAY_ROOTFS

echo "Bundle 'Apache Felix' has been installed."

cd $SRC_DIR

