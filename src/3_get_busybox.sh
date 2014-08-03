#/bin/sh

DOWNLOAD_URL=$(grep -i BUSYBOX_SOURCE_URL .config | cut -f2 -d'=')
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

cd work
rm -f $ARCHIVE_FILE
wget $DOWNLOAD_URL
rm -rf busybox
mkdir busybox
tar -xvf $ARCHIVE_FILE -C busybox
cd ..

