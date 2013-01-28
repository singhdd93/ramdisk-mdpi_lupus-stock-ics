#!/sbin/sh


TIME=`/sbin/busybox date +"%d-%m-%Y %r"`
# [START] setting up
echo "$TIME[START] remounting system" > /data/local/tmp/lroot.txt
/sbin/busybox mount -o remount,rw /system >> /data/local/tmp/lroot.txt

# [CHECK] searching if autoroot was done before
echo "$TIME[CHECK] searching for autorooted file " >> /data/local/tmp/lroot.txt
if /sbin/busybox [ ! -f /system/autorooted ]; 
then
	echo "$TIME[FOUND] autorooted file " >> /data/local/tmp/lroot.txt

	# [CHECK] verify /system/xbin
	echo "$TIME[CHECK] verifying /system/xbin " >> /data/local/tmp/lroot.txt
	/sbin/busybox mkdir /system/xbin
	/sbin/busybox chmod 755 /system/xbin

	# [SU binary] remove existing occurances and push su
	echo "$TIME[SU binary] remove existing occurances and push su" >> /data/local/tmp/lroot.txt
	/sbin/busybox rm /system/bin/su
	/sbin/busybox rm /system/xbin/su
	/sbin/busybox cp /res/autoroot/su /system/xbin/su
	/sbin/busybox chown root.root /system/xbin/su
	/sbin/busybox chmod 06755 /system/xbin/su

	# [Superuser app] remove existing occurances and push app
	echo "$TIME[Superuser app] remove existing occurances and push app" >> /data/local/tmp/lroot.txt
	/sbin/busybox rm /system/app/Superuser.apk
	/sbin/busybox rm /data/app/Superuser.apk
	/sbin/busybox cp /res/autoroot/Superuser.apk /system/app/Superuser.apk
	/sbin/busybox chown root.root /system/app/Superuser.apk
	/sbin/busybox chmod 0644 /system/app/Superuser.apk

	# [busybox binary] remove existing occurances and push busybox
	echo "$TIME[busybox binary] $TIME remove existing occurances and push busybox" >> /data/local/tmp/lroot.txt
	if /sbin/busybox [ ! -f /system/xbin/busybox ]; 
	then	
		echo "$TIME[busybox binary] not found in /system/xbin/busybox " >> /data/local/tmp/lroot.txt
		if /sbin/busybox [ ! -f /system/bin/busybox ]; 
		then	
			echo "$TIME[busybox binary] not found in /system/bin/busybox " >> /data/local/tmp/lroot.txt
			/sbin/busybox cp /res/autoroot/busybox /system/xbin/busybox
			/sbin/busybox chown root.root /system/xbin/busybox
			/sbin/busybox chmod 4777 /system/xbin/busybox
			/system/xbin/busybox --install -s /system/xbin/
		fi
	fi

	# [DONE] placing flag
	echo "$TIME[DONE] placing flag" >> /data/local/tmp/lroot.txt
	/sbin/busybox touch /system/autorooted 

else

	echo "$TIME [FOUND] autorooted file" >> /data/local/tmp/lroot.txt
	echo "$TIME Device has been already autorooted" >> /data/local/tmp/lroot.txt
	echo "$TIME nothing to do... bye bye..." >> /data/local/tmp/lroot.txt



fi;

# [DONE] all done exiting
echo "$TIME[DONE] all done exiting" >> /data/local/tmp/lroot.txt


