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

RC_CONF_STAGING=/var/run/rc.conf.staging
# include the enviro's
. $RC_CONF_STAGING

set_mcast_pass () {
	#set TLS mode
	if [ "$tls_mode" = "1" ]; then
		omci -c "env classf_ds_unmatch 2"
		omci -c "bat ou classf"
	fi
	if [ "$tls_mode" = "0" ]; then
		omci -c "env classf_ds_unmatch 0"
		omci -c "bat ou classf"
	fi
}

set_pbit_symmetric () {
	#set tag_pbit_workaround
	if [ "$pbit_symmetric" = "0" ]; then
		omci -c "env tag_pbit_workaround 1"
		omci -c "bat ou tagging"
		omci -c "bat ou classf"
	fi
	if [ "$pbit_symmetric" = "1" ]; then
		omci -c "env tag_pbit_workaround 0"
		omci -c "bat ou tagging"
		omci -c "bat ou classf"
	fi
}

if [ "$1" = "get" ]; then

	echo "tls_mode=${tls_mode}"
	echo "pbit_symmetric=${pbit_symmetric}"

elif [ "$1" = "set" ]; then

	if [ -f $metafile_diff.$CGI_PAGE_ID ]; then
		$WWWCTRL_BIN --kvprint_shell_escaped $metafile_diff.$CGI_PAGE_ID > /tmp/sh.$$; . /tmp/sh.$$
		set_mcast_pass
		set_pbit_symmetric
	fi

elif [ "$1" = "boot" ]; then

	set_mcast_pass
	set_pbit_symmetric

fi
exit 0
