#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/etc/init.d:/etc/bin; export PATH

. /var/run/rc.conf

SCRIPT=$0

enlarge_lan_egress_threshold () {
	# set egress threshold for Netflix
	#diag flowctrl set egress port 0-3 threshold 2900
cmd="
flowctrl set egress system drop-threshold high-on threshold 4600
flowctrl set egress system drop-threshold high-off threshold 4500
flowctrl set egress system drop-threshold low-on threshold 3100
flowctrl set egress system drop-threshold low-off threshold 3000
flowctrl set egress system flowctrl-threshold high-on threshold 4600
flowctrl set egress system flowctrl-threshold high-off threshold 4500
flowctrl set egress system flowctrl-threshold low-on threshold 3100
flowctrl set egress system flowctrl-threshold low-off threshold 3000
exit"
	echo "$cmd" | diag > /dev/null
}

set_lan_egress_threshold () {
diag flowctrl set egress port $1 threshold 2900
}

reset_lan_egress_threshold () {
diag flowctrl set egress port $1 threshold 1300
}

set_normal_lan_egress_threshold () {
	# set normal egress threshold
	#diag flowctrl set egress port 0-3 threshold 1300
cmd="
flowctrl set egress port 0-3 threshold 1300
flowctrl set egress system drop-threshold high-on threshold 4495
flowctrl set egress system drop-threshold high-off threshold 4062
flowctrl set egress system drop-threshold low-on threshold 2764
flowctrl set egress system drop-threshold low-off threshold 2487
flowctrl set egress system flowctrl-threshold high-on threshold 4495
flowctrl set egress system flowctrl-threshold high-off threshold 4062
flowctrl set egress system flowctrl-threshold low-on threshold 2764
flowctrl set egress system flowctrl-threshold low-off threshold 2487
exit"
	echo "$cmd" | diag > /dev/null
}

show_lan_egress_threshold () {
cmd="
flowctrl get egress port 0-3 threshold
flowctrl get egress system drop-threshold high-on threshold
flowctrl get egress system drop-threshold high-off threshold
flowctrl get egress system drop-threshold low-on threshold
flowctrl get egress system drop-threshold low-off threshold
flowctrl get egress system flowctrl-threshold high-on threshold
flowctrl get egress system flowctrl-threshold high-off threshold
flowctrl get egress system flowctrl-threshold low-on threshold
flowctrl get egress system flowctrl-threshold low-off threshold
exit"
	echo "$cmd" | diag
}

usage () {
	echo "$0 [set|reset|show]"
	exit 1
}

# main ##########################################################

[ -z "$1" ] && usage;
err=0
action=$1
if [ "$1" == "set" ]; then
	#echo $cht_lanport_large_egress_buf > /dev/console
	[ "${cht_lanport_large_egress_buf:0:1}" == "1" ] && set_lan_egress_threshold 0 || reset_lan_egress_threshold 0
	[ "${cht_lanport_large_egress_buf:1:1}" == "1" ] && set_lan_egress_threshold 1 || reset_lan_egress_threshold 1
	[ "${cht_lanport_large_egress_buf:2:1}" == "1" ] && set_lan_egress_threshold 2 || reset_lan_egress_threshold 2
	[ "${cht_lanport_large_egress_buf:3:1}" == "1" ] && set_lan_egress_threshold 3 || reset_lan_egress_threshold 3
    enlarge_lan_egress_threshold
elif [ "$1" == "reset" ]; then
	set_normal_lan_egress_threshold
elif [ "$1" == "show" ]; then
	show_lan_egress_threshold
else
	usage
fi

if [ $err = "0" ] ; then
	echo $SCRIPT $action ok
else
	echo $SCRIPT $action error
fi

exit $err
