#!/sbin/busybox sh

## Testing: Check for ExFat SD Card
#
SDTYPE=`blkid /dev/block/mmcblk1p1  | awk '{ print $3 }' | sed -e 's|TYPE=||g' -e 's|\"||g'`

if [ ${SDTYPE} == "exfat" ];
then
  echo "ExFat-Debug: SD-Card is type ExFAT"
  ## Argument?
  if [ ${1} == "check" ];
  then
    echo "ExFat-Debug: Checking filesystem integrity"
    exfatfsck /dev/block/mmcblk1p1
  else
    echo "ExFat-Debug: Skipping filesystem check"
  fi
  ## 
  echo "ExFat-Debug: trying to mount via fuse"
  mount.exfat-fuse /dev/block/mmcblk1p1 /storage/extSdCard
else
  echo "ExFat-Debug: SD-Card is type: ${SDTYPE}"
fi
