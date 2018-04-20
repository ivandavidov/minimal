#!/bin/sh

set -e

. ../../common.sh

# Prepare the target work area.
mkdir -p "$WORK_DIR/overlay/$BUNDLE_NAME"
cd $WORK_DIR/overlay/$BUNDLE_NAME

# Remove the old sources.
rm -rf $DEST_DIR

# Create the required overlay bundle directories.
mkdir -p $DEST_DIR/usr/src
mkdir -p $DEST_DIR/etc/autorun

# Copy all source files to '/usr/src'.
cp $MAIN_SRC_DIR/*.sh $DEST_DIR/usr/src
cp $MAIN_SRC_DIR/.config $DEST_DIR/usr/src
cp $MAIN_SRC_DIR/README $DEST_DIR/usr/src
cp $MAIN_SRC_DIR/*.txt $DEST_DIR/usr/src

# Copy all source directories to '/usr/src'.
for MINIMAL_DIR in `ls -d $MAIN_SRC_DIR/minimal*/` ; do
  cp -r $MINIMAL_DIR $DEST_DIR/usr/src
done

# Copy the helper 'autorun' script.
cp $SRC_DIR/90_src.sh $DEST_DIR/etc/autorun

cd $DEST_DIR/usr/src

# Delete the '.keep' files which we use in order to keep track of otherwise
# empty folders.
find * -type f -name '.keep' -exec rm {} +

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/* \
  $OVERLAY_ROOTFS

# Prepare the 'tar.xz' source archive - BEGIN.

# Generate helper variables.
DATE_PARSED=`LANG=en_US ; date +"%d-%b-%Y"`
ARCHIVE_PREFIX=minimal_linux_live_
ARCHIVE_DIR=${ARCHIVE_PREFIX}${DATE_PARSED}
ARCHIVE_FILE=${ARCHIVE_DIR}_src.tar.xz

# Remove old source artifacts.
rm -rf $WORK_DIR/overlay/$BUNDLE_NAME/${ARCHIVE_PREFIX}*

# Copy all sources to the new temporary directory.
cp -r $DEST_DIR/usr/src \
  $WORK_DIR/overlay/$BUNDLE_NAME/$ARCHIVE_DIR

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Generate the 'tar.xz' source archive.
tar -cpf - $ARCHIVE_DIR | xz -9 - \
  > $WORK_DIR/overlay/$BUNDLE_NAME/$ARCHIVE_FILE

# Prepare the 'tar.xz' source archive - END.

echo "Bundle '$BUNDLE_NAME' has been installed."

cd $SRC_DIR
