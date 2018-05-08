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

DUMPLEASES=/usr/bin/dumpleases

if [ "$1" = "get" ]; then
	echo "lan_ip_subnet=`echo $lan_ip|cut -d '.' -f 1-3`"
	if [ -f $DUMPLEASES ]; then
		$DUMPLEASES |awk '{if(NR!=1) {printf "dhcp_client_%d=host=%s;mac=%s;ip=%s;expir=%s\n", NR-1,$3,$1,$2,$4}}'
	fi
fi
exit 0
