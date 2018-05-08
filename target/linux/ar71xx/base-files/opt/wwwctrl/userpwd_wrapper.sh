#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/etc/init.d:/etc/bin; export PATH
RC_CONF_STAGING=/var/run/rc.conf.staging
USERPWD_BIN=/opt/wwwctrl/userpwd

# HTTP_HOST not defined, call $USERPWD_BIN with orig args
[ -z "$HTTP_HOST" ] && exec $USERPWD_BIN $*

# include the enviro's
. $RC_CONF_STAGING

args="$*"
while :; do
	echo $1
	if [ -z "$1" ]; then
		break;
	elif [ "$1" = "--get" -o "$1" = "--check" ]; then
		option=$1
		username=$2
		shift 2
	else
		shift 1
	fi
done

if [ -f "/nvram/security_log" ]; then
	lines=`wc -l /nvram/security_log | cut -d ' ' -f 1`
	[ $lines -ge 350 ] && tail -n 299 /nvram/security_log > /nvram/security_log.$$ && mv /nvram/security_log.$$ /nvram/security_log && sync
fi
# not --get request, call $USERPWD_BIN with orig args
[ -z "$username" ] && exec $USERPWD_BIN $args

#echo "REMOTE_ADDR=" $REMOTE_ADDR ",HTTP_HOST=" $HTTP_HOST > /dev/console

if echo "$REMOTE_ADDR" | grep -q ":"; then
	ipv6=1
	v6a=`ip -6 route get $REMOTE_ADDR`
	set -- `echo ${v6a#*dev }`
	v6inf=$1 
	#echo "v6inf=$v6inf"  > /dev/console

	set -- `ifconfig br0 | grep "Scope:Link"`
	br0v6addr=$3
	ipv6br0=`echo $br0v6addr | sed 's/\/.*$//'`
else
	ipv6=0
fi
#[ "$ipv6" = "1" ] &&  echo "IPv6" > /dev/console || echo "ipv4" > /dev/console

# for get login interface
set -o noglob # avoid globbing (expansion of star[*]).
set -- `grep $REMOTE_ADDR /proc/net/arp`
#set -- `grep : /proc/net/arp | sed -e "s/*/-/" | grep $REMOTE_ADDR`
Rmt_IP=$1
Rmt_MAC=$4
Rmt_Inf=$6
set +o noglob # enable globbing (expansion of star[*]).
#echo "Rmt_IP=" $Rmt_IP " ,Rmt_MAC=" $Rmt_MAC " ,Rmt_Inf=" $Rmt_Inf > /dev/console

# access from lan, call $USERPWD_BIN with orig args
#if [ "$lan0_ip" = "$HTTP_HOST" \
#	-o "$lan0_alias0_ip" = "$HTTP_HOST" \
#	-o "$lan0_alias1_ip" = "$HTTP_HOST" \
#	-o "$lan0_alias2_ip" = "$HTTP_HOST" \
#	-o "$lan0_alias3_ip" = "$HTTP_HOST" \
#	-o "$lan1_ip" = "$HTTP_HOST" \
#	-o "$lan1_alias0_ip" = "$HTTP_HOST" \
#	-o "$lan1_alias1_ip" = "$HTTP_HOST" \
#	-o "$lan1_alias2_ip" = "$HTTP_HOST" \
#	-o "$lan1_alias3_ip" = "$HTTP_HOST" \
#	-o "$lan7_ip" = "$HTTP_HOST" \
#	-o "$lan7_alias0_ip" = "$HTTP_HOST" \
#	-o "$lan7_alias1_ip" = "$HTTP_HOST" \
#	-o "$lan7_alias2_ip" = "$HTTP_HOST" \
#	-o "$lan7_alias3_ip" = "$HTTP_HOST" ]; then
if [ "x$ipv6" == "x0" ]; then
	if [ "x${Rmt_Inf:0:2}" == "xbr" ]; then
		exec $USERPWD_BIN $args
	fi
	#if ifconfig br0 | grep -q "$HTTP_HOST"; then
	#	exec $USERPWD_BIN $args
	#fi
else
	[ "$v6inf" == "br0" ] && exec $USERPWD_BIN $args
	[ "[$ipv6br0]" == "$HTTP_HOST" ] && exec $USERPWD_BIN $args
fi

# access from wan
config_file=/var/run/userpwd_wan.cfg
if [ ! -f $config_file ]; then
	set `fw_printenv ethaddr|cut -d= -f2 |sed -e "s/:/ /g"`
	printf "cht=admin^^^cht%02x%02x%02x\n" 0x$4 0x$5 0x$6 > $config_file
fi
exec $USERPWD_BIN -f $config_file $option $username
