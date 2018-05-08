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
userpwd_bin=/usr/sbin/htpasswd

if [ -f $metafile ]; then
	$WWWCTRL_BIN --kvprint_shell_escaped $metafile > /tmp/sh.$$; 
	. /tmp/sh.$$; rm /tmp/sh.$$
else
	exit 1
fi

if [ "$1" = "get" ]; then
    echo "kv_time_year=`date | awk '{print $6}'`"
    echo "kv_time_month=`date | awk '{print $2}'`"
    echo "kv_time_day=`date | awk '{print $3}'`"
    echo "kv_time_hour=`date | awk '{print $4}'|awk -F: '{print $1}'`"
    echo "kv_time_minute=`date | awk '{print $4}'|awk -F: '{print $2}'`"
    echo "kv_time_second=`date | awk '{print $4}'|awk -F: '{print $3}'`"
elif [ "$1" = "set" ]; then
    if [ -f $metafile_diff.$CGI_PAGE_ID ]; then
	if [ -f $metafile_page.$CGI_PAGE_ID ]; then
            $WWWCTRL_BIN --kvprint_shell_escaped $metafile_page.$CGI_PAGE_ID > /tmp/sh.$$;. /tmp/sh.$$; rm /tmp/sh.$$
	fi
        $WWWCTRL_BIN --kvprint_shell_escaped $metafile_diff.$CGI_PAGE_ID > /tmp/sh.$$;. /tmp/sh.$$; rm /tmp/sh.$$		
    else
	exit 1;
    fi

    if [ "$kv_name_current" = "admin" ]; then
	#check old password
        $userpwd_bin --file $userpwd_cfg --check "admin" "$kv_org_password"
	if [ $? = 0 ]; then
	    #update new password
	    $userpwd_bin --file $userpwd_cfg --modify "admin" "$kv_new_password" "admin"
	else
	    #error password
	    [ -f /tmp/error.log ] && rm /tmp/error.log
	    $WWWCTRL_BIN --urlunescape "password_check=false" >  /tmp/error.log;. /tmp/error.log
	fi
    else
	#level is normal user
	#check old password
	$userpwd_bin --file $userpwd_cfg --check "user" "$kv_org_password"
	if [ $? = 0 ]; then
    	    #kill kv_user_name_org
	    $userpwd_bin --file $userpwd_cfg --del "$kv_user_name_org"
	    #add:kv_name_current kv_new_password level
	    $userpwd_bin --file $userpwd_cfg --add "$kv_name_current" "$kv_new_password" "user"
	else
	    #error password
	    [ -f /tmp/error.log ] && rm /tmp/error.log
			$WWWCTRL_BIN --urlunescape "password_check=false" >  /tmp/error.log;. /tmp/error.log
	fi
    fi
fi
exit 0
