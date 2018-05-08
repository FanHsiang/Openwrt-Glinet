#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/etc/init.d:/etc/bin; export PATH
. /var/run/rc.conf

if [ -d "/opt/wwwctrl/" ]; then
	RUNTIME_ROOTDIR="/"
else
	# find thr faked root dir for x86 runtime
	dir=`dirname $0`;dir=`dirname $dir`;dir=`dirname $dir`
	RUNTIME_ROOTDIR=$dir
fi
. $RUNTIME_ROOTDIR/etc/wwwctrl/wwwctrl.cfg
WWWCTRL_BIN=$RUNTIME_ROOTDIR/opt/httpd/data/cgi-bin/wwwctrl.cgi
if [ -n "$1" ]; then
	if [ -f $metafile_diff.$CGI_PAGE_ID ]; then
		if [ -f $metafile_page.$CGI_PAGE_ID ]; then
			$WWWCTRL_BIN --kvprint_shell_escaped $metafile_page.$CGI_PAGE_ID > /tmp/sh.$$;. /tmp/sh.$$; rm /tmp/sh.$$
		fi
		$WWWCTRL_BIN --kvprint_shell_escaped $metafile_diff.$CGI_PAGE_ID > /tmp/sh.$$;. /tmp/sh.$$; rm /tmp/sh.$$
	fi
fi
#echo $1 > /dev/console
if [ "$1" = "setwanmtu" ]; then
	echo "Wan mtu="$kv_setwanmtu > /dev/console
	echo $kv_setwanmtu > /proc/sys/net/ipv6/conf/eth0.5/mtu
elif [ "$1" = "setlanmtu" ]; then
	echo "lan mtu="$kv_setlanmtu > /dev/console
	echo $kv_setlanmtu > /proc/sys/net/ipv6/conf/eth0.2/mtu
elif [ "$1" = "ipv6wanaction" ]; then
	echo "action="$kv_ipv6wanaction > /dev/console
	[ "$kv_ipv6wanaction" = "wanConfirm" ] && ifconfig eth0.5 down && sleep 1 && ifconfig eth0.5 up && echo "eth0.5 down up" > /dev/console
	[ "$kv_ipv6wanaction" = "wanRelease" ] && killall -USR2 odhcp6c && echo "killall odhcp6c" > /dev/console
fi
