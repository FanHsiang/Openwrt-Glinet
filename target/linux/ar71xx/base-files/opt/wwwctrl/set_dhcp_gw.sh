#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/etc/init.d:/etc/bin; export PATH
RC_CONF_STAGING=/var/run/rc.conf.staging

# include the enviro's
. $RC_CONF_STAGING
(test -f /etc/wwwctrl/wwwctrl.cfg) && . /etc/wwwctrl/wwwctrl.cfg

# since the lease file wont be created until the whole dhclient-script is executed complete
# and this script is called by dhclient-script through cmd_dispatcher check stage indirectly,
# we use env file instead of lease file to find the new dhcp gateway ip
for i in 0 1 2 3 4 5 6 7; do
	eval "wan_if="$"dev_wan${i}_interface"
	if [ ! -z "$wan_if" ]; then
		eval "wan_enable="$"wan${i}_enable"
		eval "wan_ip_assignment="$"wan${i}_ip_assignment"	# 0:static, 1:dhcp, 2:pppoe
		if [ "$wan_enable" = "1" -a "$wan_ip_assignment" = "1" ]; then
			DHCP_ENV_BOUND=/var/run/dhcp/dhcpcv4.env.$wan_if.BOUND 
			break;
		fi
	fi
done

# this script is called in cmd_dispatcher.cfg ip_changed_wan[0-7] check stage, 
# so it must return 0 or ip_chaged_wan[0-7] related script wont be executed
[ -z "$DHCP_ENV_BOUND" ] && exit 0

# check wan1 dhcp gateway
# force to override the first 2 static route rules gateway to be the gateway of dhcp wan, requested by CHT
if [ "$1" = "set" ] && [ "$metafile" != "" ]; then
	if [ -f $DHCP_ENV_BOUND ]; then
		. $DHCP_ENV_BOUND
		if [ ! -z "$new_routers" -a "$new_routers" != "$sroute_gateway0" ]; then
			echo "sroute_gateway0=$new_routers" >  /tmp/metafile.diff.sroute_gw.$$
			echo "sroute_gateway1=$new_routers" >> /tmp/metafile.diff.sroute_gw.$$
			$cmd_dispatcher_bin -r0 -t $cmd_dispatcher_cfg -s /etc/wwwctrl/metafile.dat -e /var/run/rc.conf -d /tmp/metafile.diff.sroute_gw.$$ > /dev/null
			rm /tmp/metafile.diff.sroute_gw.$$
		fi
	fi
fi

exit 0
