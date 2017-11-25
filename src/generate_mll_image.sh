#!/bin/sh

set -e

SRC_DIR=$PWD
STATUS=xxx
TEMP_DIR=xxx
MLL_ISO=xxx

finalWords() {
  cat << CEOF

  Minimal Linux Live image 'mll_image.tgz' has been generated.

  You can import the MLL image in Docker like this:

    docker import mll_image.tgz minimal-linux-live:latest

  Then you can run MLL container in Docker like this:

    docker run -it minimal-linux-live /bin/sh

CEOF
}

cleanup() {
  chmod -R ugo+rw $TEMP_DIR
  rm -rf $TEMP_DIR
}

buildDockerImage() {
  rm -f $SRC_DIR/mll_image.tgz
  cd $TEMP_DIR/docker_root
  tar -zcf $SRC_DIR/mll_image.tgz *
  cd $SRC_DIR
}

prepareDocker() {
  mkdir $TEMP_DIR/docker_root
  cp -r $TEMP_DIR/rootfs_extracted/* $TEMP_DIR/docker_root
  cp -r $TEMP_DIR/iso_extracted/minimal/rootfs/* $TEMP_DIR/docker_root
}

extractRootfs() {
  xz -d -k $TEMP_DIR/iso_extracted/rootfs.xz
  mkdir $TEMP_DIR/rootfs_extracted
  cp $TEMP_DIR/iso_extracted/rootfs $TEMP_DIR/rootfs_extracted
  cd $TEMP_DIR/rootfs_extracted
  cpio -F rootfs -i
  rm -f rootfs
  cd $SRC_DIR
}

extractISO() {
  xorriso -osirrox on -indev $MLL_ISO -extract / $TEMP_DIR/iso_extracted
  chmod ugo+rw $TEMP_DIR/iso_extracted
}

prepareTempDir() {
  chmod -R ugo+rw mll_docker_*
  rm -rf mll_docker_*
  TEMP_DIR=`mktemp -d mll_docker_XXXX`
}

checkPrerequsites() {
  if [ "$1" = "" ] ; then
    if [ -f minimal_linux_live.iso ] ; then
      echo "Using 'minimal_linux_live.iso' ISO image."
      MLL_ISO=minimal_linux_live.iso
    else
      echo "ISO image 'minimal_linux_live.iso' does not exist. Cannot continue."
      exit 1
    fi
  elif [ ! -f "$1" ] ; then
    echo "Cannot locate ISO image `$1`. Cannot continue."
    exit 1
  else
    MLL_ISO=$1
  fi

  STATUS=OK

  if [ "`which docker`" = "" ] ; then
    STATUS=ERROR
    echo "ERROR: Cannot locate 'docker'."
  fi

  if [ "`which xorriso`" = "" ] ; then
    STATUS=ERROR
    echo "ERROR: Cannot locate 'xorriso'."
  fi

  if [ "$STATUS" = "ERROR" ] ; then
    echo "You have to install 'docker' and 'xorriso'. Cannot continue."
    exit 1
  fi
}

main() {
  checkPrerequsites "$@"
  prepareTempDir
  extractISO
  extractRootfs
  prepareDocker
  buildDockerImage
  cleanup
  finalWords
}

main "$@"
