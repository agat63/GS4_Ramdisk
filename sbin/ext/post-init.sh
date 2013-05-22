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

echo "Running Post-Init Script"

## install Kernel related Apps etc
/sbin/busybox sh /sbin/ext/install.sh

# Remount FileSys RO
/sbin/busybox mount -t rootfs -o remount,ro rootfs


echo "Post-init finished ..."
