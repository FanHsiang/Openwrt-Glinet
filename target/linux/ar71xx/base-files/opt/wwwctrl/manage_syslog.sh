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
OMCICLI_BIN="/usr/bin/omcicli"
SYSLOGD_OUTPUT_FILE=$RUNTIME_ROOTDIR/var/log/messages

print_kv_from_files () {
	local key; key=$1; shift	
	if [ ! -z "$1" ]; then
		cat $* | awk '{ printf "'$key'%d=%s\n", FNR, $0 }'
	fi
}

if [ "$1" = "get" ]; then
	filelist=$SYSLOGD_OUTPUT_FILE
	for i in 0 1 2 3 4 5 6 7 8 9; do
		[ -f $SYSLOGD_OUTPUT_FILE.$i ] && filelist="$SYSLOGD_OUTPUT_FILE.$i $filelist"
	done
	print_kv_from_files "syslogd_content_line" $filelist

elif [ "$1" = "set" ]; then
	if [ -f $metafile ]; then
		$WWWCTRL_BIN --kvprint_shell_escaped $metafile > /tmp/sh.$$; . /tmp/sh.$$; rm /tmp/sh.$$
	
		# enable write through syslog in gpon_monitor
		if [ -f $OMCICLI_BIN -a ! -z "$kv_syslogd_enable" ]; then
			if [ "$kv_syslogd_enable" = "1" ]; then
				$OMCICLI_BIN -c "env debug_log_type 5";
			else
				$OMCICLI_BIN -c "env debug_log_type 1";
			fi
		fi

		/etc/init.d/syslogd.sh stop
		/etc/init.d/syslogd.sh start
	fi

elif [ "$1" = "clearlog" ]; then
	rm $SYSLOGD_OUTPUT_FILE $SYSLOGD_OUTPUT_FILE.*

elif [ "$1" = "download" ]; then
	[ ! -f $RUNTIME_ROOTDIR/etc/wwwctrl/wwwctrl.cfg ] && exit 1
	. $RUNTIME_ROOTDIR/etc/wwwctrl/wwwctrl.cfg

	HTTP_OUTPUT=$http_direct_output.$CGI_PAGE_ID

	if [ -f $SYSLOGD_OUTPUT_FILE ]; then
		set `wc -c  $SYSLOGD_OUTPUT_FILE`
		len=$1
		name=`basename $SYSLOGD_OUTPUT_FILE`

		echo "Content-Length: $len" 				 > $HTTP_OUTPUT
		echo "Connection: close"				>> $HTTP_OUTPUT	
		echo "Content-Type: text/plain; name=$name"		>> $HTTP_OUTPUT
		echo "Content-Disposition: attachment; filename=$name"	>> $HTTP_OUTPUT
		echo ""							>> $HTTP_OUTPUT
	        cat $SYSLOGD_OUTPUT_FILE 				>> $HTTP_OUTPUT
	fi
fi

exit 0
