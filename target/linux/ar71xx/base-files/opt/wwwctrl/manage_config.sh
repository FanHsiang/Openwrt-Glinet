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
KVTOOL=/usr/bin/kvtool
USER_SETTING=/tmp/user_settings.diff

if [ -f $metafile ]; then
	$WWWCTRL_BIN --kvprint_shell_escaped $metafile > /tmp/sh.$$;
	. /tmp/sh.$$; rm /tmp/sh.$$
else
	exit 1
fi

if [ -f $metafile_diff.$CGI_PAGE_ID ]; then
	$WWWCTRL_BIN --kvprint_shell_escaped $metafile_diff.$CGI_PAGE_ID > /tmp/sh.$$;
	. /tmp/sh.$$; rm /tmp/sh.$$
fi

stop_odhcp ()
{
	# CHT request, send RA Preferred/Valid Prefix Lifetime=0 before reboot
	/etc/init.d/odhcpd.sh stop 2> /dev/null >/dev/null
	# CHT request, send DHCPv6 Release at PPPoE WAN before reboot
	/etc/init.d/odhcp6c.sh stop 0 2> /dev/null >/dev/null
}

if [ "$1" = "save" ]; then
	metafile_enc=$metafile".enc"
	fencrypt $metafile $metafile_enc 27885VT8118
	set `wc -c $metafile_enc`; len=$1
	name=`basename $metafile`

	echo "Content-Length: $len"									>  $HTTP_OUTPUT
	echo "Connection: close"									>> $HTTP_OUTPUT
	echo "Content-Type: application/octet-stream; name=$name"	>> $HTTP_OUTPUT
	echo "Content-Disposition: attachment; filename=$name"		>> $HTTP_OUTPUT
	echo ""														>> $HTTP_OUTPUT
	cat $metafile_enc >> $HTTP_OUTPUT
elif [ "$1" = "default" ]; then
	/etc/init.d/cwmp.sh factory_reset_apply

	# Clean SLID for factory_reset
	#sed -i s/onu_password=.*/onu_password=default/ /nvram/gpon.dat
	nvram.sh kvset gpon.dat onu_password "default"
	nvram.sh commit gpon.dat

	stop_odhcp

	echo `date +"%Y %b %d %T"`" ***** Reset to Default (Web) *****" > /nvram/security_log && sync
	echo "HTTP/1.1 301 Moved Permanently"						>  $HTTP_OUTPUT
	echo "Location: /cgi-bin/wwwctrl.cgi?action=wait_restart"	>> $HTTP_OUTPUT
	if [ ! -d "/opt/wwwctrl/" ]; then
		# simulation on X86 runtime
		cp -f $metafile.default $metafile
	else
		(sleep 5 && rm -rf /overlay/* && sync && sleep 1 && /bin/busybox reboot) &
	fi
elif [ "$1" = "default_user" ]; then
	/etc/init.d/cwmp.sh factory_reset_apply

	stop_odhcp

	echo `date +"%Y %b %d %T"`" ***** Reset to Default (web) *****" > /nvram/security_log && sync
	echo "HTTP/1.1 301 Moved Permanently"						>  $HTTP_OUTPUT
	echo "Location: /cgi-bin/wwwctrl.cgi?action=wait_restart"	>> $HTTP_OUTPUT
	if [ ! -d "/opt/wwwctrl/" ]; then
		# simulation on X86 runtime
		cp -f $metafile.default $metafile
	else
		rm -f $USER_SETTING
		touch $USER_SETTING

		if [ $ont_mode = "1" ]; then
			#save all pppoe wan info
			pppoe_wan=`grep ip_assignment=2 $metafile |awk -F_ '{print $1}'`
			for wan in $pppoe_wan
			do
				echo $wan
				grep ^$wan $metafile		>> $USER_SETTING
			done

			#save wifi info
			cat /etc/wwwctrl/metafile.dat |grep ^wlan	>> $USER_SETTING
		fi

		##save lan ip
		#grep lan0_ip $metafile >> $USER_SETTING
		#grep lan0_netmask $metafile >> $USER_SETTING

		##save second lan ip
		#grep lan0_alias0_ip $metafile >> $USER_SETTING
		#grep lan0_alias0_netmask $metafile >>	$USER_SETTING

		##save dhcp pool range & mask
		#grep dhcp0_number_start $metafile >> $USER_SETTING
		#grep dhcp0_number_end $metafile >>	 $USER_SETTING
		#grep dhcp0_netmask $metafile >>  $USER_SETTING
		#grep dhcp0_wins_server $metafile >>  $USER_SETTING
		#grep dhcp0_gateway $metafile >>  $USER_SETTING
		#grep dhcp0_dns_server $metafile >>	 $USER_SETTING
		#grep dhcp0_subnet $metafile >>	 $USER_SETTING

		#save ont_mode
		grep ont_mode $metafile				>> $USER_SETTING
		#save TR069 CPE ID
		grep cwmp_cpe_device_id $metafile	>> $USER_SETTING

		(cp -f /rom$metafile $metafile".factory" && mv -f $metafile".factory" $metafile && sync && sleep 1)
		$KVTOOL --kvmerge_update_addnew $metafile $USER_SETTING > $metafile".merge"
		(mv -f $metafile".merge" $metafile && sync && sleep 4 && /bin/busybox reboot) &

	fi
elif [ "$1" = "restore" -a "$wwwctrl_upload_tag" = "config_restore" ]; then
	metafile_dec=$metafile".dec"
	metafile_merge=$metafile".merge"
	rm -f $metafile_dec $metafile_merge
	fencrypt -d $wwwctrl_upload_localfile $metafile_dec 27885VT8118
	if $KVTOOL --kvmerge_update_only $metafile $metafile_dec > $metafile_merge; then
		mv -f $metafile_merge $metafile
		[ -d "/opt/wwwctrl/" ] && (sync && sleep 5 && /sbin/reboot) &
	fi
fi
exit 0
