#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/etc/init.d:/etc/bin; export PATH
. /var/run/rc.conf
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

##########################################
echo "Content-type:text/html"
echo ""
#action="get"
if [ "$action" == "get" ]; then

port1=${cht_lanport_large_egress_buf:0:1}
port2=${cht_lanport_large_egress_buf:1:1}
port3=${cht_lanport_large_egress_buf:2:1}
port4=${cht_lanport_large_egress_buf:3:1}

cat <<EOF
{
	"port1":	"$port1",
	"port2":	"$port2",
	"port3":	"$port3",
	"port4":	"$port4"
}
EOF

elif [ "$action" == "set" ]; then

	#echo "action="$action > /dev/console
	#echo "port1="$port1 > /dev/console
	#echo "port2="$port2 > /dev/console
	#echo "port3="$port3 > /dev/console
	#echo "port4="$port4 > /dev/console
	#echo "large_egress_buf="$large_egress_buf > /dev/console

	large_egress_buf=$port1$port2$port3$port4
	metacli -c "set cht_lanport_large_egress_buf $large_egress_buf" >/dev/null 2>/dev/null
	/opt/wwwctrl/lan_egress_setting.sh set >/dev/null 2>/dev/null
fi
