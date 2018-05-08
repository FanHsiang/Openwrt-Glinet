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


print_kv_from_files () {
	local key; key=$1; shift	
		
	if [ ! -z "$1" ]; then
		cat $* | awk '{ printf "'$key'%d=%s\n", FNR, $0 }'
	fi
}




if [ "$1" = "get" ]; then

	#parse cfm Mep List data
	/usr/bin/cfmgui.cgi

	#output cfm to CGI
	#filelist=$CFM_OUTPUT_FILE
	#print_kv_from_files "cfm_content_line" $CFM_OUTPUT_FILE
	

elif [ "$1" = "set" ]; then
	
	if [ -f $metafile_diff.$CGI_PAGE_ID ]; then
		$WWWCTRL_BIN --kvprint_shell_escaped $metafile_diff.$CGI_PAGE_ID > /tmp/sh.$$; . /tmp/sh.$$; rm /tmp/sh.$$
		[ ! -z "$cfm_clear_ccm" ] && /usr/bin/omcicli -c "cfm counter 3 all clear" > /tmp/cfm_CcmClear.txt && echo "ccmClean=yes"
		[ ! -z "$cfm_clear_lbm" ] && /usr/bin/omcicli -c "cfm counter 3 all clear" > /tmp/cfm_LbmClear.txt && echo "lbmClean=yes"
		[ ! -z "$cfm_clear_ltm" ] && /usr/bin/omcicli -c "cfm show ltr 3 all clear" > /tmp/cfm_LtmClear.txt && echo "ltmClean=yes"
		if [ ! -z "$enable_ccm" ]; then
			 echo "enable CCM" > /tmp/cfm_enableCCM.txt
			 /usr/bin/cfmgui.cgi ctrl_ccm $selected_mep "1"
		fi
		
		if [ ! -z "$disable_ccm" ]; then
			echo "disable CCM" > /tmp/cfm_disableCCM.txt
			/usr/bin/cfmgui.cgi ctrl_ccm $selected_mep "0"
		fi
		
		if [ ! -z "$mep_send_lbm" ];then
			echo $mep_send_lbm $lbm_send_count $mep_send_mac> /tmp/mep_send_LBM.txt
			echo "/usr/bin/cfmgui.cgi send_lbm $mep_send_lbm $mep_send_mac $lbm_send_count" > /tmp/mep_send_LBM.txt
			/usr/bin/cfmgui.cgi send_lbm $mep_send_lbm $mep_send_mac $lbm_send_count
		fi
		if [ ! -z "$mep_send_ltm" ];then
			echo $mep_send_ltm $mep_send_mac > /tmp/mep_send_LTM.txt
			echo "/usr/bin/cfmgui.cgi send_ltm $mep_send_ltm $mep_send_mac" > /tmp/mep_send_LTM.txt
			/usr/bin/cfmgui.cgi send_ltm $mep_send_ltm $mep_send_mac
		fi
	fi
	
fi
	

	

exit 0
