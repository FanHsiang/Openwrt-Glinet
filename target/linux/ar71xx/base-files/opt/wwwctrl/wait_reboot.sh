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

wait_reboot_timeout=60
reboot_ipaddr='192.168.1.1'
if [ ! -z "$1" ]; then
        set -- `ifconfig ifcpu0_01|grep 'inet addr'`
        IP=`echo $2|cut -d: -f2`
	wait_reboot_timeout=$1
        reboot_ipaddr=$IP
fi

echo "wait_reboot_timeout=$wait_reboot_timeout"	
echo "kv_lan_ipaddr=$reboot_ipaddr"
	
