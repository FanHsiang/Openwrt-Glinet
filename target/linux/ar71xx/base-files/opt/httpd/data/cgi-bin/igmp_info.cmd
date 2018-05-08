#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/etc/init.d:/etc/bin; export PATH
#. /var/run/rc.conf
if [ -d "/opt/wwwctrl/" ]; then
	RUNTIME_ROOTDIR="/"
else
	# find thr faked root dir for x86 runtime
	dir=`dirname $0`;dir=`dirname $dir`;dir=`dirname $dir`
	RUNTIME_ROOTDIR=$dir
fi
. $RUNTIME_ROOTDIR/etc/wwwctrl/wwwctrl.cfg
WWWCTRL_BIN=$RUNTIME_ROOTDIR/opt/httpd/data/cgi-bin/wwwctrl.cgi
##########################################

echo "Content-type:text/html"
echo ""
#---  snoopy
#---  proxy
#---  proxy disabled
#---  off
	igmp_status=`/etc/init.d/igmp_mode.sh | grep "igmp.* is" | cut -d " " -f3,6`
	[ "$igmp_status" == "off" ] && igmp_status="Disabled"
	[ "$igmp_status" == "snoopy" ] && igmp_status="Snooping Mode"
	[ "$igmp_status" == "proxy" ] && igmp_status="Proxy Mode"
	[ "$igmp_status" == "proxy disabled" ] && igmp_status="Pure Proxy Mode"
	IGMP_MODE=${igmp_status}
cat <<EOF
{
	"status":	"$IGMP_MODE"
}
EOF
