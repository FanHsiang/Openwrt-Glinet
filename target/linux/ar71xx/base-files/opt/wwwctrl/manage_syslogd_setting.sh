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
SYSLOGD_OUTPUT_FILE_0=$RUNTIME_ROOTDIR/var/log/messages.0
SYSLOGD_OUTPUT_FILE=$RUNTIME_ROOTDIR/var/log/messages
SYSLOGD_OUTPUT_FILE_LOG=$RUNTIME_ROOTDIR/var/log/messages_log
SYSLOGD_BAT_FILE=$RUNTIME_ROOTDIR/var/log/messages_bat
SYSLOGD_PRINT_FILE=$RUNTIME_ROOTDIR/opt/httpd/data/pages/log.xml

if [ "$1" = "get" ]; then

    chtmac=`ifconfig eth0 | head -1 |sed -e 's/.*addr //' -e 's/://g' -e 's/^....../cht/' |awk {'print tolower($_)'}`
    echo "kv_chtmac=$chtmac"

	if [ -f $metafile_diff.$CGI_PAGE_ID ]; then
		$WWWCTRL_BIN --kvprint_shell_escaped $metafile_diff.$CGI_PAGE_ID > /tmp/sh.$$;
		. /tmp/sh.$$; rm /tmp/sh.$$
	fi
	cat $SYSLOGD_OUTPUT_FILE_0 > $SYSLOGD_OUTPUT_FILE_LOG
	cat $SYSLOGD_OUTPUT_FILE >> $SYSLOGD_OUTPUT_FILE_LOG
	[ -z "$kv_syslog_priority" ] && kv_syslog_priority="all"
	[ -z "$kv_syslog_lines" ] && kv_syslog_lines=50

	echo "kv_syslog_lines=$kv_syslog_lines
		kv_syslog_priority=$kv_syslog_priority"
	if [ "$kv_syslog_priority" = "all" ]; then
		sed -n '1{h;T;};G;h;$p;' $SYSLOGD_OUTPUT_FILE_LOG | sed -e "s/<//g" -e "s/>//g" | head -n $kv_syslog_lines > $SYSLOGD_BAT_FILE
	else
		sed -n '1{h;T;};G;h;$p;' $SYSLOGD_OUTPUT_FILE_LOG | grep "\.$kv_syslog_priority " |sed -e "s/<//g" -e "s/>//g" | head -n $kv_syslog_lines > $SYSLOGD_BAT_FILE
	fi

	echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>" > $SYSLOGD_PRINT_FILE
        echo "<root>" >> $SYSLOGD_PRINT_FILE
        cat $SYSLOGD_BAT_FILE | awk '{print "<items>\n<time>"$1,$2,$3"</time>\n<module>"$4"</module>\n<level>"$5"</level>\n<msg>"$6,$7,$8,$9,$10,$11,$12,$13,$14,$15"</msg>\n</items>"}' >> $SYSLOGD_PRINT_FILE
        echo "</root>" >> $SYSLOGD_PRINT_FILE
elif [ "$1" = "clear" ]; then
	cat /dev/null > $SYSLOGD_OUTPUT_FILE
	rm -f $SYSLOGD_OUTPUT_FILE.* $SYSLOGD_BAT_FILE $SYSLOGD_OUTPUT_FILE_LOG
fi
exit 0
