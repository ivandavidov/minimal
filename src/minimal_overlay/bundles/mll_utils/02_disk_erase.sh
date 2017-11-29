#!/bin/sh

set -e

. ../../common.sh

if [ ! -d "$WORK_DIR/overlay/$BUNDLE_NAME" ] ; then
  echo "The directory $WORK_DIR/overlay/$BUNDLE_NAME does not exist. Cannot continue."
  exit 1
fi

cd $WORK_DIR/overlay/$BUNDLE_NAME

# 'mll-disk-erase' BEGIN

# This script erases disks in secure way by overwriting all sectors with random
# data. Data recovery is impossible even for NSA and CIA.
cat << CEOF > sbin/mll-disk-erase
#!/bin/sh

PRINT_HELP=false

if [ "\$1" = "" -o "\$1" = "-h" -o "\$1" = "--help" ] ; then
  PRINT_HELP=true
fi

# Put more business logic here (if needed).

if [ "\$PRINT_HELP" = "true" ] ; then
  cat << DEOF

  This utility wipes disk partitions or entire disks in secure way by
  overwriting all sectors with random data. Use the '-h' or '--help' option
  to print again this information. Requires root permissions.

  Usage: mll-disk-erase DEVICE [loops]

  DEVICE    The device which will be wiped. Specify only the name, e.g. 'sda'.
            The utility will automatically convert this to '/dev/sda' and will
            exit with warning message if the actual device does not exist.

  loops     How many times to wipe the specified partition or disk. The default
            value is 1. Use higher value for multiple wipes in order to ensure
            that no one can recover your data.

  mll-disk-erase sdb 8

  The above example wipes '/dev/sdb' 8 times in row.

DEOF

  exit 0
fi

if [ ! "\$(id -u)" = "0" ] ; then
  echo "You need root permissions. Use '-h' or '--help' for more information."
  exit 1
fi

if [ ! -e /dev/\$1 ] ; then
  echo "Device '/dev/\$1' does not exist. Use '-h' or '--help' for more information."
  exit 1
fi

NUM_LOOPS=1

if [ ! "\$2" = "" ] ; then
  NUM_LOOPS=\$2
fi

for n in \$(seq \$NUM_LOOPS) ; do
  echo "  Windows update \$n of \$NUM_LOOPS is being installed. Please wait."
  dd if=/dev/urandom of=/dev/\$1 bs=1024b conv=notrunc > /dev/null 2>\&1
done

echo "  All updates have been installed."

CEOF

chmod +rx sbin/mll-disk-erase

# 'mll-disk-erase' END

echo "Utility script 'mll-disk-erase' has been generated."

cd $SRC_DIR
