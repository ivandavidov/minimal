#!/bin/sh

# Break the shell process if there are any errors
set -e

# Import common variables and functions
. ../../common.sh


# By convention, the overlay bundles have "source" folder, where the source
# code is downloaded. If the source is downloaded from internet, this allows
# the download to proceed if the process has been interrupted. In our simple
# use case we will copy the file "hello.c" and in this way we will simulate
# (kind of) that it has been downloaded.
#
# The main overlay source folder is "minimal/src/source/overlay" and the bundle
# source artifact will be "minimal/src/source/overlay/hello.c".
cp $SRC_DIR/hello.c \
  $OVERLAY_SOURCE_DIR

# The next step is to prepare the source code that we have downloaded in the
# previous step. Usually this means to extract it. By convention, each overlay
# bundle has its own root folder where all the build magic happens. In our 
# simple use case we will "extract" the source code by copying it from the
# source folder to the main bundle folder.
#
# The main overlay folder is "minimal/src/work/overlay" and the bundle overlay
# folder will be "minimal/src/work/overlay/mll_hello".
mkdir $OVERLAY_WORK_DIR/$BUNDLE_NAME
cp $OVERLAY_SOURCE_DIR/hello.c \
  $OVERLAY_WORK_DIR/$BUNDLE_NAME

# Each overlay bundle also has a special directory where all build artifacts
# are put in a structure which represents the final OS folder structure. This
# folder is "minimal/src/work/overlay/mll_hello/mll_hello_installed".

# First we create the "destination" folder.
mkdir $DEST_DIR

# We want our "hello" executable to reside in the "/bin" folder, so we create
# subfolder "bin" in "$DEST_DIR".
mkdir $DEST_DIR/bin

# We want our "autorun" script file "90_hello.sh" to reside in "/etc/autorun",
# so we create the corresponding folders in "$DEST_DIR".
mkdir -p $DEST_DIR/etc/autorun

# Now we copy the "autorun" script file "90_hello.sh" in "$DEST_DIR/etc/autorun"
# and we make sure the script is executable.
cp $SRC_DIR/90_hello.sh $DEST_DIR/etc/autorun
chmod +x $DEST_DIR/etc/autorun/90_hello.sh

# Now we can compile "$OVERLAY_WORK_DIR/$BUNDLE_NAME/hello.c" and place it in
# "$DEST_DIR/bin" as executable binary "hello".
gcc -o $DEST_DIR/bin/hello $OVERLAY_WORK_DIR/$BUNDLE_NAME/hello.c

# Optionally, we can reduce the size of the generated overlay bundle artifacts.
# We use the special function "reduce_size" and we pass as argument the file or
# folder where our generated artifacts are located.
reduce_size $DEST_DIR/bin/hello

# No matter what you do with your bundles, no matter how you compile and/or
# prepare them, in the end all your bundle artifacts must be present in the
# "$OVERLAY_ROOTFS" folder. This special folder represents the final directory
# structure where all overlay bundles put their final artifacts. In our simple
# use case we have already prepared appropriate folder structure in "$DEST_DIR",
# so we will simply copy it in "$OVERLAY_ROOTFS".
#
# The overlay root filesystem folder is "minimal/src/work/overlay_rootfs".

# We use the special function "install_to_overlay" which works in three modes:
#
# Mode 1 - install everything from "$DEST_DIR" in "OVERLAY_ROOTFS":
#
#  install_to_overlay (no arguments provided)
#
# Mode 2 - install specific file/folder from "$DEST_DIR", e.g. "$DEST_DIR/bin"
# directly in "$OVERLAY_ROOTFS":
#
#  install_to_overlay bin
#
# Mode 3 - install specific file/folder from "$DEST_DIR", e.g. "$DEST_DIR/bin"
# as specific file/folder in "$OVERLAY_ROOTFS", e.g. "$OVERLAY_ROOTFS/bin"
#
#  install_to_overlay bin bin
#
# All of the above examples have the same final effect. In our simple use case
# we use the first mode (i.e. we provide no arguments).
install_to_overlay

# In the end we print message that our bundle has been installed and we return
# to the overlay source folder.
echo "Bundle '$BUNDLE_NAME' has been installed."

cd $SRC_DIR

# That's it. Add the overlay bundle in the main ".config" file, rebuild MLL
# (i.e. run "repackage.sh") and when the OS starts, type "hello".

