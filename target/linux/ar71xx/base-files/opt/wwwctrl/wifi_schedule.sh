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

CRONTAB_FLASH=/rom/flash/cron/crontabs/root
CRONTAB_RUNTIME=/var/spool/cron/crontabs/root

# arg: start end now
calc_wlan_enable_for_now ()
{
	if [ $start -le $end ]; then	# 0----start++++++++end----24
		if [ $start -le $now -a $now -le $end ]; then
			echo 1
		else
			echo 0
		fi
	else				# 0++++end--------start++++24
		if [ $end -le $now -a $now -le $start ]; then
			echo 0
		else
			echo 1
		fi
	fi
}


if [ "$1" = "set" ]; then
	set -- `date +"%Y %m %d %k %M"`
	local year=$1
	local month=$2
	local day=$3
	local hour=$4
	local minute=$5
	local now start end

	if [ -f $metafile_diff.$CGI_PAGE_ID ]; then
		if [ -f $metafile_page.$CGI_PAGE_ID ]; then
			$WWWCTRL_BIN --kvprint_shell_escaped $metafile_page.$CGI_PAGE_ID > /tmp/sh.$$;. /tmp/sh.$$; rm /tmp/sh.$$
		fi
		$WWWCTRL_BIN --kvprint_shell_escaped $metafile_diff.$CGI_PAGE_ID > /tmp/sh.$$;. /tmp/sh.$$; rm /tmp/sh.$$
	fi

	# put wlan enable/disable to crontab
	wlan_str=""
	if [ "$wlan_schedule" == "1" -a ! -z "$wlan_schedule_shour" -a ! -z "$wlan_schedule_sminute" -a ! -z "$wlan_schedule_ehour" -a ! -z "$wlan_schedule_eminute" ]; then
		if [ "$wlan_schedule_daily" == "1" ]; then
			wlan_str="$wlan_schedule_sminute $wlan_schedule_shour * * *	/etc/init.d/cmd_dispatcher.sh set wlan_enable=1
$wlan_schedule_eminute $wlan_schedule_ehour * * *	/etc/init.d/cmd_dispatcher.sh set wlan_enable=0"

			start=`printf "%02d%02d" $wlan_schedule_shour $wlan_schedule_sminute`
			end=`printf "%02d%02d" $wlan_schedule_ehour $wlan_schedule_eminute`
			now=`printf "%02d%02d" $hour $minute`
			/etc/init.d/cmd_dispatcher.sh set wlan_enable=`calc_wlan_enable_for_now $start $end $now`
		else
			if [ ! -z "$wlan_schedule_syear" -a ! -z "$wlan_schedule_smonth" -a ! -z "$wlan_schedule_sday" -a \
				 ! -z "$wlan_schedule_eyear" -a ! -z "$wlan_schedule_emonth" -a ! -z "$wlan_schedule_eday" ]; then
				wlan_str="$wlan_schedule_sminute $wlan_schedule_shour $wlan_schedule_sday $wlan_schedule_smonth *	/etc/init.d/cmd_dispatcher.sh set wlan_enable=1
$wlan_schedule_eminute $wlan_schedule_ehour $wlan_schedule_eday $wlan_schedule_emonth *	/etc/init.d/cmd_dispatcher.sh set wlan_enable=0"

				start=`printf "%04d%02d%02d%02d%02d" $wlan_schedule_syear $wlan_schedule_smonth $wlan_schedule_sday $wlan_schedule_shour $wlan_schedule_sminute`
				end=`printf "%04d%02d%02d%02d%02d" $wlan_schedule_eyear $wlan_schedule_emonth $wlan_schedule_eday $wlan_schedule_ehour $wlan_schedule_eminute`
				now=`printf "%04d%02d%02d%02d%02d" $year $month $day $hour $minute`
				/etc/init.d/cmd_dispatcher.sh set wlan_enable=`calc_wlan_enable_for_now $start $end $now`
			fi
		fi
	fi

	# put wlanac enable/disable to crontab
	wlanac_str=""
	if [ "$wlanac_schedule" == "1" -a ! -z "$wlanac_schedule_shour" -a ! -z "$wlanac_schedule_sminute" -a ! -z "$wlanac_schedule_ehour" -a ! -z "$wlanac_schedule_eminute" ]; then
		if [ "$wlanac_schedule_daily" == "1" ]; then
			wlanac_str="$wlanac_schedule_sminute $wlanac_schedule_shour * * *	/etc/init.d/cmd_dispatcher.sh set wlanac_enable=1
$wlanac_schedule_eminute $wlanac_schedule_ehour * * *	/etc/init.d/cmd_dispatcher.sh set wlanac_enable=0"

			start=`printf "%02d%02d" $wlanac_schedule_shour $wlanac_schedule_sminute`
			end=`printf "%02d%02d" $wlanac_schedule_ehour $wlanac_schedule_eminute`
			now=`printf "%02d%02d" $hour $minute`
			/etc/init.d/cmd_dispatcher.sh set wlanac_enable=`calc_wlan_enable_for_now $start $end $now`
		else
			if [ ! -z "$wlanac_schedule_syear" -a ! -z "$wlanac_schedule_smonth" -a ! -z "$wlanac_schedule_sday" -a \
				 ! -z "$wlanac_schedule_eyear" -a ! -z "$wlanac_schedule_emonth" -a ! -z "$wlanac_schedule_eday" ]; then
				wlanac_str="$wlanac_schedule_sminute $wlanac_schedule_shour $wlanac_schedule_sday $wlanac_schedule_smonth *	/etc/init.d/cmd_dispatcher.sh set wlanac_enable=1
$wlanac_schedule_eminute $wlanac_schedule_ehour $wlanac_schedule_eday $wlanac_schedule_emonth *	/etc/init.d/cmd_dispatcher.sh set wlanac_enable=0"

				start=`printf "%04d%02d%02d%02d%02d" $wlanac_schedule_syear $wlanac_schedule_smonth $wlanac_schedule_sday $wlanac_schedule_shour $wlanac_schedule_sminute`
				end=`printf "%04d%02d%02d%02d%02d" $wlanac_schedule_eyear $wlanac_schedule_emonth $wlanac_schedule_eday $wlanac_schedule_ehour $wlanac_schedule_eminute`
				now=`printf "%04d%02d%02d%02d%02d" $year $month $day $hour $minute`
				/etc/init.d/cmd_dispatcher.sh set wlanac_enable=`calc_wlan_enable_for_now $start $end $now`
			fi
		fi
	fi

	# create new crontab in tmp
	grep -v '/etc/init.d/cmd_dispatcher.sh set wlan_enable=' $CRONTAB_RUNTIME | \
	grep -v '/etc/init.d/cmd_dispatcher.sh set wlanac_enable=' > /tmp/crontab.tmp.$$
	[ ! -z "$wlan_str" ] && echo "$wlan_str" >> /tmp/crontab.tmp.$$
	[ ! -z "$wlanac_str" ] && echo "$wlanac_str" >> /tmp/crontab.tmp.$$
	cat $CRONTAB_FLASH >> /tmp/crontab.tmp.$$
	sort /tmp/crontab.tmp.$$ | uniq | grep -v '^$' > /var/run/crontab.$$; rm /tmp/crontab.tmp.$$

	# update crontab. crond will reload crontab after modification
	crontab /var/run/crontab.$$; rm /var/run/crontab.$$
fi
