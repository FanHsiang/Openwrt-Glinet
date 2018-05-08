#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

TMP_FILE1=/tmp/pon_statistics.log
TMP_FILE2=/tmp/switch.statistics
WAN_STATISTICS=/tmp/wan_pon_statistics
WLAN_STATISTICS=/tmp/wlan_statistics
WLANac_STATISTICS=/tmp/wlanac_statistics

if [ "$1" = "get" ]; then
	. /var/run/rc.conf.staging

	# prepare statistics files
	omcicli -c "switch pkt *" | sed 's/bps//g' > $TMP_FILE2.$$

	rm -rf $TMP_FILE1.$$

	for i in 0 1 2 3 4 5 6 7; do
		eval "wan_if="$"dev_wan${i}_interface"
		[ -z "$wan_if" ] && continue
		# .4097 means untag in "classf g"
		wan_if=$wan_if".4097"
		wan_if=`echo $wan_if|cut -d '.' -f 1-2`
		eval "wan_name="$"wan${i}_if_name"
		echo "interface $wan_if index $i name $wan_name" >> $TMP_FILE1.$$
		# get bridge Upstream/Downstream counter
		brvid=`echo $wan_if | cut -d '.' -f 2`
		[[ ! -z "${brvid//[0-9]}" ]] && brvid=4097
		brcount=`omcicli -c "classf stat $brvid" | grep ^Bridge | tr -s " "`
		#echo $brcount > /dev/console
		US_Cnt=`echo $brcount | cut -d ' ' -f 2`
		echo "kv_USbytecnt_br${i}=${US_Cnt}"
		DS_Cnt=`echo $brcount | cut -d ' ' -f 3`
		echo "kv_DSbytecnt_br${i}=${DS_Cnt}"

		done

	omcicli -c "classf g" >> $TMP_FILE1.$$

	#pon info
	grep pon $TMP_FILE2.$$ | awk -v y=0 '{
		if(NR==2) {
			print "kv_wan_rx_unicast_pkg"y"="$3"\nkv_wan_rx_multicast_pkg"y"="$4
			print "kv_wan_rx_broadcast_pkg"y"="$5"\nkv_wan_rx_rate"y"="$NF
			} else if(NR==3) {
			print "kv_wan_tx_unicast_pkg"y"="$3"\nkv_wan_tx_multicast_pkg"y"="$4
			print "kv_wan_tx_broadcast_pkg"y"="$5"\nkv_wan_tx_rate"y"="$NF
			}
		}'

	cat $TMP_FILE1.$$ | awk -v mode=$ont_mode '{
			if( ($1!="interface") && ($1~/^[0-9]+$/) ) {
				#pb[$1]=$2;
				#gem[$1]=$3;
				txbytes[$1]=$4;
				txpkts[$1]=$5;
				#txrate[$1]=$6;
				rxbytes[$1]=$7;
				rxpkts[$1]=$8;
				#rxrate[$1]=$9;
			}
			else if ($1=="interface") {
				gsub(/pon.\./,"",$2);
				if_name[$4]=$2;
			}
		}
		END{
			if(mode==1) {
				for(i=0;i<8;i++) {
					n = if_name[i];
					if(n !="") {
						print "kv_wan_rx_byte"i"="rxbytes[n]"\nkv_wan_rx_pkg"i"="rxpkts[n]
						print "kv_wan_rx_error"i"=0\nkv_wan_rx_drop"i"=0"
						print "kv_wan_tx_byte"i"="txbytes[n]"\nkv_wan_tx_pkg"i"="txpkts[n]
						print "kv_wan_tx_error"i"=0\nkv_wan_tx_drop"i"=0"
					}
				}
			} else {
				txbytes=0;txpkts=0;txrate=0;rxbytes=0;rxpkts=0;rxrate=0;
				for(i=0;i<8;i++) {
					n = if_name[i];
					if(n !="") {
						txbytes+=txbytes[n];
						txpkts+=txpkts[n]
						rxbytes+=rxbytes[n];
						rxpkts+=rxpkts[n];
					}
				}
				print "kv_wan_rx_byte0="rxbytes"\nkv_wan_rx_pkg0="rxpkts
				print "kv_wan_rx_error0=0\nkv_wan_rx_drop0=0"
				print "kv_wan_tx_byte0="txbytes"\nkv_wan_tx_pkg0="txpkts
				print "kv_wan_tx_error0=0\nkv_wan_tx_drop0=0"
			}
		}'

	for i in 0 1 2 3; do
		grep uni$i $TMP_FILE2.$$ | awk -v y=$i '{
				if(NR==1) {
					print "kv_lan_rx_pkg"y"="$2; print "kv_lan_tx_pkg"y"="$3;
					print "kv_lan_rx_error"y"="$6; print "kv_lan_tx_error"y"="$7;
					print "kv_lan_rx_rate"y"="$8; print "kv_lan_tx_rate"y"="$9;
				} else if(NR==2) {
					print "kv_lan_rx_byte"y"="$2; print "kv_lan_rx_unicast_pkg"y"="$3;
					print "kv_lan_rx_multicast_pkg"y"="$4; print "kv_lan_rx_broadcast_pkg"y"="$5;
					print "kv_lan_rx_drop"y"="$6
				} else if(NR==3) {
					print "kv_lan_tx_byte"y"="$2; print "kv_lan_tx_unicast_pkg"y"="$3;
					print "kv_lan_tx_multicast_pkg"y"="$4; print "kv_lan_tx_broadcast_pkg"y"="$5;
					print "kv_lan_tx_drop"y"="$6
				}
			}'
	done

	if [ "$wlan_enable" = "1" -o "$wlanac_enable" = "1" ]; then
		eval $(diag mib dump counter port 5| sed 's/:/=/'|sed 's/ //g'|grep "=" |grep -v "command")
		echo -e "kv_wlan_rx_broadcast_pkg=$ifInBroadcastPkts\nkv_wlan_rx_unicast_pkg=$ifInUcastPkts"
		echo -e "kv_wlan_rx_multicast_pkg=$ifInMulticastPkts"
		echo -e "kv_wlan_tx_broadcast_pkg=$ifOutBroadcastPkts\nkv_wlan_tx_unicast_pkg=$ifOutUcastPkts"
		echo -e "kv_wlan_tx_multicast_pkg=$ifOutMulticastPkts"
		if ! grep -q "wlan" /proc/mounts; then
			/etc/init.d/wifi_proc.sh start > /dev/null
			do_mount=1
		fi
# 11n
		if [ "$wlan_enable" = "1" ]; then

			for i in 0 1 2 3 5 6 7; do
				eval "wlan_if="$"dev_wlan${i}_interface"

				[ -z "$wlan_if" -o ! -f /proc/$wlan_if/stats ] && continue
				[ $i -ge $wlan_vap_num ] && break

				vap=`echo $wlan_if|sed 's/-/_/'|cut -c6-10`
				#eval $(cat /proc/$wlan_if/stats|grep -v "Statistics"|sed 's/:/=/g'|sed 's/ //g')
				cat /proc/$wlan_if/stats|grep ":"|sed 's/:/=/g'|sed 's/ //g' > $WLAN_STATISTICS
				. $WLAN_STATISTICS
				echo -e "kv_wlan${vap}_rx_byte=$rx_bytes\nkv_wlan${vap}_rx_pkg=$rx_packets"
				echo -e "kv_wlan${vap}_rx_error=$rx_errors\nkv_wlan${vap}_rx_drop=$rx_data_drops"
				echo -e "kv_wlan${vap}_tx_byte=$tx_bytes\nkv_wlan${vap}_tx_pkg=$tx_packets"
				echo -e "kv_wlan${vap}_tx_error=$tx_fails\nkv_wlan${vap}_tx_drop=$tx_drops"
				echo -e "kv_wlan${vap}_rx_ucast_pkts=$rx_ucast_pkts\nkv_wlan${vap}_tx_ucast_pkts=$tx_ucast_pkts"
				echo -e "kv_wlan${vap}_rx_mcast_pkts=$rx_mcast_pkts\nkv_wlan${vap}_tx_mcast_pkts=$tx_mcast_pkts"
				echo -e "kv_wlan${vap}_rx_bcast_pkts=$rx_bcast_pkts\nkv_wlan${vap}_tx_bcast_pkts=$tx_bcast_pkts"
				echo -e "kv_wlan${vap}_rx_rate=$rx_avarage"
				echo -e "kv_wlan${vap}_tx_rate=$tx_avarage"

				#rx_av_i=$(( $rx_avarage*8 / 1000 ))
				#rx_av_m=$(( ($rx_avarage*8 / 10) % 100 ))
				#rx_av_result=$rx_av_i"."$rx_av_m"K"
				#echo -e "kv_wlan${vap}_rx_rate=$rx_av_result"

				#tx_av_i=$(( $tx_avarage*8 / 1000 ))
				#tx_av_m=$(( ($tx_avarage*8 / 10) % 100 ))
				#tx_av_result=$tx_av_i"."$tx_av_m"K"
				#echo -e "kv_wlan${vap}_tx_rate=$tx_av_result"
				rm $WLAN_STATISTICS
			done
		fi
# 11ac
		if [ "$wlanac_enable" = "1" ]; then
			for i in 0 1 2 3 5 6 7; do
				eval "wlan_if="$"dev_wlanac${i}_interface"

				[ -z "$wlan_if" -o ! -f /proc/$wlan_if/stats ] && continue
				[ $i -ge $wlanac_vap_num ] && break

				vap=`echo $wlan_if|sed 's/-/_/'|cut -c6-10`
				#eval $(cat /proc/$wlan_if/stats|grep -v "Statistics"|sed 's/:/=/g'|sed 's/ //g')
				cat /proc/$wlan_if/stats|grep ":"|sed 's/:/=/g'|sed 's/ //g' > $WLANac_STATISTICS
				. $WLANac_STATISTICS
				echo -e "kv_wlanac${vap}_rx_byte=$rx_bytes\nkv_wlanac${vap}_rx_pkg=$rx_packets"
				echo -e "kv_wlanac${vap}_rx_error=$rx_errors\nkv_wlanac${vap}_rx_drop=$rx_data_drops"
				echo -e "kv_wlanac${vap}_tx_byte=$tx_bytes\nkv_wlanac${vap}_tx_pkg=$tx_packets"
				echo -e "kv_wlanac${vap}_tx_error=$tx_fails\nkv_wlanac${vap}_tx_drop=$tx_drops"
				echo -e "kv_wlanac${vap}_rx_ucast_pkts=$rx_ucast_pkts\nkv_wlanac${vap}_tx_ucast_pkts=$tx_ucast_pkts"
				echo -e "kv_wlanac${vap}_rx_mcast_pkts=$rx_mcast_pkts\nkv_wlanac${vap}_tx_mcast_pkts=$tx_mcast_pkts"
				echo -e "kv_wlanac${vap}_rx_bcast_pkts=$rx_bcast_pkts\nkv_wlanac${vap}_tx_bcast_pkts=$tx_bcast_pkts"
				echo -e "kv_wlanac${vap}_rx_rate=$rx_avarage"
				echo -e "kv_wlanac${vap}_tx_rate=$tx_avarage"

				#rx_av_i=$(( $rx_avarage*8 / 1000 ))
				#rx_av_m=$(( ($rx_avarage*8 / 10) % 100 ))
				#rx_av_result=$rx_av_i"."$rx_av_m"K"
				#echo -e "kv_wlanac${vap}_rx_rate=$rx_av_result"

				#tx_av_i=$(( $tx_avarage*8 / 1000 ))
				#tx_av_m=$(( ($tx_avarage*8 / 10) % 100 ))
				#tx_av_result=$tx_av_i"."$tx_av_m"K"
				#echo -e "kv_wlanac${vap}_tx_rate=$tx_av_result"
				rm $WLANac_STATISTICS
			done
		fi
	fi

	rm $TMP_FILE1.$$ $TMP_FILE2.$$

elif [ "$1" = "reset" ]; then
	. /var/run/rc.conf.staging

	omcicli -c "switch pkt reset"
	omcicli -c "gpon cnt reset"
	omcicli -c "classf stat reset"

	if [ "$wlan_enable" = "1" ]; then
		if ! grep -q "wlan" /proc/mounts; then
			/etc/init.d/wifi_proc.sh start > /dev/null
			do_mount=1
		fi
		for i in 0 1 2 3 5 6 7; do
			eval "wlan_if="$"dev_wlan${i}_interface"

			[ -z "$wlan_if" -o ! -f /proc/$wlan_if/stats ] && continue
			[ $i -ge $wlan_vap_num ] && break

			echo 0 >> /proc/$wlan_if/stats
		done

	fi
	if [ "$wlanac_enable" = "1" ]; then
		for i in 0 1 2 3 5 6 7; do
			eval "wlan_if="$"dev_wlanac${i}_interface"

			[ -z "$wlan_if" -o ! -f /proc/$wlan_if/stats ] && continue
			[ $i -ge $wlan_vap_num ] && break

			echo 0 >> /proc/$wlan_if/stats
		done

	fi
fi
