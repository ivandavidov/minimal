#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME
mv `ls -d *` $BUNDLE_NAME

mkdir opt
mv graalvm opt

# Remove the unnecessary Java sources which just take valuable space.
rm -f opt/graalvm/src.zip

mkdir $WORK_DIR/overlay/$BUNDLE_NAME/bin
cd $WORK_DIR/overlay/$BUNDLE_NAME/bin

# Read the additional languages to install.
GRAALVM_LANGUAGES=`read_property GRAALVM_LANGUAGES`

LANGUAGES_LIST="$(echo $GRAALVM_LANGUAGES | tr ',' ' ')"

# Install the additional languages
for LANGUAGE in $LANGUAGES_LIST
do
  ./../opt/$BUNDLE_NAME/bin/gu -c install org.graalvm.$LANGUAGE
done

for FILE in $(ls ../opt/$BUNDLE_NAME/bin)
do
  ln -s ../opt/$BUNDLE_NAME/bin/$FILE $FILE
done

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $WORK_DIR/overlay/$BUNDLE_NAME/* \
  $OVERLAY_ROOTFS

echo "GraalVM has been installed."

cd $SRC_DIR
