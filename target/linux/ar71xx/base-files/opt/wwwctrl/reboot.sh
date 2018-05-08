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

#if [ -f $metafile ]; then
#	$WWWCTRL_BIN --kvprint_shell_escaped $metafile > /tmp/sh.$$; 
#	. /tmp/sh.$$; rm /tmp/sh.$$
#else
#	exit 1
#fi

if [ "$1" = "reboot" ]; then
	if [ ! -d "/opt/wwwctrl/" ]; then
		# simulation on X86 runtime
		echo ""
	else
		echo "HTTP/1.1 301 Moved Permanently" > $HTTP_OUTPUT
		echo "Location: /cgi-bin/wwwctrl.cgi?action=wait_restart" >> $HTTP_OUTPUT
		
		(sync && sleep 5 && reboot) &
	fi
	
fi
exit 0
