#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/etc/init.d:/etc/bin; export PATH
STATUS_FILE="/tmp/download_status.txt"
FW_UPGRADE_STA="/tmp/fw_upgarde_status.txt"
#STATUS_FILE="/dev/null"
DEV_MSG=/dev/console

logmsg() {
	echo "$1" > $DEV_MSG
	echo "$1" >> $STATUS_FILE
	#logger -p6 -t PROV "$1"
}

on_sighup() {
	logmsg "skip signal"
}

invalid_updateimg() {
	updateimg=$1

	case $updateimg in
	0)
		fw_setenv sw_valid0 0
		fw_setenv sw_active0_ok 0
		fw_setenv sw_commit 1	#useful when tryactive 1
	;;
	1)
		fw_setenv sw_valid1 0
		fw_setenv sw_active1_ok 0
		fw_setenv sw_commit 0	#useful when tryactive 0
	;;
	esac
}

commit_updateimg() {
	updateimg=$1

	case $updateimg in
	0)
		fw_setenv sw_valid0 1
		fw_setenv sw_active0_ok 1
		fw_setenv sw_commit 0
		fw_setenv sw_tryactive 2
	;;
	1)
		fw_setenv sw_valid1 1
		fw_setenv sw_active1_ok 1
		fw_setenv sw_commit 1
		fw_setenv sw_tryactive 2
	;;
	esac
}

update_image() {

	trap on_sighup SIGHUP

	if [ ! -d "/opt/wwwctrl/" ]; then
		# simulation on X86 runtime
		return 0
	fi

	cd /

	if [ -f $metafile_diff.$CGI_PAGE_ID ]; then
		$WWWCTRL_BIN --kvprint_shell_escaped $metafile_diff.$CGI_PAGE_ID > /tmp/sh.$$;
		. /tmp/sh.$$; rm /tmp/sh.$$
	fi

	#echo "logmsg="$wwwctrl_upload_localfile > $DEV_MSG
	logmsg $wwwctrl_upload_localfile

	if grep "active=1" /proc/cmdline>/dev/null ; then
		#currentimg=1
		updateimg=0
	else
		#currentimg=0
		updateimg=1
	fi

	#check image valid
	[ ! -d /tmp/mountimg ] && mkdir /tmp/mountimg

	#remove zte header
	#if ! makebin -r $2; then
	#	logmsg "Can't find header $2 "
	#fi

	mount -o loop -r -t squashfs $wwwctrl_upload_localfile /tmp/mountimg
	if [ "$?" != "0" ]; then
		echo "firmware_upgrade_status=1" > $FW_UPGRADE_STA
		logmsg "mount image error"
		rm -r /tmp/mountimg
		rm -f $wwwctrl_upload_localfile
		return 1
	fi

	### load checksum info ###
	if [ ! -f /tmp/mountimg/checksum.log ]; then
		return 1
	fi
	. /tmp/mountimg/checksum.log

	# check md5sum
	Kimage_md5_now=`md5sum /tmp/mountimg/Kimage.lzma 2> /dev/null | cut -d' ' -f1`
	Rimage_md5_now=`md5sum /tmp/mountimg/Rimage.squashfs 2> /dev/null |cut -d' ' -f1`

	umount /dev/loop0 > /dev/null
	umount /dev/loop1 > /dev/null
	umount /tmp/mountimg
	rm -r /tmp/mountimg
	if [ "$Kimage_md5_now" != "$Kimage_md5_org" -o "$Rimage_md5_now" != "$Rimage_md5_org" ]; then
		rm -f $wwwctrl_upload_localfile
		logmsg "md5sum error"
		return 1
	fi

	invalid_updateimg $updateimg

	if [ ! -f /usr/sbin/sw_download.sh ]; then
		#exit when x86
		rm -f $wwwctrl_upload_localfile
		return 0;
	fi

	sh /usr/sbin/sw_download.sh end_download $wwwctrl_upload_localfile $updateimg
	if [ "$?" != "0" ]; then
		logmsg "update error(error format or can't mount)"
		rm -f $wwwctrl_upload_localfile
		return 1;
	fi

	commit_updateimg $updateimg

	# redirect browser to wait_boot page
	HTTP_OUTPUT=$http_direct_output.$CGI_PAGE_ID
	rm $HTTP_OUTPUT
	echo "HTTP/1.1 301 Moved Permanently" >> $HTTP_OUTPUT
	echo "Location: /cgi-bin/wwwctrl.cgi?action=wait_restart" >> $HTTP_OUTPUT

	echo "firmware_upgrade_status=9" > $FW_UPGRADE_STA
	(sleep 5; /sbin/reboot) &
}

############## start shell ############################################################
#firmware_upgrade_status= 0:start, 1:error, 9:finish
echo "firmware_upgrade_status=0" > $FW_UPGRADE_STA
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

if [ "$1" = "upload" -a "$wwwctrl_upload_tag" = "firmware_upload" ]; then
	if [ ! -d "/opt/wwwctrl/" ]; then
		echo "simulation on X86 runtime" > $DEV_MSG
	else
		sync && echo 3 > /proc/sys/vm/drop_caches
		# action on target evb
		update_image || exit 1
	fi
fi
rm -rf $HTTP_OUTPUT
echo "HTTP/1.1 301 Moved Permanently" >> $HTTP_OUTPUT
echo "Location: /cgi-bin/wwwctrl.cgi?action=wait_restart" >> $HTTP_OUTPUT
exit 0
