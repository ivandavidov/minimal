#BASE_DIR/biBASE_DIR/sh

# Save current directory
BASE_DIR="`pwd`"

. $BASE_DIR/0_prepare.sh
. $BASE_DIR/1_get_kernel.sh
. $BASE_DIR/2_build_kernel.sh
. $BASE_DIR/3_get_busybox.sh
. $BASE_DIR/4_build_busybox.sh
. $BASE_DIR/5_generate_rootfs.sh
. $BASE_DIR/6_pack_rootfs.sh
. $BASE_DIR/7_generate_iso.sh
