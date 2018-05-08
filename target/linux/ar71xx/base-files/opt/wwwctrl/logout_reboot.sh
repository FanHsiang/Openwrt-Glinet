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

on_sighup() {
        echo "skip signal"
}

trap on_sighup SIGHUP

if [ "$1" = "reboot" ]; then
	# redirect browser to wait_boot page
	HTTP_OUTPUT=$http_direct_output.$CGI_PAGE_ID
	rm $HTTP_OUTPUT
	echo "HTTP/1.1 301 Moved Permanently" >> $HTTP_OUTPUT
	echo "Location: /cgi-bin/wwwctrl.cgi?action=wait_reboot" >> $HTTP_OUTPUT

	if [ ! -d "/opt/wwwctrl/" ]; then
		# simulation on X86 runtime
		exit 0
	else
		# action on target evb
		(sleep 2; reboot)&
	fi

elif [ "$1" = "factory" ]; then
	# redirect browser to wait_boot page
	HTTP_OUTPUT=$http_direct_output.$CGI_PAGE_ID
	rm $HTTP_OUTPUT
	echo "HTTP/1.1 301 Moved Permanently" >> $HTTP_OUTPUT
	echo "Location: /cgi-bin/wwwctrl.cgi?action=wait_reboot" >> $HTTP_OUTPUT
	
	if [ ! -d "/opt/wwwctrl/" ]; then
		# simulation on X86 runtime
		exit 0
	else
		# action on target evb
		if [ -f "$metafile.default" ]; then
			(sleep 2; cp $metafile.default $metafile; cp $userpwd_cfg.default $userpwd_cfg; sync; sync; reboot) &
		fi
	fi
fi
