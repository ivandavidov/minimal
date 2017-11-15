#!/bin/sh

SRC_DIR=$(pwd)

. ../../common.sh

# Grab everything after the '=' character.
DOWNLOAD_URL=$(grep -i KBD_SOURCE_URL $MAIN_SRC_DIR/.config | cut -f2 -d'=')

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

# Read the 'USE_LOCAL_SOURCE' property from '.config'
USE_LOCAL_SOURCE="$(grep -i USE_LOCAL_SOURCE $MAIN_SRC_DIR/.config | cut -f2 -d'=')"

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
echo "Removing kbd work area. This may take a while..."
rm -rf $WORK_DIR/overlay/kbd
mkdir $WORK_DIR/overlay/kbd

# Extract kbd to folder 'work/overlay/kbd'.
# Full path will be something like 'work/overlay/kbd/kbd-2.04'.
tar -xvf $ARCHIVE_FILE -C $WORK_DIR/overlay/kbd

cd "$WORK_DIR/overlay/kbd"

cd $(ls -d kbd-*)

# rename keymaps with the same name
mv data/keymaps/i386/qwertz/cz{,-qwertz}.map
mv data/keymaps/i386/olpc/es{,-olpc}.map
mv data/keymaps/i386/olpc/pt{,-olpc}.map
mv data/keymaps/i386/dvorak/no{,-dvorak}.map
mv data/keymaps/i386/fgGIod/trf{,-fgGIod}.map
mv data/keymaps/i386/colemak/{en-latin9,colemak}.map

cd $SRC_DIR

