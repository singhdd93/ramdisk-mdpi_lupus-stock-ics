#!/sbin/busybox sh
set +x
_PATH="$PATH"
export PATH=/sbin

busybox cd /
busybox date >>boot.txt
exec >>boot.txt 2>&1
busybox rm /init

# include device specific vars
source /sbin/bootrec-device

# create directories
busybox mkdir -m 755 -p /cache
busybox mkdir -m 755 -p /dev/block
busybox mkdir -m 755 -p /dev/input
busybox mkdir -m 555 -p /proc
busybox mkdir -m 755 -p /sys

# create device nodes
busybox mknod -m 600 /dev/block/mmcblk0 b 179 0
busybox mknod -m 600 ${BOOTREC_CACHE_NODE}
busybox mknod -m 600 ${BOOTREC_EVENT_NODE}
busybox mknod -m 666 /dev/null c 1 3

# mount filesystems
busybox mount -t proc proc /proc
busybox mount -t sysfs sysfs /sys
busybox mount -t yaffs2 ${BOOTREC_CACHE} /cache

# fixing CPU clocks to avoid issues in recovery
echo 1017600 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo 249600 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

# trigger red LED & button-backlight
busybox echo 255 > ${BOOTREC_LED_RED}
busybox echo 0 > ${BOOTREC_LED_GREEN}
busybox echo 0 > ${BOOTREC_LED_BLUE}
busybox echo 255 > ${BOOTREC_LED_BUTTONS}
echo 200 > /sys/class/timed_output/vibrator/enable

# keycheck
busybox cat ${BOOTREC_EVENT} > /dev/keycheck&
busybox sleep 3

# android ramdisk
load_image=/sbin/ramdisk.cpio.bz2

# boot decision
if [ -s /dev/keycheck -o -e /cache/recovery/boot ];
	then
		busybox echo 'CHOOSING TWRP' >>boot.txt
		busybox rm -fr /cache/recovery/boot
		# trigger blue led
		busybox echo 0 > ${BOOTREC_LED_RED}
		busybox echo 0 > ${BOOTREC_LED_GREEN}
		busybox echo 255 > ${BOOTREC_LED_BLUE}
		busybox echo 0 > ${BOOTREC_LED_BUTTONS}
		# trigger vibrator
		echo 150 > /sys/class/timed_output/vibrator/enable
		# recovery ramdisk
		load_image=/sbin/ramdisk-twrp.cpio.bz2
		busybox echo "TWRP LOADED" >> boot.txt

	else
		busybox echo 'ANDROID BOOT' >>boot.txt
		# poweroff LED & button-backlight
		busybox echo 0 > ${BOOTREC_LED_RED}
		busybox echo 0 > ${BOOTREC_LED_GREEN}
		busybox echo 0 > ${BOOTREC_LED_BLUE}
		busybox echo 0 > ${BOOTREC_LED_BUTTONS}
fi;

# kill the keycheck process
busybox pkill -f "busybox cat ${BOOTREC_EVENT}"


# unpack the ramdisk image
busybox bzcat ${load_image} | busybox cpio -i

# run lupus script
source /sbin/lupus.sh

busybox umount /cache
busybox umount /proc
busybox umount /sys

busybox rm -fr /dev/*
busybox date >>boot.txt
export PATH="${_PATH}"
exec /init
