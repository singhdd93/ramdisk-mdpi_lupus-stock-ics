#!/sbin/busybox sh



TIME=`/sbin/busybox date +"%d-%m-%Y %r"`

export MOUNT="/system"

# check if /system exist as mountpoint.
if /sbin/busybox grep -qs $MOUNT /proc/mounts
then
	# [START] setting up
	/sbin/busybox mount -o remount,rw /system
	/sbin/busybox echo " ****************************************************** " >> /data/local/tmp/lupuslog.txt
	/sbin/busybox echo " $TIME - [START] remounting system with write access" >> /data/local/tmp/lupuslog.txt

	# [CHECK] searching if wlanfix was done before.
	/sbin/busybox echo " $TIME - [CHECK] searching for wifi-fix file" >> /data/local/tmp/lupuslog.txt
	if /sbin/busybox [ ! -e /data/local/tmp/lwifi_fixed ];
	then
		/sbin/busybox echo " $TIME - [NOT FOUND] never fixed before" >> /data/local/tmp/lupuslog.txt
	
		# [modules] remove existing directory and modules.
		/sbin/busybox echo " $TIME - [modules] move existing directory and modules" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox mv /system/lib/modules /system/lib/modules.old
		/sbin/busybox echo " $TIME - [modules] push new modules" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox mkdir /system/lib/modules/
		/sbin/busybox chmod 755 /system/lib/modules/
		/sbin/busybox cp -fr /res/modules/* /system/lib/modules/.
		/sbin/busybox echo " $TIME - [modules] fixing permissions" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox chmod 0644 /system/lib/modules/drivers/net/wireless/wl12xx/*
		/sbin/busybox chmod 0644 /system/lib/modules/net/mac80211/*
		/sbin/busybox chmod 0644 /system/lib/modules/net/wireless/*
		/sbin/busybox chmod 0644 /system/lib/modules/compat/*

		# [DONE] creating marker file.
		/sbin/busybox echo " $TIME - [DONE] creating wifi-fix file" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox touch /data/local/tmp/lwifi_fixed

	else

		/sbin/busybox echo " $TIME - [FOUND] kernel wifi-fix file" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox echo " $TIME - wifi has already been fix" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox echo " $TIME - nothing to do, continue" >> /data/local/tmp/lupuslog.txt

	fi;

	# [CHECK] searching if chargerfix was done before.
	/sbin/busybox echo " $TIME - [CHECK] searching for chargerfix file" >> /data/local/tmp/lupuslog.txt
	if /sbin/busybox [ ! -e /data/local/tmp/chargerfixed ]; 
	then
		/sbin/busybox echo " $TIME - [NOT FOUND] never chargerfixed before" >> /data/local/tmp/lupuslog.txt

		# [charger binary] check if existing charger binary exist.
		/sbin/busybox echo " $TIME - [charger binary] deleting old chager binary" >> /data/local/tmp/lupuslog.txt
		if /sbin/busybox [ -e /system/bin/chargemon ];
		then
			/sbin/busybox rm -f /system/bin/chargemon
		fi;

		# [charger binary] push new charger binary.
		/sbin/busybox echo " $TIME - [charger binary] push new charger binary" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox cp -f /sbin/chargemon /system/bin/chargemon

		# [charger binary] chown new charger binary.
		/sbin/busybox echo " $TIME - [charger binary] chown new charger binary" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox chown root.root /system/bin/chargemon

		# [charger binary] chmod new charger binary.
		/sbin/busybox echo " $TIME - [charger binary] chmod new charger binary" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox chmod 0777 /system/bin/chargemon

		# [DONE] creating marker file.
		/sbin/busybox echo " $TIME - [DONE] creating charger-fix file" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox touch /data/local/tmp/chargerfixed
	
	else

		/sbin/busybox echo " $TIME - [FOUND] chargerfix marker file" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox echo " $TIME - device has already been chargerfixed" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox echo " $TIME - nothing to do, continue" >> /data/local/tmp/lupuslog.txt

	fi;

	

	# [CHECK] searching if sysinitfix was done before.
	/sbin/busybox echo " $TIME - [CHECK] searching for sysinit-fix file" >> /data/local/tmp/lupuslog.txt
	if /sbin/busybox [ ! -e /data/local/tmp/sysinitfixed ];
	then
		/sbin/busybox echo " $TIME - [NOT FOUND] never sysinitfixed before" >> /data/local/tmp/lupuslog.txt

		# delete existing sysinit.
		/sbin/busybox echo " $TIME - [sysinit] delete existing sysinit" >> /data/local/tmp/lupuslog.txt
		if /sbin/busybox [ -e /system/bin/sysinit ];
		then
			/sbin/busybox rm -f /system/bin/sysinit
		fi;

		# copy new sysinit.
		/sbin/busybox echo " $TIME - [sysinit] copy new sysinit" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox cp -f /res/extras/sysinit /system/bin/sysinit

		# chown new sysinit.
		/sbin/busybox echo " $TIME - [sysinit] chown new sysinit" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox chown root.shell /system/bin/sysinit

		# chmod new sysinit.
		/sbin/busybox echo " $TIME - [sysinit] chmod new sysinit" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox chmod 0755 /system/bin/sysinit

		# create new init.d directory.
		/sbin/busybox echo " $TIME - [sysinit] create new init.d directory" >> /data/local/tmp/lupuslog.txt
		if /sbin/busybox [ ! -d /system/etc/init.d ];
		then
			/sbin/busybox mkdir /system/etc/init.d
		fi;
	
		# [DONE] creating marker file.
		/sbin/busybox echo "[36] $TIME - [DONE] creating sysinit-fix file" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox touch /data/local/tmp/sysinitfixed

	else

		/sbin/busybox echo " $TIME - [FOUND] sysinit sysinit-fix file" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox echo " $TIME - device has already been sysinitfixed" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox echo " $TIME - nothing to do, continue" >> /data/local/tmp/lupuslog.txt

	fi;

	# [SYSINIT] create sysinit directory if it doesn't exist yet and fixing permission.
	/sbin/busybox echo " $TIME - [sysinit] create sysinit directory if it doesn't exist yet and fixing permission" >> /data/local/tmp/lupuslog.txt
	if /sbin/busybox [ -d /system/etc/init.d ];
	then
		/sbin/busybox chown -R root.root /system/etc/init.d
		/sbin/busybox chmod -R 0755 /system/etc/init.d
	fi;

	# [CHECK] searching if phone already rooted.
	/sbin/busybox echo " $TIME - [CHECK] searching if phone already rooted" >> /data/local/tmp/lupuslog.txt
	if /sbin/busybox [ ! -e /system/xbin/su ] && /sbin/busybox [ ! -e /system/app/Superuser.apk ] && /sbin/busybox [ ! -e /system/framework/framework-miui-res.apk ];
	then
		/sbin/busybox echo " $TIME - [NOT FOUND] device is not rooted" >> /data/local/tmp/lupuslog.txt
	
		/sbin/busybox echo " $TIME - [SuperUser] copying SuperUser.apk to system" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox cp -f /res/autoroot/Superuser.apk /system/app/Superuser.apk

		/sbin/busybox echo " $TIME - [SuperUser] chmod SuperUser.apk" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox chown root.root /system/app/Superuser.apk

		/sbin/busybox echo " $TIME - [SuperUser] chmod SuperUser.apk" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox chmod 0644 /system/app/Superuser.apk

		/sbin/busybox echo " $TIME - [SuperUser] copying su binary to system" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox cp -f /res/autoroot/su /system/xbin/su

		/sbin/busybox echo " $TIME - [SuperUser] chown su binary" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox chown root.root /system/xbin/su

		/sbin/busybox echo " $TIME - [SuperUser] chmod su binary" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox chmod 6755 /system/xbin/su

	else

		/sbin/busybox echo " $TIME - [FOUND]device is already rooted" >> /data/local/tmp/lupuslog.txt
		/sbin/busybox echo " $TIME - nothing to do, continue" >> /data/local/tmp/lupuslog.txt

	fi;
	
	

	# [DONE] finishing up.
	/sbin/busybox echo " $TIME - [DONE] remounting system with read only access" >> /data/local/tmp/lupuslog.txt
	/sbin/busybox mount -o remount,ro /system

else
# /system not exist as mountpoint, nothing to do, continue.
return 0
fi;
