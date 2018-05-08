#!/bin/sh

UP_DOWN_TIME_FILE=/var/run/ether_port_up_down_time
ROUTE_FILE=/tmp/route_status

if [ "$1" = "get" ]; then
	pon_link="Up(O5)"
	onu_state=`diag gpon get onu-state | grep 'ONU state' | cut -d'(' -f2 | cut -d')' -f1`

	[ "$onu_state" != "O5" ] && eval "pon_link=\"Down("$"onu_state)\""

	echo -e "kv_pon_link=$pon_link\nkv_pon_speed=1.244Gbps"

	diag port get status port all | grep [UD][op] |
	awk '{
		if(NR<=4){
			speed="N/A"
			if($2=="Up"){
				speed=$3"bps/"
				if($4=="Full") speed=speed"FD"
				else speed=speed"HD"
			}
			print "kv_lan"NR"_link="$2"\nkv_lan"NR"_speed="speed
		}
		 }'

	if [ "$onu_state" != "O5" ]; then
		pon_duration=`omci -c "bat dump linkready" | grep down_time|sed 's/=/ /'|cut -d ' ' -f 2`
	else
		pon_duration=`omci -c "bat dump linkready" | grep up_time|sed 's/=/ /'|cut -d ' ' -f 2`
	fi
	echo "kv_pon_time=$pon_duration"

	[ -f $UP_DOWN_TIME_FILE ] && ( \
		now=`cat /proc/uptime |cut -d ' ' -f 1` ;\
		awk -v t=$now '{print "kv_lan"NR"_time="int(t-$3)}' $UP_DOWN_TIME_FILE )

# prepare route files
	route -n | grep ^[0-9] > $ROUTE_FILE.$$

	cat $ROUTE_FILE.$$ | awk 'BEGIN{N=0}{
		print "kv_RT_Dest_" N "="$1
		print "kv_RT_GW_" N "="$2
		print "kv_RT_Nmask_" N "="$3
		print "kv_RT_metric_" N "="$5
		print "kv_RT_Iface_" N "="$8
		N++
		}'

	rm -rf $ROUTE_FILE.$$
fi
