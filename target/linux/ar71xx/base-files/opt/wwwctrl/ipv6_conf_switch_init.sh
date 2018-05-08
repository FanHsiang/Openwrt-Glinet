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

if [ "$1" = "set" ]; then
        :
elif [ "$1" = "get" ]; then
	wan_mtu=`cat /proc/sys/net/ipv6/conf/eth0.5/mtu`
	lan_mtu=`cat /proc/sys/net/ipv6/conf/eth0.2/mtu`
	echo "kv_wan_mtu_size=$wan_mtu"
	echo "kv_lan_mtu_size=$lan_mtu"
fi

exit 0