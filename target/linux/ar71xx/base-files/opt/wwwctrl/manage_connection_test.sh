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
#PING_OUTPUT_FILE=/tmp/manage_connection_ping.output.$CGI_PAGE_ID
PING_OUTPUT_FILE=/tmp/manage_connection_ping.output
#TRACEROUTE_OUTPUT_FILE=/tmp/manage_connection_traceroute.output.$CGI_PAGE_ID
TRACEROUTE_OUTPUT_FILE=/tmp/manage_connection_traceroute.output
PING_FLAG=/tmp/ping.flag

print_kv_from_files () {
	local key; key=$1; shift
	if [ ! -z "$1" ]; then
		cat $* | awk '{ printf "'$key'%d=%s\n", FNR, $0 }'
	fi
}

if [ "$1" = "get" ]; then
	if [ -f $PING_OUTPUT_FILE ]; then
		#while [ ! -f /tmp/ping.flag ]
		#do
		#done
		[ -f $PING_FLAG ] 2> /dev/null && . $PING_FLAG && echo "kv_ping_v6opt=$ping_ipv6"
		print_kv_from_files "ping_result" $PING_OUTPUT_FILE
		ps | grep -v grep | grep -q ping ; finish=$?
		if [ "$finish" == "1" ] ; then
			sleep 2
			rm $PING_OUTPUT_FILE
			#rm /tmp/ping.flag
			sync
			echo "kv_ping_runing=0"
		else
			echo "kv_ping_runing=1"
		fi
	fi
	if [ -f $TRACEROUTE_OUTPUT_FILE ]; then
		#while [ ! -f /tmp/traceroute.flag ]
		#do
		#	sleep 2
		#done
		print_kv_from_files "traceroute_result" $TRACEROUTE_OUTPUT_FILE
		ps | grep -v grep | grep -q traceroute ; finish=$?
		if [ "$finish" == "1" ] ; then
			rm $TRACEROUTE_OUTPUT_FILE
			#rm /tmp/traceroute.flag
			sync
			echo "kv_tracert_runing=0"
		else
			echo "kv_tracert_runing=1"
		fi
	fi

elif [ "$1" = "ping" ]; then
	if [ -f $metafile_diff.$CGI_PAGE_ID ]; then
		$WWWCTRL_BIN --kvprint_shell_escaped $metafile_diff.$CGI_PAGE_ID > /tmp/sh.$$; . /tmp/sh.$$; rm /tmp/sh.$$
		#echo "ipv6=" $ping_ipv6 > /dev/console
		if [ ! -z "$ping_test_host" ]; then
			ping_option="-4 -c 4"
			if [ "x$ping_ipv6" = "x1" ]; then
				ping_option="-6 -c 4"
				echo "ping_ipv6=1" > $PING_FLAG
			else
				echo "ping_ipv6=0" > $PING_FLAG
			fi
			ping $ping_option $ping_test_host &> $PING_OUTPUT_FILE &
			wait %1
			#echo "" > /tmp/ping.flag
		fi
	fi
elif [ "$1" = "traceroute" ]; then
	if [ -f $metafile_diff.$CGI_PAGE_ID ]; then
		$WWWCTRL_BIN --kvprint_shell_escaped $metafile_diff.$CGI_PAGE_ID > /tmp/sh.$$; . /tmp/sh.$$; rm /tmp/sh.$$

		if [ ! -z "$traceroute_test_host" ]; then
			# UDP traceroute
			#traceroute -w 1 $traceroute_test_host &> $TRACEROUTE_OUTPUT_FILE
			# ICMP traceroute
			traceroute -I -w 1 $traceroute_test_host &> $TRACEROUTE_OUTPUT_FILE
			wait
			#echo "" > /tmp/traceroute.flag
		fi
	fi
fi

exit 0
