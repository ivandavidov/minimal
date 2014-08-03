#/bin/sh

DOWNLOAD_URL=$(grep -i KERNEL_SOURCE_URL .config | cut -f2 -d'=')
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

cd work
rm -f $ARCHIVE_FILE
wget $DOWNLOAD_URL
rm -rf kernel
mkdir kernel
tar -xvf $ARCHIVE_FILE -C kernel
cd ..

