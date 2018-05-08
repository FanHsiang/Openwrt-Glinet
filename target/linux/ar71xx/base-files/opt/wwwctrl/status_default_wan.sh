#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/etc/init.d:/etc/bin; export PATH
RC_CONF=/var/run/rc.conf

SCRIPT=$0
echo "">/dev/null

# include the enviro's
. $RC_CONF

usage () {
	echo "$0 [get]"
	exit
}

[ -z "$1" ] && usage

if [ "$1" = "get" ]; then                                                           
	defgw_index=`echo $system_default_route_interface | cut -d '_' -f2|cut -d 'n' -f2`
	sh /opt/wwwctrl/status_wan_pon.sh get |grep "kv_info_wan${defgw_index}_status=Connected"
	exit $?
fi
exit 1
