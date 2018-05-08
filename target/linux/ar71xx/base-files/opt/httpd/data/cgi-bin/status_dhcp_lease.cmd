#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/etc/init.d:/etc/bin; export PATH
#. /var/run/rc.conf
if [ -d "/opt/wwwctrl/" ]; then
	RUNTIME_ROOTDIR="/"
else
	# find thr faked root dir for x86 runtime
	dir=`dirname $0`;dir=`dirname $dir`;dir=`dirname $dir`
	RUNTIME_ROOTDIR=$dir
fi
. $RUNTIME_ROOTDIR/etc/wwwctrl/wwwctrl.cfg
WWWCTRL_BIN=$RUNTIME_ROOTDIR/opt/httpd/data/cgi-bin/wwwctrl.cgi
##########################################
if [ "$REQUEST_METHOD" = "POST" ]; then
	if [ "$CONTENT_LENGTH" -gt 0 ]; then
		read -n $CONTENT_LENGTH POST_DATA <&0
	fi
fi
#echo $POST_DATA > /dev/console
echo $POST_DATA|sed 's/\&/\n/g' > /var/run/postdata.$$
kvtool --kvprint_shell_escaped /var/run/postdata.$$ > /var/run/postdata.shell.$$
#cat /var/run/postdata.shell.$$ > /dev/console
. /var/run/postdata.shell.$$ 2> /dev/null > /dev/null
rm /var/run/postdata.$$ /var/run/postdata.shell.$$

DHCPLEASE_LOG_FILE=/var/run/dhcp/dhcpdv4.leases.br0
DHCP_Leased_clean_file=/tmp/dhcp_clean.txt

# for the first start after reset to default
# the lease file becomes dhcpdv4.leases~, don't know why
# get the correct file having the newest lease
lease_file () {
	t0=`grep starts $DHCPLEASE_LOG_FILE	 2>/dev/null | sort -r | head -n1 | tr -d -c 0-9`
	if [ -z $t0 ]; then t0=0; fi
	t1=`grep starts $DHCPLEASE_LOG_FILE~ 2>/dev/null | sort -r | head -n1 | tr -d -c 0-9`
	if [ -z $t1 ]; then t1=0; fi

	if [ $t1 -gt $t0 ]; then
		echo $DHCPLEASE_LOG_FILE~
	else
		echo $DHCPLEASE_LOG_FILE
	fi
}

##########################################
echo "Content-type:text/html"
echo ""
#action="get"
if [ "$action" == "get" ]; then

	DHCP_Leased_file=$( lease_file )
	#rm -f ${DHCP_Leased_clean_file}.1
	grep -h -E '^lease|ends|hardware|client-hostname|\}' $DHCP_Leased_file \
	| sed ':a;N;$!ba;s/;\n//g' | sed ':a;N;$!ba;s/{\n/{/g' \
	| sed 's/ ethernet//;s/}//;s/{//;s/  \+/ /g' | sed 's/ends ./ends/'\
	| sort -r | uniq -f 6  > ${DHCP_Leased_clean_file}.1

	#echo $DHCP_Leased_file > /dev/console
	#cat ${DHCP_Leased_clean_file}.1 > /dev/console
	rm -f ${DHCP_Leased_clean_file}.2
	if [ -f ${DHCP_Leased_clean_file}.1 ]; then
		while read -r line
		do
			set -- `echo $line`
			echo "$1 $7 $2 $4 $5 $9"  >> ${DHCP_Leased_clean_file}.2
		done < "${DHCP_Leased_clean_file}.1"
		#cat ${DHCP_Leased_clean_file}.2 > /dev/console
		cat ${DHCP_Leased_clean_file}.2 | uniq -w 24  > ${DHCP_Leased_clean_file}
	fi
echo "["
	if [ -f ${DHCP_Leased_clean_file} ]; then
		leased_client=`grep ^lease ${DHCP_Leased_clean_file} | wc -l`
		for i in `seq 1 $leased_client`; do
			set -- `grep -m $i ^lease ${DHCP_Leased_clean_file} | tail -1`
			IpAddress=$3
			Expiry="$4 $5"
			Mac=$2
			HostName=$6
			[ "x$HostName" == "x" ] && HostName="\"\""
			#echo $IpAddress, $Mac, $HostName, $Expiry > /dev/console

cat <<EOF
	{
	"IpAddress":	"$IpAddress",
	"Mac":			"$Mac",
	"HostName":		$HostName,
	"Expiry":		"$Expiry"
	},
EOF

		done
	 fi
echo "]"
fi
