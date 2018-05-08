#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

if [ "$1" = "get" ]; then
	if [ -f /tmp/setting.result ]; then
		v_cwmp_boottrap_status=`cat /tmp/setting.result`
		echo "cwmp_boottrap_status=$v_cwmp_boottrap_status"
	fi
	link_type="pon0"
	if [ -f /nvram/wan.dat ]; then
		v_link=`grep ^uplink_physical_port /nvram/wan.dat | cut -d '=' -f2`
		if [ "$v_link" = "4" ]; then
			link_type="pon0"
		elif [ "$v_link" = "5" ]; then
			link_type="nas0"
		elif [ "$v_link" = "0" ]; then
			link_type="eth0.2"
		elif [ "$v_link" = "1" ]; then
			link_type="eth0.3"
		elif [ "$v_link" = "2" ]; then
			link_type="eth0.4"
		elif [ "$v_link" = "3" ]; then
			link_type="eth0.5"
		else
			link_type="pon0"
		fi
	fi
	echo "k_link_type=$link_type"
elif [ "$1" = "clear" ]; then
	[ -f /tmp/setting.result ] && rm -rf /tmp/setting.result
fi
