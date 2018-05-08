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

if [ -f $metafile ]; then
	$WWWCTRL_BIN --kvprint_shell_escaped $metafile > /tmp/sh.$$; 
	. /tmp/sh.$$; rm /tmp/sh.$$
else
	exit 1
fi

if [ "$1" = "check" ]; then
	echo $http_direct_output > /tmp/www/.debug
	echo $CGI_PAGE_ID >> /tmp/www/.debug
	echo $HTTP_OUTPUT >> /tmp/www/.debug
	$userpwd_bin --file $userpwd_cfg --check "$kv_user_name" "$kv_user_passwd"
	echo $userpwd_bin >> /tmp/www/.debug
	echo $userpwd_cfg >> /tmp/www/.debug
	echo $kv_user_name >> /tmp/www/.debug
	echo $kv_user_passwd >> /tmp/www/.debug 
	if [ $? = 0 ]; then
		#update new password
		echo "ok" >> /tmp/www/.debug
		# redirect browser to wait_boot page
		HTTP_OUTPUT=$http_direct_output.$CGI_PAGE_ID
		rm $HTTP_OUTPUT
		echo "HTTP/1.1 301 Moved Permanently" >> $HTTP_OUTPUT
		echo "Location: /cgi-bin/wwwctrl.cgi?action=DEFAULT" >> $HTTP_OUTPUT
	else
		#error password
		echo "error" >> /tmp/www/.debug
		[ -f /tmp/error.log ] && rm /tmp/error.log
		$WWWCTRL_BIN --urlunescape "password_check=false" >  /tmp/error.log;. /tmp/error.log
	fi
fi
exit 0
