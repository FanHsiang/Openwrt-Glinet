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

#if [ -d "/proc/rg" ]; then
#	WIFI="wlan1"
#else
#	WIFI="wlan0"
#fi
WIFI=$dev_wlan0_interface
WIFIAC=$dev_wlanac0_interface

if [ "$1" = "get" ]; then
	/etc/init.d/wifi_proc.sh start > /dev/null

	# for 11N
    kv_sta_num1=`cat /proc/$WIFI/sta_info | grep hwaddr|wc -l`
	kv_channel_num1=`cat /proc/$WIFI/mib_rf | grep dot11channel|awk -F: '{print $2}'`
    echo "kv_sta_num1=$kv_sta_num1"
    for i in `seq 1 $kv_sta_num1`;do
        echo "kv_sta_mac1_$i=`cat /proc/$WIFI/sta_info|grep hwaddr|awk 'NR=='$i''|awk '{print $2}'`"
        echo "kv_sta_rate1_$i=`cat /proc/$WIFI/sta_info | grep current_tx_rate |awk 'NR=='$i''|awk '{print $NF}'`"
		echo "kv_sta_channel1_$i"=$kv_channel_num1
		echo "kv_sta_time1_$i=`cat /proc/$WIFI/sta_info |grep link_time | awk 'NR=='$i'' |awk -F : '{print $2}'`"
    done
    kv_sta_num2=`cat /proc/$WIFI-vap0/sta_info | grep hwaddr|wc -l`
	kv_channel_num2=`cat /proc/$WIFI-vap0/mib_rf | grep dot11channel|awk -F: '{print $2}'`
    echo "kv_sta_num2=$kv_sta_num2"
    for j in `seq 1 $kv_sta_num2`;do
        echo "kv_sta_mac2_$j=`cat /proc/$WIFI-vap0/sta_info|grep hwaddr|awk 'NR=='$j''|awk '{print $2}'`"
        echo "kv_sta_rate2_$j=`cat /proc/$WIFI-vap0/sta_info | grep current_tx_rate |awk 'NR=='$j''|awk '{print $NF}'`"
		echo "kv_sta_channel2_$j"=$kv_channel_num2
		echo "kv_sta_time2_$j=`cat /proc/$WIFI-vap0/sta_info |grep link_time | awk 'NR=='$j'' |awk -F : '{print $2}'`"
    done
    kv_sta_num3=`cat /proc/$WIFI-vap1/sta_info | grep hwaddr|wc -l`
	kv_channel_num3=`cat /proc/$WIFI-vap1/mib_rf | grep dot11channel|awk -F: '{print $2}'`
    echo "kv_sta_num3=$kv_sta_num3"
    for k in `seq 1 $kv_sta_num3`;do
        echo "kv_sta_mac3_$k=`cat /proc/$WIFI-vap1/sta_info|grep hwaddr|awk 'NR=='$k''|awk '{print $2}'`"
        echo "kv_sta_rate3_$k=`cat /proc/$WIFI-vap1/sta_info | grep current_tx_rate |awk 'NR=='$k''|awk '{print $NF}'`"
		echo "kv_sta_channel3_$k"=$kv_channel_num3
		echo "kv_sta_time3_$k=`cat /proc/$WIFI-vap1/sta_info |grep link_time | awk 'NR=='$k'' |awk -F : '{print $2}'`"
    done
    kv_sta_num4=`cat /proc/$WIFI-vap2/sta_info | grep hwaddr|wc -l`
	kv_channel_num4=`cat /proc/$WIFI-vap2/mib_rf | grep dot11channel|awk -F: '{print $2}'`
    echo "kv_sta_num4=$kv_sta_num4"
    for m in `seq 1 $kv_sta_num4`;do
        echo "kv_sta_mac4_$m=`cat /proc/$WIFI-vap2/sta_info|grep hwaddr|awk 'NR=='$m''|awk '{print $2}'`"
        echo "kv_sta_rate4_$m=`cat /proc/$WIFI-vap2/sta_info | grep current_tx_rate |awk 'NR=='$m''|awk '{print $NF}'`"
		echo "kv_sta_channel4_$m"=$kv_channel_num4
		echo "kv_sta_time4_$m=`cat /proc/$WIFI-vap2/sta_info |grep link_time | awk 'NR=='$m'' |awk -F : '{print $2}'`"
    done

	# for 11AC
	if [ ! -z "$dev_wlanac0_interface" ]; then
		kv_sta_ac_num1=`cat /proc/$WIFIAC/sta_info | grep hwaddr|wc -l`
		kv_channel_num1=`cat /proc/$WIFIAC/mib_rf | grep dot11channel|awk -F: '{print $2}'`
		echo "kv_sta_ac_num1=$kv_sta_ac_num1"
		for i in `seq 1 $kv_sta_ac_num1`;do
			echo "kv_sta_ac_mac1_$i=`cat /proc/$WIFIAC/sta_info|grep hwaddr|awk 'NR=='$i''|awk '{print $2}'`"
			echo "kv_sta_ac_rate1_$i=`cat /proc/$WIFIAC/sta_info | grep current_tx_rate |awk 'NR=='$i''|awk '{print $NF}'`"
			echo "kv_sta_ac_channel1_$i"=$kv_channel_num1
			echo "kv_sta_ac_time1_$i=`cat /proc/$WIFIAC/sta_info |grep link_time | awk 'NR=='$i'' |awk -F : '{print $2}'`"
		done
		kv_sta_ac_num2=`cat /proc/$WIFIAC-vap0/sta_info | grep hwaddr|wc -l`
		kv_channel_num2=`cat /proc/$WIFIAC-vap0/mib_rf | grep dot11channel|awk -F: '{print $2}'`
		echo "kv_sta_ac_num2=$kv_sta_ac_num2"
		for j in `seq 1 $kv_sta_ac_num2`;do
			echo "kv_sta_ac_mac2_$j=`cat /proc/$WIFIAC-vap0/sta_info|grep hwaddr|awk 'NR=='$j''|awk '{print $2}'`"
			echo "kv_sta_ac_rate2_$j=`cat /proc/$WIFIAC-vap0/sta_info | grep current_tx_rate |awk 'NR=='$j''|awk '{print $NF}'`"
			echo "kv_sta_ac_channel2_$j"=$kv_channel_num2
			echo "kv_sta_ac_time2_$j=`cat /proc/$WIFIAC-vap0/sta_info |grep link_time | awk 'NR=='$j'' |awk -F : '{print $2}'`"
		done
		kv_sta_ac_num3=`cat /proc/$WIFIAC-vap1/sta_info | grep hwaddr|wc -l`
		kv_channel_num3=`cat /proc/$WIFIAC-vap1/mib_rf | grep dot11channel|awk -F: '{print $2}'`
		echo "kv_sta_ac_num3=$kv_sta_ac_num3"
		for k in `seq 1 $kv_sta_ac_num3`;do
			echo "kv_sta_ac_mac3_$k=`cat /proc/$WIFIAC-vap1/sta_info|grep hwaddr|awk 'NR=='$k''|awk '{print $2}'`"
			echo "kv_sta_ac_rate3_$k=`cat /proc/$WIFIAC-vap1/sta_info | grep current_tx_rate |awk 'NR=='$k''|awk '{print $NF}'`"
			echo "kv_sta_ac_channel3_$k"=$kv_channel_num3
			echo "kv_sta_ac_time3_$k=`cat /proc/$WIFIAC-vap1/sta_info |grep link_time | awk 'NR=='$k'' |awk -F : '{print $2}'`"
		done
		kv_sta_ac_num4=`cat /proc/$WIFIAC-vap2/sta_info | grep hwaddr|wc -l`
		kv_channel_num4=`cat /proc/$WIFIAC-vap2/mib_rf | grep dot11channel|awk -F: '{print $2}'`
		echo "kv_sta_ac_num4=$kv_sta_ac_num4"
		for m in `seq 1 $kv_sta_ac_num4`;do
			echo "kv_sta_ac_mac4_$m=`cat /proc/$WIFIAC-vap2/sta_info|grep hwaddr|awk 'NR=='$m''|awk '{print $2}'`"
			echo "kv_sta_ac_rate4_$m=`cat /proc/$WIFIAC-vap2/sta_info | grep current_tx_rate |awk 'NR=='$m''|awk '{print $NF}'`"
			echo "kv_sta_ac_channel4_$m"=$kv_channel_num4
			echo "kv_sta_ac_time4_$m=`cat /proc/$WIFIAC-vap2/sta_info |grep link_time | awk 'NR=='$m'' |awk -F : '{print $2}'`"
		done
	fi

fi
exit 0
