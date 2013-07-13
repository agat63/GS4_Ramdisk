#!/sbin/busybox sh
#

# Remount FileSys RW
/sbin/busybox mount -t rootfs -o remount,rw rootfs

## Create the kernel data directory
if [ ! -d /data/.agat ];
then
  mkdir /data/.agat
  chmod 777 /data/.agat
fi

## Enable "post-init" ...
if [ -f /data/.agat/post-init.log ];
then
  # BackUp old post-init log
  mv /data/.agat/post-init.log /data/.agat/post-init.log.BAK
fi

# Start logging
date >/data/.agat/post-init.log
exec >>/data/.agat/post-init.log 2>&1

## install Kernel related Apps etc
/sbin/busybox sh /sbin/ext/install.sh

echo "Running Post-Init Script"

# Default Frequencies
# Temp Workarround ...
# Setting default values here is uncommon
#
# This JOB should be done by a App/Service
#
# We will take care about that later ...

## CPU 0 is always online!
echo "Setting Min/Max freq to core 0"
echo "1890000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "384000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

## CPU 1
if [ -f /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq ];
then
  echo "CPU 1 already online, setting Min/Max Freq"
  echo "1890000" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
  echo "384000" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
else
  echo "CPU1 is down, hotpluging to set Min/Max Freq"
  echo "1" >  /sys/devices/system/cpu/cpu1/online && echo "1890000" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
  echo "1" >  /sys/devices/system/cpu/cpu1/online && echo "384000" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
  echo "0" >  /sys/devices/system/cpu/cpu1/online
fi

## CPU 2
if [ -f /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq ];
then
  echo "CPU 2 already online, setting Min/Max Freq"
  echo "1890000" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
  echo "384000" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
else
  echo "CPU2 is down, hotpluging it to set Min/Max Freq"
  echo "1" >  /sys/devices/system/cpu/cpu2/online && echo "1890000" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
  echo "1" >  /sys/devices/system/cpu/cpu2/online && echo "384000" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
  echo "0" >  /sys/devices/system/cpu/cpu2/online
fi

## CPU 3
if [ -f /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq ];
then
  echo "CPU 3 already online, setting Min/Max Freq"
  echo "1890000" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
  echo "384000" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
else
  echo "CPU3 is down, hotpluging it to set Min/Max Freq"
  echo "1" >  /sys/devices/system/cpu/cpu3/online && echo "1890000" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
  echo "1" >  /sys/devices/system/cpu/cpu3/online && echo "384000" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
  echo "0" > /sys/devices/system/cpu/cpu3/online
fi

## Testing: Check for ExFat SD Card
#
SDTYPE=`blkid /dev/block/mmcblk1p1  | awk '{ print $3 }' | sed -e 's|TYPE=||g' -e 's|\"||g'`

if [ ${SDTYPE} == "exfat" ];
then
  echo "ExFat-Debug: SD-Card is type ExFAT"
  echo "ExFat-Debug: trying to mount via fuse"
  mount.exfat-fuse /dev/block/mmcblk1p1 /storage/extSdCard
else
  echo "ExFat-Debug: SD-Card is type: ${SDTYPE}"
fi

## frandom kernel module
if [ -f /system/lib/modules/frandom.ko ];
then
  echo "FRANDOM: found frandom Kernelmodule, loading..."
  insmod /system/lib/modules/frandom.ko
else
  echo "FRANDOM: frandom Kernelmodule not found, skipping..."
fi

# Remount FileSys RO
/sbin/busybox mount -t rootfs -o remount,ro rootfs


echo "Post-init finished ..."
