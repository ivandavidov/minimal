#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

download() {
  # Read the 'SYSLINUX_SOURCE_URL' property from '.config'.
  DOWNLOAD_URL=`read_property SYSLINUX_SOURCE_URL`

  # Grab everything after the last '/' character.
  ARCHIVE_FILE=${DOWNLOAD_URL##*/}

  # Download Syslinux source archive in the 'source' directory.
  download_source $DOWNLOAD_URL $SOURCE_DIR/$ARCHIVE_FILE

  # Extract the Syslinux sources in the 'work/syslinux' directory.
  extract_source $SOURCE_DIR/$ARCHIVE_FILE syslinux
}

echo "*** GET SYSLINUX BEGIN ***"

# Read the 'FIRMWARE_TYPE' property from '.config'.
FIRMWARE_TYPE=`read_property FIRMWARE_TYPE`
echo "Firmware type is '$FIRMWARE_TYPE'."

case $FIRMWARE_TYPE in
  bios)
    download
    ;;

  both)
    download
    ;;

  uefi)
    download
    ;;

  *)
    echo "Firmware type '$FIRMWARE_TYPE' is not recognized. Cannot continue."
    ;;

esac

# We go back to the main MLL source folder.
cd $SRC_DIR

echo "*** GET SYSLINUX END ***"
