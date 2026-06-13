#!/bin/sh

UNFORMATTED=$(lsblk --fs --json | jq -r '.blockdevices[] | select(.children == null and .fstype == null) | .name'| grep -i "vd")
if [ -n "$UNFORMATTED" ]; then 
  sfdisk /dev/$UNFORMATTED <<EOF
label: gpt
,$(( $(blockdev --getsize64 /dev/$UNFORMATTED) / 1024 ))KiB,,
EOF
  mkfs.ext4 /dev/${UNFORMATTED}1
fi
mkdir -p /mnt/virtdrive
mount /dev/${UNFORMATTED}1 /mnt/virtdrive
echo "$(date) hello" >> /mnt/virtdrive/log
