#!/bin/sh

set -e

. ../../common.sh

# Read the common configuration properties.
DOWNLOAD_URL=`read_property KBD_SOURCE_URL`
USE_LOCAL_SOURCE=`read_property USE_LOCAL_SOURCE`

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

if [ "$USE_LOCAL_SOURCE" = "true" -a ! -f $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE  ] ; then
  echo "Source bundle $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE is missing and will be downloaded."
  USE_LOCAL_SOURCE="false"
fi

cd $MAIN_SRC_DIR/source/overlay

if [ ! "$USE_LOCAL_SOURCE" = "true" ] ; then
  # Downloading kbd source bundle file. The '-c' option allows the download to resume.
  echo "Downloading kbd source bundle from $DOWNLOAD_URL"
  wget -c $DOWNLOAD_URL
else
  echo "Using local kbd source bundle $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE"
fi

# Delete folder with previously extracted kbd.
echo "Removing kbd work area. This may take a while."
rm -rf $WORK_DIR/overlay/$BUNDLE_NAME
mkdir $WORK_DIR/overlay/$BUNDLE_NAME

# Extract kbd to folder 'work/overlay/kbd'.
# Full path will be something like 'work/overlay/kbd/kbd-2.04'.
tar -xvf $ARCHIVE_FILE -C $WORK_DIR/overlay/$BUNDLE_NAME

cd "$WORK_DIR/overlay/$BUNDLE_NAME"

cd $(ls -d kbd-*)

# Rename keymaps with the same name BEGIN

mv data/keymaps/i386/qwertz/cz.map \
  data/keymaps/i386/qwertz/cz-qwertz.map

mv data/keymaps/i386/olpc/es.map \
  data/keymaps/i386/olpc/es-olpc.map

mv data/keymaps/i386/olpc/pt.map \
  data/keymaps/i386/olpc/pt-olpc.map

mv data/keymaps/i386/dvorak/no.map \
  data/keymaps/i386/dvorak/no-dvorak.map

mv data/keymaps/i386/fgGIod/trf.map \
  data/keymaps/i386/fgGIod/trf-fgGIod.map

mv data/keymaps/i386/colemak/en-latin9.map \
  data/keymaps/i386/colemak/colemak.map

# Rename keymaps with the same name END

cd $SRC_DIR
