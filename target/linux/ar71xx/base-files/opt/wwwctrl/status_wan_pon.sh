#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

. /etc/wwwctrl/wwwctrl.cfg
DHCP_LEASE=/var/run/dhcp/dhcpcv4.leases
DHCP_v6LEASE=/var/run/dhcp/dhcpcv6.leases
PPPOE_INFO=/var/run/ppp/pppoe.info
PPPOE_v6INFO=/var/run/ppp6/pppoe.info
DHCPv6_INFO=/var/run/dhcpv6_prefix.conf
IP_CMD=/usr/sbin/ip

if [ "$1" = "get" ]; then
	. $env_conf
	for i in 0 1 2 3 4 5 6 7; do
		eval "WANIF="$"dev_wan${i}_interface"
		[ -z "$WANIF" ] && continue
		eval "ip_assignment="$"wan${i}_ip_assignment"
		eval "ipv6_assignment="$"wan${i}_ipv6_assignment"
		eval "ip_enable="$"wan${i}_ip_enable"
		eval "ipv6_enable="$"wan${i}_ipv6_enable"

		#eval "WANV6IF="$"dev_wan${i}_interface"
		WANV6IF=$WANIF
		WANV6IF_O=$WANIF

		if [ 0$ip_assignment -eq 2 ]; then
			#WANIF=ppp${i}
			unset IFNAME
			[ -f "$PPPOE_INFO.$WANIF" ] && . $PPPOE_INFO.$WANIF
			[ -n "$IFNAME" ] && WANIF=$IFNAME
		fi
		if [ 0$ipv6_assignment -eq 2 ]; then
			unset IFNAME
			[ -f "$PPPOE_v6INFO.$WANV6IF" ] && . $PPPOE_v6INFO.$WANV6IF
			[ -n "$IFNAME" ] && WANV6IF=$IFNAME
		fi

###########	 IPV4 ############
		STATUS=""
		IP=`ifconfig $WANIF|grep "inet addr"|cut -d ':' -f 2|cut -d ' ' -f1`
		if [ 1$ip_assignment -eq 10 -a -z "$IP" ]; then
			IP="0.0.0.0"
		fi

		if [ "$ip_enable" -eq 0 ]; then
			STATUS="Disconnected"
		elif [ -z "$IP" ]; then
			STATUS="Disconnected"
			if [ 0$ip_assignment -eq 2 ]; then
				#grep -q ppp${i} /proc/net/dev && STATUS="Connecting"
				grep -q "$WANIF" /proc/net/dev && STATUS="Connecting"
			elif [ 0$ip_assignment -eq 1 ]; then
				[ -f /var/run/dhcp/dhcpcv4.pid.$WANIF ] && \
					ps |grep -q `cat /var/run/dhcp/dhcpcv4.pid.$WANIF` && STATUS="Connecting"
			fi

		else
			STATUS="Connected"
			NETMASK=`ifconfig $WANIF|grep "Mask"|cut -d ':' -f 4`
			if [ 0$ip_assignment -eq 2 ]; then
				if [ "$IP" = "10.64.64.64" -o "$IP" = "10.112.112.112" ]; then
					STATUS="Connect on demand"
					IP=""
					NETMASK=""
				else
					eval "IF_NAME="$"dev_wan${i}_interface"
					#[ -f $PPPOE_INFO.$IF_NAME ] && awk -F '=' -v ind=$i '{if($1=="IPREMOTE") {print "kv_info_wan"ind"_gateway="$2} else if($1=="DNS1") {print "kv_info_wan"ind"_dns1="$2} else if($1=="DNS2") {print "kv_info_wan"ind"_dns2="$2}}' $PPPOE_INFO.$IF_NAME
					if [ -f $PPPOE_INFO.$IF_NAME ]; then
						GATEWAY=`grep IPREMOTE $PPPOE_INFO.$IF_NAME| cut -d '=' -f 2`
						DNS1=`grep DNS1 $PPPOE_INFO.$IF_NAME| cut -d '=' -f 2`
						DNS2=`grep DNS2 $PPPOE_INFO.$IF_NAME| cut -d '=' -f 2`
						echo "kv_info_wan${i}_gateway=${GATEWAY}"
						echo "kv_info_wan${i}_dns1=${DNS1}"
						echo "kv_info_wan${i}_dns2=${DNS2}"
					fi
				fi

			elif [ 0$ip_assignment -eq 1 ]; then
				ip1=`echo $IP|cut -d '.' -f 1`
				ip2=`echo $IP|cut -d '.' -f 2`
				if [ "$ip1" = "169" -a "$ip2" = "254" ]; then
					STATUS="Disconnected"
					[ -f /var/run/dhcp/dhcpcv4.pid.$WANIF ] && \
						ps |grep -q `cat /var/run/dhcp/dhcpcv4.pid.$WANIF` && STATUS="Connecting"
				else
					[ -f $DHCP_LEASE.$WANIF ] && tail -n 12 $DHCP_LEASE.$WANIF|sed 's/;//g'|sed 's/,/ /g' |
					awk -v ind=$i  '{
							if($2=="routers") {print "kv_info_wan"ind"_gateway="$3}
							else if($2=="domain-name-servers") {print "kv_info_wan"ind"_dns1="$3"\nkv_info_wan"ind"_dns2="$4}
							}'
				fi

			elif [ 1$ip_assignment -eq 10 ]; then
				if [ "$IP" = "0.0.0.0" ]; then
					STATUS="Disconnected"
				fi
				eval "GATEWAY="$"wan${i}_gateway"
				eval "IP="$"wan${i}_ip"
				eval "NETMASK="$"wan${i}_netmask"
				eval "DNS1="$"wan${i}_dns1"
				eval "DNS2="$"wan${i}_dns2"

				echo -e "kv_info_wan${i}_gateway=$GATEWAY\nkv_info_wan${i}_dns1=${DNS1}\nkv_info_wan${i}_dns2=${DNS2}"

			fi
		fi

#		NETMASK=`ifconfig $WANIF|grep "Mask"|cut -d ':' -f 4`
#		echo -e "kv_info_wan${i}_ip=$IP\nkv_info_wan${i}_netmask=$NETMASK\nkv_info_wan${i}_status=$STATUS"

		echo "kv_info_wan${i}_ip=$IP"
		echo "kv_info_wan${i}_netmask=$NETMASK"
		echo "kv_info_wan${i}_status=$STATUS"

###########	 IPV6 ############
		STATUSv6=""

		#IPv6G=`ifconfig $WANV6IF|grep "inet6 addr.*Global"| tr -s ' ' | cut -d ' ' -f 4`
		#IPv6L=`ifconfig $WANV6IF|grep "inet6 addr.*Link"  | tr -s ' ' | cut -d ' ' -f 4`
		IPv6G=`$IP_CMD address show $WANV6IF|grep "inet6.*global"| tr -s ' ' | cut -d ' ' -f 3`
		IPv6L=`$IP_CMD address show $WANV6IF|grep "inet6.*link"	 | tr -s ' ' | cut -d ' ' -f 3`
		
		#echo "WANV6IF=" $WANV6IF > /dev/console
		IPv6=$IPv6G
		if [ 1$ipv6_assignment -eq 10 -a -z "$IPv6" ]; then
			IPv6="0.0.0.0"
		fi
		IPv6dns1=""
		IPv6dns2=""

		if [ "$ipv6_enable" -eq 0 ]; then
			STATUSv6="Disconnected"
		elif [ -z "$IPv6" ]; then
			STATUSv6="Disconnected"
			if [ 0$ipv6_assignment -eq 2 ]; then
				grep -q "$WANV6IF" /proc/net/dev && STATUSv6="Connecting"
			elif [ 0$ipv6_assignment -eq 1 ]; then
				[ -f /var/run/dhcp/dhcpcv6.pid.$WANIF ] && \
					ps |grep -q `cat /var/run/dhcp/dhcpcv6.pid.$WANIF` && STATUSv6="Connecting"
			fi

		else
			STATUSv6="Connected"
			NETMASK=`ifconfig $WANIF|grep "Mask"|cut -d ':' -f 4`
			if [ 0$ipv6_assignment -eq 2 ]; then
				PPPOEv6_INFO_o="$PPPOE_v6INFO.$WANV6IF_O"
				if [ -f "$PPPOEv6_INFO_o" ]; then
					WANV6IF=`grep IFNAME $PPPOEv6_INFO_o| cut -d '=' -f 2`
					IPv6_gateway=`grep LLREMOTE $PPPOEv6_INFO_o| cut -d '=' -f 2`
				fi
				PPPOEv6_DNSINFO=/var/run/odhcp6c.$WANV6IF
				if [ -f "$PPPOEv6_DNSINFO" ]; then
					IPv6dns1=`grep ^DNS ${PPPOEv6_DNSINFO}| cut -d '=' -f 2 | cut -d ' ' -f 1`
					IPv6dns2=`grep ^DNS ${PPPOEv6_DNSINFO}| cut -d '=' -f 2 | cut -d ' ' -f 2`
				fi
			elif [ 0$ipv6_assignment -eq 1 ]; then
				ip1=`echo $IPv6|cut -d '.' -f 1`
				ip2=`echo $IPv6|cut -d '.' -f 2`
				#if [ "$ip1" = "169" -a "$ip2" = "254" ]; then
				#	STATUSv6="Disconnected"
				#	[ -f /var/run/dhcp/dhcpcv6.pid.$WANIF ] && \
				#		ps |grep -q `cat /var/run/dhcp/dhcpcv6.pid.$WANIF` && STATUSv6="Connecting"
				#else
				#	[ -f $DHCP_LEASE.$WANIF ] && tail -n 12 $DHCP_LEASE.$WANIF|sed 's/;//g'|sed 's/,/ /g' |
				#	awk -v ind=$i  '{
				#			if($2=="routers") {print "kv_info_wan"ind"_gateway="$3}
				#			else if($2=="domain-name-servers") {print "kv_info_wan"ind"_dns1="$3"\nkv_info_wan"ind"_dns2="$4}
				#			}'
				#fi

			elif [ 1$ipv6_assignment -eq 10 ]; then
				if [ "$IPv6" = "0.0.0.0" ]; then
					STATUSv6="Disconnected"
					WANV6PON=`echo $WANV6IF| cut -d '.' -f 1`
					IPv6L=`$IP_CMD address show $WANV6PON|grep "inet6.*link"  | tr -s ' ' | cut -d ' ' -f 3`
				fi

				eval "IPv6G="$"wan${i}_ipv6_ip/"$"wan${i}_ipv6_prefix_length"
				#eval "IPv6L="$"wan${i}_ipv6_gua_prefix"
				eval "IPv6GW="$"wan${i}_ipv6_gateway"
				eval "IPv6DNS1="$"wan${i}_ipv6_dns1"
				eval "IPv6DNS2="$"wan${i}_ipv6_dns2"
				IPv6_gateway=${IPv6GW}
				IPv6dns1=${IPv6DNS1}
				IPv6dns2=${IPv6DNS2}

			fi
		fi

		DHCPv6_PD=""
		if [ -f $DHCPv6_INFO ]; then
			DHCPv6_PD=`grep "wan${i}.*dhcp_prefix" $DHCPv6_INFO|cut -d "=" -f2|sed -e 's/\"//g'|cut -d ',' -f1`
		fi
		echo "kv_info_wan${i}_v6status=$STATUSv6"
		echo "kv_info_wan${i}_ipv6G=$IPv6G"
		echo "kv_info_wan${i}_ipv6L=$IPv6L"
		echo "kv_info_wan${i}_ipv6gateway=$IPv6_gateway"
		echo "kv_info_wan${i}_ipv6DNS1=$IPv6dns1"
		echo "kv_info_wan${i}_ipv6DNS2=$IPv6dns2"
		echo "kv_info_wan${i}_dhcpv6pd=$DHCPv6_PD"

	done
#IPV6 for br0
		LANIF="br0"
		#LanIPv6G=`ifconfig $LANIF|grep "inet6 addr.*Global"| tr -s ' ' | cut -d ' ' -f 4`
		#LanIPv6L=`ifconfig $LANIF|grep "inet6 addr.*Link"	| tr -s ' ' | cut -d ' ' -f 4`
		LanIPv6G=`$IP_CMD address show $LANIF|grep "inet6.*global"| tr -s ' ' | cut -d ' ' -f 3`
		LanIPv6L=`$IP_CMD address show $LANIF|grep "inet6.*link"  | tr -s ' ' | cut -d ' ' -f 3`
		echo "kv_info_br0_ipv6G=$LanIPv6G"
		echo "kv_info_br0_ipv6L=$LanIPv6L"

fi
