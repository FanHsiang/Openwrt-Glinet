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
HTTP_OUTPUT=$http_direct_output.$CGI_PAGE_ID

if [ -f $metafile ]; then
	$WWWCTRL_BIN --kvprint_shell_escaped $metafile > /tmp/sh.$$; 
	. /tmp/sh.$$; rm /tmp/sh.$$
else
	exit 1
fi

if [ -f $metafile_diff.$CGI_PAGE_ID ]; then
	$WWWCTRL_BIN --kvprint_shell_escaped $metafile_diff.$CGI_PAGE_ID > /tmp/sh.$$; 
	. /tmp/sh.$$; rm /tmp/sh.$$
fi
											
echo "systemlog_priority=$systemlog_priority
		systemlog_category=$systemlog_category"

if [ "$1" = "get" ]; then
	cat /var/log/messages |awk -v cate="$systemlog_category" -v pri="$systemlog_priority" '{if(NF>5&&$6!="*****"){split($5, priority, "."); split($6, category, "["); if( (cate=="all" || cate=="" || cate==category[1]) && (pri=="all" || pri=="" || pri==priority[2])) {out="";for(i=7;i<=NF;i++){out=out" "$i};printf "syslog_%d=time=%s %s %s;pri=%s;cate=%s;info=%s\n", FNR,$1,$2,$3,priority[2],category[1],out}}}'

elif [ "$1" = "save" ]; then
	cat /var/log/messages |awk -v cate="$systemlog_category" -v pri="$systemlog_priority" '{if(NF>5&&$6!="*****"){split($5, text, "."); if( (cate=="all" || cate=="" || cate==text[1]) && (pri=="all" || pri=="" || pri==text[2])) {print $0}}}' >> /tmp/syslog_output.$$

	set `wc -c  /tmp/syslog_output.$$`; len=$1

	echo "Content-Length: $len"                              > $HTTP_OUTPUT
	echo "Connection: close"                                >> $HTTP_OUTPUT
	echo "Content-Type: text/plain; name=syslog.dat"             >> $HTTP_OUTPUT
	echo "Content-Disposition: attachment; filename=syslog.dat"  >> $HTTP_OUTPUT
	echo ""                                                 >> $HTTP_OUTPUT
	cat /tmp/syslog_output.$$ >> $HTTP_OUTPUT
	rm /tmp/syslog_output.$$
fi
exit 0
