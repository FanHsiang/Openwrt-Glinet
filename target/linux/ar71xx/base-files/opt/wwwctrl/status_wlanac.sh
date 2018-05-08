#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
if [ -d "/opt/wwwctrl/" ]; then
	RUNTIME_ROOTDIR="/"
else
	# find thr faked root dir for x86 runtime
	dir=`dirname $0`;dir=`dirname $dir`;dir=`dirname $dir`
	RUNTIME_ROOTDIR=$dir
fi

. $RUNTIME_ROOTDIR/etc/wwwctrl/wwwctrl.cfg

RC_CONF_STAGING=/var/run/rc.conf.staging
# include the enviro's
. $RC_CONF_STAGING

WIFI=$dev_wlan0_interface
WIFIAC=$dev_wlanac0_interface

if [ "$1" = "set" ]; then
	:
elif [ "$1" = "get" ]; then
	#echo "kv_channelac_num1=`grep -w "dot11channel:" /proc/wlan0/mib_rf | awk '{print $2}'`"
	waitloop=20;
	for i in `seq 1 $waitloop`;do
		channel=`grep -w "dot11channel:" /proc/$WIFIAC/mib_rf | awk '{print $2}'`
		#echo "11AC_CH = $channel" > /dev/console
		[ $channel -ne 36 -a $channel -ne 0 ] && break;
		usleep 250000;
	done;
	echo "kv_channelac_num1=$channel"
fi
exit 0
