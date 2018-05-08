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
WAIT_REBOOT_HTM=$RUNTIME_ROOTDIR/opt/httpd/data/pages/wait_reboot.htm
HTTP_OUTPUT=$http_direct_output.$CGI_PAGE_ID

if [ "$1" = "get" ]; then
	if [ ! -d "/opt/wwwctrl/" ]; then
		# get simulation on X86 runtime
set -- `ifconfig eth0|grep 'inet addr'`
IP=`echo $2|cut -d: -f2`
MASK=`echo $4|cut -d: -f2`
		echo "onu_sn=FHTT002861cc
onu_password=FVTGPONONU
LOID_id=abcde
LOID_password=123456789012
onu_state=1
sf_state=0
sd_state=0
kv_lan_ipaddr=$IP
kv_lan_submask=$MASK"
	else
		# get action on target evb

set `ifconfig ifcpu0_01|grep 'inet addr'`
IP=`echo $2|cut -d: -f2`
MASK=`echo $4|cut -d: -f2`
#echo "ip=$IP, mask=$MASK"
		/usr/bin/onutool --get_allinfo 2>/dev/null
               gpon_monitor -c "omci me 65296 0 9" > /tmp/slid_cap
               slid_cap=`cat /tmp/slid_cap`
               set -- `echo "$slid_cap"|grep SLID`
	       slid_enable=`echo "$3" | sed 's/0x//' | sed 's/(..//'`
	       onu_state=`/usr/bin/onutool --get_allinfo  | grep 'onu_state=' |cut -d= -f2`
               echo "kv_lan_ipaddr=$IP" 
               echo "kv_lan_submask=$MASK"
	       echo "slid_enable=$slid_enable"
	fi

elif [ "$1" = "set" ]; then
	if [ -f $metafile_diff.$CGI_PAGE_ID ]; then
		$WWWCTRL_BIN --kvprint_shell_escaped $metafile_diff.$CGI_PAGE_ID > /tmp/sh.$$; . /tmp/sh.$$; rm /tmp/sh.$$
		[ ! -z "$LOID_id" ] && /usr/bin/onutool --set_LOID_id "$LOID_id"
		[ ! -z "$LOID_password" ] && /usr/bin/onutool --set_LOID_password "$LOID_password"
		[ ! -z "$onu_password" ] && /usr/bin/onutool --set_onu_password $onu_password
                [ ! -z "$kv_lan_ipaddr" ] && ifconfig ifcpu0_01 "$kv_lan_ipaddr" && fw_setenv ipaddr "$kv_lan_ipaddr"
                [ ! -z "$kv_lan_submask" ] && ifconfig ifcpu0_01 netmask "$kv_lan_submask" && fw_setenv netmask "$kv_lan_submask"
		if [ ! -z "$LOID_id" -o ! -z "$LOID_password" -o ! -z "$onu_password" -o ! -z "$kv_reboot" ]; then
			# directy write page as output, no good
			#cat $WAIT_REBOOT_HTM > $HTTP_OUTPUT
			# redirect browser to wait_boot page, better
			rm $HTTP_OUTPUT
			echo "HTTP/1.1 301 Moved Permanently" >> $HTTP_OUTPUT
			echo "Location: /cgi-bin/wwwctrl.cgi?action=slid_restart" >> $HTTP_OUTPUT
			(sync; sleep 1; reboot)&
		fi
	fi
fi

exit 0
