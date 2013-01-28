#!/sbin/sh

TIME=`/sbin/busybox date +"%d-%m-%Y %r"`
# [START] setting up
echo "$TIME[START] remounting system" > /data/local/tmp/lsysinitsupportlog.txt
/sbin/busybox mount -o remount,rw /system >> /data/local/tmp/lsysinitsupportlog.txt

# make init.d directory
echo "$TIME make init.d directory" >> /data/local/tmp/lsysinitsupportlog.txt
/sbin/busybox mkdir -p /system/etc/init.d >> /data/local/tmp/lsysinitsupportlog.txt

# correcting permissions of files in init.d directory
echo "$TIME correcting permissions of files in init.d directory" >> /data/local/tmp/lsysinitsupportlog.txt
/sbin/busybox chmod 777 /system/etc/init.d/*

# make init.d directory
echo "$TIME make init.d directory" >> /data/local/tmp/lsysinitsupportlog.txt
/system/bin/logwrapper /sbin/busybox run-parts /system/etc/init.d

# [DONE] all done exiting
echo "$TIME[DONE] all done exiting" >> /data/local/tmp/lsysinitsupportlog.txt
