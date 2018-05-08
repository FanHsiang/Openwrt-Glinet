#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/etc/init.d:/etc/bin; export PATH

if [ -d "/opt/wwwctrl/" ]; then
	RUNTIME_ROOTDIR="/"
else
	# find thr faked root dir for x86 runtime
	dir=`dirname $0`;dir=`dirname $dir`;dir=`dirname $dir`
	RUNTIME_ROOTDIR=$dir
fi
#LANIP_DIR=$RUNTIME_ROOTDIR/opt/wwwctrl/kkk
if [ "$1" = "get" ]; then
	if [ ! -d "/opt/wwwctrl/" ]; then
		# simulation on X86 runtime

		echo "
		anig_temperature=28.5
		anig_vcc=12.5
		anig_bias=0.7
		anig_tx=1.2
		anig_rx=-20"
		echo "system_uptime=$system_uptime"
	else
		set -- `/etc/init.d/bosa.sh report`
		anig_temperature=$3
		anig_vcc=$7
		anig_bias=$11
		#anig_tx=$15
		local anig_tx; anig_tx=`omcicli -c "misc anig" | grep 'tx' | sed 's/.*uW(//;s/ dBm).*//'`


		#anig_rx=$19
		local anig_rx; anig_rx=`omcicli -c "misc anig" | grep 'rx' | sed 's/.*uW(//;s/ dBm).*//'`

		pon_status=` diag gpon get onu-state | grep 'ONU state' | cut -d'(' -f2 | cut -d')' -f1`

		[ -f /root/version ] && . /root/version
#		/usr/bin/onutool --get_allinfo 2>/dev/null
		echo "anig_temperature=$anig_temperature"
		echo "anig_vcc=$anig_vcc"
		echo "anig_bias=$anig_bias"
		echo "anig_tx=$anig_tx"
		echo "anig_rx=$anig_rx"
		echo "pon_status=$pon_status"


		rx_power_low=`omcicli -c "attr get 263 0x8001 11" | grep 0x | sed -e 's/.*(//' | sed -e 's/)//'`
		echo "kv_rx_power_low_thresh=$rx_power_low"

		rx_power_low_warning=`omcicli -c "attr get 65312 0x8001 14" | grep 0x | sed -e 's/.*(//' | sed -e 's/)//'`
		echo "kv_rx_power_warning_low_thresh=$rx_power_low_warning"

		rx_power_high=`omcicli -c "attr get 263 0x8001 12" | grep 0x | sed -e 's/.*(//' | sed -e 's/)//'`
		echo "kv_rx_power_high_thresh=$rx_power_high"

		rx_power_high_warning=`omcicli -c "attr get 65312 0x8001 13" | grep 0x | sed -e 's/.*(//' | sed -e 's/)//'`
		echo "kv_rx_power_warning_high_thresh=$rx_power_high_warning"

		tx_power_low=`omcicli -c "attr get 263 0x8001 15" | grep 0x | sed -e 's/.*(//' | sed -e 's/)//'`
		echo "kv_tx_power_low_thresh=$tx_power_low"

		tx_power_low_warning=`omcicli -c "attr get 65312 0x8001 16" | grep 0x | sed -e 's/.*(//' | sed -e 's/)//'`
		echo "kv_tx_power_warning_low_thresh=$tx_power_low_warning"

		tx_power_high=`omcicli -c "attr get 263 0x8001 16" | grep 0x | sed -e 's/.*(//' | sed -e 's/)//'`
		echo "kv_tx_power_high_thresh=$tx_power_high"

		tx_power_high_warning=`omcicli -c "attr get 65312 0x8001 15" | grep 0x | sed -e 's/.*(//' | sed -e 's/)//'`
		echo "kv_tx_power_warning_high_thresh=$tx_power_high_warning"

		temp_high=`omcicli -c "attr get 65312 0x8001 1" | grep 0x | sed -e 's/.*(//' | sed -e 's/)//'`
		echo "kv_temp_high_thresh=$temp_high"

		temp_high_warning=`omcicli -c "attr get 65312 0x8001 7" | grep 0x | sed -e 's/.*(//' | sed -e 's/)//'`
		echo "kv_temp_warning_high_thresh=$temp_high_warning"

		temp_low=`omcicli -c "attr get 65312 0x8001 4" | grep 0x | sed -e 's/.*(//' | sed -e 's/)//'`
		echo "kv_temp_low_thresh=$temp_low"

		temp_low_warning=`omcicli -c "attr get 65312 0x8001 10" | grep 0x | sed -e 's/.*(//' | sed -e 's/)//'`
		echo "kv_temp_warning_low_thresh=$temp_low_warning"

		volt_high=`omcicli -c "attr get 65312 0x8001 2" | grep 0x | sed -e 's/.*(//' | sed -e 's/)//'`
		echo "kv_volt_high_thresh=$volt_high"

		volt_high_warning=`omcicli -c "attr get 65312 0x8001 8" | grep 0x | sed -e 's/.*(//' | sed -e 's/)//'`
		echo "kv_volt_warning_high_thresh=$volt_high_warning"

		volt_low=`omcicli -c "attr get 65312 0x8001 5" | grep 0x | sed -e 's/.*(//' | sed -e 's/)//'`
		echo "kv_volt_low_thresh=$volt_low"

		volt_low_warning=`omcicli -c "attr get 65312 0x8001 11" | grep 0x | sed -e 's/.*(//' | sed -e 's/)//'`
		echo "kv_volt_warning_low_thresh=$volt_low_warning"

		bias_high=`omcicli -c "attr get 65312 0x8001 3" | grep 0x | sed -e 's/.*(//' | sed -e 's/)//'`
		echo "kv_bias_high_thresh=$bias_high"

		bias_high_warning=`omcicli -c "attr get 65312 0x8001 9" | grep 0x | sed -e 's/.*(//' | sed -e 's/)//'`
		echo "kv_bias_warning_high_thresh=$bias_high_warning"

		bias_low=`omcicli -c "attr get 65312 0x8001 6" | grep 0x | sed -e 's/.*(//' | sed -e 's/)//'`
		echo "kv_bias_low_thresh=$bias_low"

		bias_low_warning=`omcicli -c "attr get 65312 0x8001 12" | grep 0x | sed -e 's/.*(//' | sed -e 's/)//'`
		echo "kv_bias_warning_low_thresh=$bias_low_warning"
	fi
fi
exit 0
