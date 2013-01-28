#!/sbin/sh

TIME=`/sbin/busybox date +"%d-%m-%Y %r"`

# [START] setting up
echo "$TIME[START] remounting system" > /data/local/tmp/lmodules.txt
/sbin/busybox mount -o remount,rw /system >> /data/local/tmp/lmodules.txt

# [CHECK] searching if modules was loaded before
echo "$TIME[CHECK] searching for modules dir " >> /data/local/tmp/lmodules.txt
if /sbin/busybox [ ! -e /data/local/tmp/dds ];
then
	echo "$TIME[NOT FOUND] Modules Not found " >> /data/local/tmp/lmodules.txt
	echo " " >> /data/local/tmp/lmodules.txt	
	echo "$TIME[CHECK] pushing /system/lib/modules " >> /data/local/tmp/lmodules.txt
	/sbin/busybox mv /system/lib/modules /system/lib/modules.old
	/sbin/busybox mkdir /system/lib/modules/
	/sbin/busybox chmod 755 /system/lib/modules/
	/sbin/busybox cp -fr /modules/* /system/lib/modules/.
	/sbin/busybox touch /data/local/tmp/dds

	# [Permission] set permission
	echo "$TIME[Permission] set permission " >> /data/local/tmp/lmodules.txt
	/sbin/busybox chmod 0644 /system/lib/modules/drivers/net/wireless/wl12xx/*
	/sbin/busybox chmod 0644 /system/lib/modules/net/mac80211/*
	/sbin/busybox chmod 0644 /system/lib/modules/net/wireless/*
	/sbin/busybox chmod 0644 /system/lib/modules/compat/*


else
	echo "$TIME [FOUND] modules dir " >> /data/local/tmp/lmodules.txt
	echo "$TIME Device has modules loaded " >> /data/local/tmp/lmodules.txt
	echo "$TIME nothing to do... bye bye..." >> /data/local/tmp/lmodules.txt

fi;

# [DONE] all done exiting
echo "$TIME[DONE] all done exiting" >> /data/local/tmp/lmodules.txt
