#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/etc/init.d:/etc/bin; export PATH
if [ -d "/opt/wwwctrl/" ]; then
	RUNTIME_ROOTDIR="/"
else
	# find thr faked root dir for x86 runtime
	dir=`dirname $0`;dir=`dirname $dir`;dir=`dirname $dir`
	RUNTIME_ROOTDIR=$dir
fi

. $RUNTIME_ROOTDIR/etc/wwwctrl/wwwctrl.cfg

WWWCTRL_BIN=$RUNTIME_ROOTDIR/opt/httpd/data/cgi-bin/wwwctrl.cgi
HTTP_OUTPUT=$http_direct_output.$CGI_PAGE_ID

RC_CONF_STAGING=/var/run/rc.conf.staging
# include the enviro's
. $RC_CONF_STAGING

IGMP_PROCESS=/tmp/igmp.proc
IGMP_FLAG=/tmp/igmp.flag

if [ "$1" = "get" ]; then
	if [ -f $IGMP_PROCESS ]; then
		while [ ! -f $IGMP_FLAG ]
		do
			sleep 2
		done
		rm $IGMP_PROCESS
		rm $IGMP_FLAG
	fi
#---  snoopy
#---  proxy
#---  proxy disabled
#---  off
	igmp_status=`/etc/init.d/igmp_mode.sh | grep "igmp.* is" | cut -d " " -f3,6`
	[ "$igmp_status" == "proxy" ] && igmp_status="proxy with snoopy"
	[ "$igmp_status" == "proxy disabled" ] && igmp_status="proxy"
	echo "igmp_status=${igmp_status}"
elif [ "$1" = "set" ]; then
	omcicli -c "igmp config upstream_igmp_tag_ctl $igmp_us_tag_ctl"
	omcicli -c "igmp config upstream_igmp_tci $igmp_us_tci"
	omcicli -c "igmp config downstream_igmp_tag_ctl $igmp_ds_tag_ctl"
	omcicli -c "igmp config downstream_igmp_tci $igmp_ds_tci"

	touch $IGMP_PROCESS
	if [ -f $metafile_diff.$CGI_PAGE_ID ]; then
		#$WWWCTRL_BIN --kvprint_shell_escaped $metafile_diff.$CGI_PAGE_ID > /tmp/sh.$$; . /tmp/sh.$$; rm /tmp/sh.$$
		$WWWCTRL_BIN --kvprint_shell_escaped $metafile_diff.$CGI_PAGE_ID > /tmp/sh.$$; . /tmp/sh.$$

		[ "$kv_igmp_mode" = "disable" ] && igmp_mode.sh off
		if [ "$kv_igmp_mode" = "snoopy" ]; then
			igmp_mode.sh off
			sleep 1
			igmp_mode.sh snoopy
			#echo "---" $kv_igmp_mode > /dev/console
		fi
		if [ "$kv_igmp_mode" = "proxy_snoopy" ]; then
			igmp_mode.sh off
			sleep 1
			igmp_mode.sh proxy $kv_ProxyWan $kv_ProxyLan
			#echo "---" $kv_igmp_mode $kv_ProxyWan $kv_ProxyLan > /dev/console
		fi
		if [ "$kv_igmp_mode" = "pure_proxy" ]; then
			igmp_mode.sh off; sleep 1; igmp_mode.sh proxy_no_snoopy $kv_ProxyWan $kv_ProxyLan
			#echo "---" $kv_igmp_mode $kv_ProxyWan $kv_ProxyLan > /dev/console
		fi

	fi

	touch $IGMP_FLAG

fi
exit 0
