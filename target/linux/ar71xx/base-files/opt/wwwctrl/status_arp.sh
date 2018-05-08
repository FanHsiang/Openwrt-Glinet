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

if [ "$1" = "get" ]; then
    a=`cat /proc/net/arp | wc -l`
    b=$(($a-1))
    echo "arp_num=$b"
    for i in `seq 1 $arp_num`;do
        echo "arp_ip$i=`cat /proc/net/arp |awk 'NR=='$i+1''|awk '{print $1}'`"
        echo "arp_flag$i=`cat /proc/net/arp |awk 'NR=='$i+1''|awk '{print $3}'`"
        echo "arp_hwaddr$i=`cat /proc/net/arp |awk 'NR=='$i+1''|awk '{print $4}'`"
        echo "arp_device$i=`cat /proc/net/arp |awk 'NR=='$i+1''|awk '{print $6}'`"
    done
fi
exit 0
