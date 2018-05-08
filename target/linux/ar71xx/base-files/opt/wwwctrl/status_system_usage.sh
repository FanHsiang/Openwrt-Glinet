#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
if [ -d "/opt/wwwctrl/" ]; then
	RUNTIME_ROOTDIR="/"
else
	# find thr faked root dir for x86 runtime
	dir=`dirname $0`;dir=`dirname $dir`;dir=`dirname $dir`
	RUNTIME_ROOTDIR=$dir
fi

#if [ -d "/proc/rg" ]; then
#	WIFI="wlan1"
#else
#	WIFI="wlan0"
#fi

. $RUNTIME_ROOTDIR/etc/wwwctrl/wwwctrl.cfg
WWWCTRL_BIN=$RUNTIME_ROOTDIR/opt/httpd/data/cgi-bin/wwwctrl.cgi

. /var/run/rc.conf
WIFI=$dev_wlan0_interface
WIFIAC=$dev_wlanac0_interface

IP_CMD=/usr/sbin/ip

if [ "$1" = "set" ]; then
    :
elif [ "$1" = "get" ]; then
	#release memory
	sync && echo 3 > /proc/sys/vm/drop_caches
	release_data=""
	sys_uptime=""
	sys_loadaverage=""
	total_mem=""
	used_mem=""
	free_mem=""
	wan_mac=""
	lan_mac=""
	wlan_mac=""

	#v_release_data=`uname -v | awk '{print $2,$3,$4,$5,$6,$7}'`
	set -- `uname -v | sed -e 's/ \+/ /g'`
	v_release_data="$2 $3 $4 $5 $6 $7"
	#v_sys_uptime=`cat /proc/uptime| awk -F. '{run_days=$1 / 86400;run_hour=($1 % 86400)/3600;run_minute=($1 % 3600)/60;run_second=$1 % 60;printf("%d Days %d Hours %d Mins %d Seconds\n",run_days,run_hour,run_minute,run_second)}'`
	v_sys_uptime=`cat /proc/uptime|cut -d ' ' -f 1`

	#v_sys_loadaverage=`uptime |awk '{print $NF}'`
	v_sys_loadaverage=`uptime | sed -e "s/.*average:/average:/" | cut -d " " -f 4`

	set -- `free |grep "Mem:" | sed -e 's/ \+/ /g'`
	v_total_mem=$2

	set -- `free |grep "buffers:" | sed -e 's/ \+/ /g'`
	v_used_mem=$3
	v_free_mem=$4

	#eval "local default_route_interface="$"system_default_route_interface"
	#eval "local route_interface="$"$default_route_interface"
	eval "local route_interface="$"$system_default_route_interface"
	route_interface=`echo $route_interface| cut -d "." -f 1`
	#v_wan_mac=`ifconfig $route_interface |grep "$route_interface" | sed -e 's/ \+/ /g'| cut -d " " -f 5`
	set -- `$IP_CMD link show $route_interface | grep link | tr '[a-z]' '[A-Z]'`
	v_wan_mac=$2

	#v_lan_mac=`ifconfig br0 |grep "br0" | sed -e 's/ \+/ /g'| cut -d " " -f 5`
	set -- `$IP_CMD link show br0 | grep link | tr '[a-z]' '[A-Z]'`
	v_lan_mac=$2

	#v_wlan_mac=`ifconfig $WIFI |grep $WIFI | sed -e 's/ \+/ /g'| cut -d " " -f 5`
	set -- `$IP_CMD link show $WIFI | grep link | tr '[a-z]' '[A-Z]'`
	v_wlan_mac=$2

	[ ! -z "$dev_wlanac0_interface" ] && v_wlan_ac_mac=`ifconfig $WIFIAC |grep $WIFIAC | sed -e 's/ \+/ /g'| cut -d " " -f 5`

	#v_cpu_avg=`grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}'`
	#v_cpu_us2=`top -n 1 |  grep "CPU:" | awk '{sub(/\%/,"",$8); print 100 - $8" "}'`

 cpu_usage_save_stat() {
	cat /proc/stat > /tmp/proc.stat.data
}

cpu_usage_get() {
	local total_old idle_old total_diff idle_diff usage

	if [ ! -f /tmp/proc.stat.data ]; then
		echo "cpu  0 0 0 0 0 0 0 0 0" >/tmp/proc.stat.data
		#echo "0" > /tmp/proc.stat.time
	fi

	set -- `cat /tmp/proc.stat.data`
	total_old=$(($2+$3+$4+$5+$6+$7+$8))
	idle_old=$5

	cpu_usage_save_stat
	set -- `cat /tmp/proc.stat.data`
	total_diff=$(($2+$3+$4+$5+$6+$7+$8-$total_old))
	idle_diff=$(($5-$idle_old))
	# show cpu usage
	echo $((($total_diff-$idle_diff)*100/$total_diff))
}

#echo "cpu_usage="`cpu_usage_get`
#cpu_usage_save_stat

	[ `pidof dhcpd` != "" ] && dhcpd_active="Active" || dhcpd_active="Inactive"
	echo "dhcpd_active=$dhcpd_active"

	[ -z "$v_release_data" ] && v_release_data=""
	echo "release_data=$v_release_data"

	[ -z "$v_sys_uptime" ] && v_sys_uptime=""
	echo "sys_uptime=$v_sys_uptime"

	[ -z "$v_sys_loadaverage" ] && v_sys_loadaverage=""
	echo "sys_loadaverage=$v_sys_loadaverage"

	[ -z "$v_total_mem" ] && v_total_mem=""
	echo "total_mem=$v_total_mem"

	[ -z "$v_used_mem" ] && v_used_mem=""
	echo "used_mem=$v_used_mem"

	[ -z "$v_free_mem" ] && v_free_mem=""
	echo "free_mem=$v_free_mem"

	[ -z "$v_wan_mac" ] && v_wan_mac=""
	echo "wan_mac=$v_wan_mac"

	[ -z "$v_lan_mac" ] && v_lan_mac=""
	echo "lan_mac=$v_lan_mac"

	[ -z "$v_wlan_mac" ] && v_wlan_mac=""
	echo "wlan_mac=$v_wlan_mac"

	if [ ! -z "$v_wlan_ac_mac" ]; then
		wlan_mac=$v_wlan_ac_mac
		echo "wlan_ac_mac=$v_wlan_ac_mac"
	fi

	#echo "fw_version=`cat /root/version |grep version|awk -F= '{printf $2}'`"
	echo "fw_version=`cat /root/version |grep version|cut -d '=' -f 2`"

	#echo "kv_onu_serial=`cat /nvram/gpon.dat|grep ^onu_serial|cut -d '=' -f 2`"
	. /nvram/gpon.dat
	echo "kv_onu_serial="$onu_serial
	echo "kv_onu_password="$onu_password

	/etc/init.d/wifi_proc.sh start > /dev/null

	# for 11N
	#kv_channel_num1=`cat /proc/$WIFI/mib_rf | grep dot11channel|awk -F: '{print $2}'`
	#kv_channel_num1=`cat /proc/$WIFI/mib_rf | grep dot11channel|sed -e "s/.*: //"`
	set -- `grep dot11channel /proc/$WIFI/mib_rf`
		echo "kv_channel_num1"=$2
	set -- `grep dot11channel /proc/$WIFI-vap0/mib_rf`
		echo "kv_channel_num2"=$2
	set -- `grep dot11channel /proc/$WIFI-vap1/mib_rf`
		echo "kv_channel_num3"=$2
	set -- `grep dot11channel /proc/$WIFI-vap2/mib_rf`
		echo "kv_channel_num4"=$2

	# for 11AC
	if [ ! -z "$dev_wlanac0_interface" ]; then
		#kv_channel_ac_num1=`cat /proc/$WIFIAC/mib_rf | grep dot11channel|awk -F: '{print $2}'`
		#kv_channel_ac_num1=`cat /proc/$WIFIAC/mib_rf | grep dot11channel |sed -e "s/.*: //"`
		#	echo "kv_channel_ac_num1"=$kv_channel_ac_num1
		set -- `grep dot11channel /proc/$WIFIAC/mib_rf`
			echo "kv_channel_ac_num1"=$2
		set -- `grep dot11channel /proc/$WIFIAC-vap0/mib_rf`
			echo "kv_channel_ac_num2"=$2
		set -- `grep dot11channel /proc/$WIFIAC-vap1/mib_rf`
			echo "kv_channel_ac_num3"=$2
		set -- `grep dot11channel /proc/$WIFIAC-vap2/mib_rf`
			echo "kv_channel_ac_num4"=$2
	fi

	#. /opt/wwwctrl/status_wan_pon.sh get
	/opt/wwwctrl/status_wan_pon.sh get

	echo "date="`date -I'seconds'`
fi
exit 0
