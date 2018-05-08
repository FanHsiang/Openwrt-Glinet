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

if [ "$1" = "set" ]; then
	if [ -f $metafile_diff.$CGI_PAGE_ID ]; then
		if [ -f $metafile_page.$CGI_PAGE_ID ]; then
			$WWWCTRL_BIN --kvprint_shell_escaped $metafile_page.$CGI_PAGE_ID > /tmp/sh.$$;. /tmp/sh.$$; rm /tmp/sh.$$
		fi
		$WWWCTRL_BIN --kvprint_shell_escaped $metafile_diff.$CGI_PAGE_ID > /tmp/sh.$$;. /tmp/sh.$$; rm /tmp/sh.$$
	fi

	if [ "$system_cnt_leds_ctrl" = "1" ]; then
		# turn on CNT LEDS
		:
	else
		# turn off CNT LEDS
		:
	fi
	cur_admin_passwd=`cat $RUNTIME_ROOTDIR/etc/wwwctrl/userpwd.cfg | grep cht= | awk -F^ '{print $4}'`
	cur_user_passwd=`cat $RUNTIME_ROOTDIR/etc/wwwctrl/userpwd.cfg | grep user= | awk -F^ '{print $4}'`

#	if [ "$sess_level" = "admin" ]; then
		if [ $kv_admin_newpwd != "" ]; then
			#if [ $kv_admin_curpwd = $cur_admin_passwd ]; then
				#sed -i "1 s/${cur_admin_passwd}$/${kv_admin_newpwd}/g" $RUNTIME_ROOTDIR/etc/wwwctrl/userpwd.cfg
				sed -i "s/admin\^\^\^${cur_admin_passwd}/admin\^\^\^${kv_admin_newpwd}/" /etc/wwwctrl/userpwd.cfg
				echo -e "${kv_admin_newpwd}\n${kv_admin_newpwd}" | passwd cht
			if [ -f "/nvram/security_log" ]; then
				echo `date +"%Y %b %d %T"`" User \"cht\" password changed from $kv_remote_ip_k" >> /nvram/security_log
				lines=`wc -l /nvram/security_log | cut -d ' ' -f 1`
				[ $lines -ge 350 ] && tail -n 300 /nvram/security_log > /nvram/security_log.$$ && mv /nvram/security_log.$$ /nvram/security_log && sync
			fi
			#else
			#	[ -f /tmp/admin_error.log ] && rm /tmp/admin_error.log
			#	$WWWCTRL_BIN --urlunescape "password_admin_check=false" >  /tmp/admin_error.log;. /tmp/admin_error.log
			#fi
		fi
#	fi

	if [ $kv_user_newpwd != "" ]; then
		#if [ $kv_user_curpwd = $cur_user_passwd ]; then
			#sed -i "2 s/${cur_user_passwd}$/${kv_user_newpwd}/g" $RUNTIME_ROOTDIR/etc/wwwctrl/userpwd.cfg
			sed -i "s/user\^\^\^${cur_user_passwd}/user\^\^\^${kv_user_newpwd}/" /etc/wwwctrl/userpwd.cfg
			echo -e "${kv_user_newpwd}\n${kv_user_newpwd}" | passwd user
			if [ -f "/nvram/security_log" ]; then
				echo `date +"%Y %b %d %T"`" User \"user\" password changed from $kv_remote_ip_k" >> /nvram/security_log
				lines=`wc -l /nvram/security_log | cut -d ' ' -f 1`
				[ $lines -ge 350 ] && tail -n 300 /nvram/security_log > /nvram/security_log.$$ && mv /nvram/security_log.$$ /nvram/security_log && sync
			fi
		#else
		#	[ -f /tmp/user_error.log ] && rm /tmp/user_error.log
		#	$WWWCTRL_BIN --urlunescape "password_user_check=false" >  /tmp/user_error.log;. /tmp/user_error.log
		#fi
	fi

	if [ $kv_tel_newpwd != "" ] && [ $kv_tel_renewpwd != "" ] && [ $kv_tel_newpwd == $kv_tel_renewpwd ]; then
		echo -ne "$kv_tel_newpwd\n$kv_tel_newpwd" | passwd
	fi

	# handled by ntp.sh
	#export TZ=$datetime_timezone
	#echo $datetime_timezone > /etc/TZ

	# get current time
	eval `date +"%Y-%m-%d %T" | sed "s/\(.*\)-\(.*\)-\(.*\) \(.*\):\(.*\):\(.*\)/now_y=\1\; now_M=\2\; now_d=\3\; now_h=\4\; now_m=\5\; now_s=\6/"`

	year=$kv_time_year
	if [ -z $year ]; then year=$now_y; fi
	month=$kv_time_month
	if [ -z $month ]; then month=$now_M; fi
	day=$kv_time_day
	if [ -z $day ]; then day=$now_d; fi
	hour=$kv_time_hour
	if [ -z $hour ]; then hour=$now_h; fi
	minute=$kv_time_minute
	if [ -z $minute ]; then minute=$now_m; fi
	second=$kv_time_second
	if [ -z $second ]; then second=$now_s; fi

	date "$year.$month.$day-$hour:$minute:$second"
	date +"%Y-%m-%d %T" > /etc/ntp.date
	#/etc/init.d/ntp.sh config
	# need add DST later
	sync
elif [ "$1" = "get" ]; then
	if [ -f /tmp/admin_error.log ]; then
		echo "password_admin_check=false"; rm /tmp/admin_error.log
	fi

	if [ -f /tmp/user_error.log ]; then
		echo "password_user_check=false"; rm /tmp/user_error.log
	fi

	if [ -f /tmp/tel_error.log ]; then
		echo "password_tel_check=false"; rm /tmp/tel_error.log
	fi

	echo "kv_time_year=`date +"%Y-%m-%d %T"|awk '{print $1}'|awk -F- '{print $1}'`"
	echo "kv_time_month=`date +"%Y-%m-%d %T"|awk '{print $1}'|awk -F- '{print $2}'`"
	echo "kv_time_day=`date +"%Y-%m-%d %T"|awk '{print $1}'|awk -F- '{print $3}'`"
	echo "kv_time_hour=`date +"%Y-%m-%d %T"|awk '{print $2}'|awk -F: '{print $1}'`"
	echo "kv_time_minute=`date +"%Y-%m-%d %T"|awk '{print $2}'|awk -F: '{print $2}'`"
	echo "kv_time_second=`date +"%Y-%m-%d %T"|awk '{print $2}'|awk -F: '{print $3}'`"
	#maybe add daylight params
	echo "kv_remote_ip=$REMOTE_ADDR"
elif [ "$1" = "remoteip" ]; then
	echo "kv_remote_ip=$REMOTE_ADDR"
fi
