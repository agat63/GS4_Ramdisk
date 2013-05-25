#!/bin/bash
#

if grep -q exfat `blkid /dev/block/mmcblk1p1`;
then
echo "Found Exfat SD-Card, trying to mount..."
mount.exfat-fuse /dev/block/mmcblk1p1 /storage/extSdCard
fi
