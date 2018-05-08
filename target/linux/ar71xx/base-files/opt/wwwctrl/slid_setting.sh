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

if [ "$1" = "get" ]; then
	if [ ! -d "/opt/wwwctrl/" ]; then
		# simulation on X86 runtime
		echo "kv_onu_password=ONU_PASSWORD"
	else	
		pon_status=` diag gpon get onu-state | grep 'ONU state' | cut -d'(' -f2 | cut -d')' -f1`
		echo "pon_status=$pon_status"
		onu_password=`cat /nvram/gpon.dat |grep onu_password | cut -d '=' -f 2`
		echo "kv_onu_password=$onu_password"
	fi
	## for TR069 in Quick Setup
	if [ -f /tmp/setting.result ]; then
		v_cwmp_boottrap_status=`cat /tmp/setting.result`
		echo "cwmp_boottrap_status=$v_cwmp_boottrap_status"
	fi
elif [ "$1" = "set" ]; then
	if [ -f $metafile_diff.$CGI_PAGE_ID ]; then
		$WWWCTRL_BIN --kvprint_shell_escaped $metafile_diff.$CGI_PAGE_ID > /tmp/sh.$$; . /tmp/sh.$$; rm /tmp/sh.$$
		if [ ! -z "$onu_password" ]; then 
			nvram.sh kvset gpon.dat onu_password "$onu_password"
			nvram.sh commit gpon.dat
			
			rm -rf $HTTP_OUTPUT
			echo "HTTP/1.1 301 Moved Permanently" >> $HTTP_OUTPUT
			echo "Location: /cgi-bin/wwwctrl.cgi?action=wait_restart" >> $HTTP_OUTPUT
			
			(sleep 5; /sbin/reboot) &
		fi
	fi
fi
exit 0
