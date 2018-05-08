#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/etc/init.d:/etc/bin; export PATH
if [ -d "/opt/wwwctrl/" ]; then
	RUNTIME_ROOTDIR="/"
else
	# find thr faked root dir for x86 runtime
	dir=`dirname $0`;dir=`dirname $dir`;dir=`dirname $dir`
	RUNTIME_ROOTDIR=$dir
fi
RC_CONF_STAGING=/var/run/rc.conf.staging
. $RC_CONF_STAGING

#	local SOURCE="LAN"
	local SOURCE="WAN"
[ ! -z "$HTTP_COOKIE" ] && eval "$HTTP_COOKIE"

#[ "$sessuser" = "chtwan" ] && SOURCE="WAN"
if [ "$lan0_ip" = "$HTTP_HOST" \
	-o "$lan0_alias0_ip" = "$HTTP_HOST" \
	-o "$lan0_alias1_ip" = "$HTTP_HOST" \
	-o "$lan0_alias2_ip" = "$HTTP_HOST" \
	-o "$lan0_alias3_ip" = "$HTTP_HOST" \
	-o "$lan1_ip" = "$HTTP_HOST" \
	-o "$lan1_alias0_ip" = "$HTTP_HOST" \
	-o "$lan1_alias1_ip" = "$HTTP_HOST" \
	-o "$lan1_alias2_ip" = "$HTTP_HOST" \
	-o "$lan1_alias3_ip" = "$HTTP_HOST" \
	-o "$lan2_ip" = "$HTTP_HOST" \
	-o "$lan2_alias0_ip" = "$HTTP_HOST" \
	-o "$lan2_alias1_ip" = "$HTTP_HOST" \
	-o "$lan2_alias2_ip" = "$HTTP_HOST" \
	-o "$lan2_alias3_ip" = "$HTTP_HOST" \
	-o "$lan3_ip" = "$HTTP_HOST" \
	-o "$lan3_alias0_ip" = "$HTTP_HOST" \
	-o "$lan3_alias1_ip" = "$HTTP_HOST" \
	-o "$lan3_alias2_ip" = "$HTTP_HOST" \
	-o "$lan3_alias3_ip" = "$HTTP_HOST" \
	-o "$lan4_ip" = "$HTTP_HOST" \
	-o "$lan4_alias0_ip" = "$HTTP_HOST" \
	-o "$lan4_alias1_ip" = "$HTTP_HOST" \
	-o "$lan4_alias2_ip" = "$HTTP_HOST" \
	-o "$lan4_alias3_ip" = "$HTTP_HOST" \
	-o "$lan5_ip" = "$HTTP_HOST" \
	-o "$lan5_alias0_ip" = "$HTTP_HOST" \
	-o "$lan5_alias1_ip" = "$HTTP_HOST" \
	-o "$lan5_alias2_ip" = "$HTTP_HOST" \
	-o "$lan5_alias3_ip" = "$HTTP_HOST" \
	-o "$lan6_ip" = "$HTTP_HOST" \
	-o "$lan6_alias0_ip" = "$HTTP_HOST" \
	-o "$lan6_alias1_ip" = "$HTTP_HOST" \
	-o "$lan6_alias2_ip" = "$HTTP_HOST" \
	-o "$lan6_alias3_ip" = "$HTTP_HOST" \
	-o "$lan7_ip" = "$HTTP_HOST" \
	-o "$lan7_alias0_ip" = "$HTTP_HOST" \
	-o "$lan7_alias1_ip" = "$HTTP_HOST" \
	-o "$lan7_alias2_ip" = "$HTTP_HOST" \
	-o "$lan7_alias3_ip" = "$HTTP_HOST" ]; then
		SOURCE="LAN"
	fi

log_msg() {
	local msg="$1"
	if [ -f "/nvram/security_log" ]; then
		echo `date +"%Y %b %d %T"`" User \"$sessuser\" $msg from $REMOTE_ADDR via HTTP" >> /nvram/security_log
		lines=`wc -l /nvram/security_log | cut -d ' ' -f 1`
	        [ $lines -ge 350 ] && tail -n 300 /nvram/security_log > /nvram/security_log.$$ && mv /nvram/security_log.$$ /nvram/security_log && sync
	fi
}

#echo "0" $HTTP_HOST > /dev/console
##echo "1" $REMOTE_ADDR > /dev/console
#echo "2" $QUERY_STRING > /dev/console
#echo "3" $HTTP_REFERER > /dev/console

log_msg "logout"

