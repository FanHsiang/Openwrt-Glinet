#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/etc/init.d:/etc/bin; export PATH
RC_CONF=/var/run/rc.conf

############## start shell ############################################################

if [ -d "/opt/wwwctrl/" ]; then
	RUNTIME_ROOTDIR="/"
else
	# find thr faked root dir for x86 runtime
	dir=`dirname $0`;dir=`dirname $dir`;dir=`dirname $dir`
	RUNTIME_ROOTDIR=$dir
fi

. $RUNTIME_ROOTDIR/etc/wwwctrl/wwwctrl.cfg
RC_CONF=/var/run/rc.conf

WWWCTRL_BIN=$RUNTIME_ROOTDIR/opt/httpd/data/cgi-bin/wwwctrl.cgi
HTTP_OUTPUT=$http_direct_output.$CGI_PAGE_ID

BRIDGE_MENU=/opt/httpd/data/pages/panel3_bridge.html
ROUTER_MENU=/opt/httpd/data/pages/panel3_router.html
MENU_HTML=/opt/httpd/data/pages/panel3.html

BRIDGE_USER_MENU=/opt/httpd/data/pages/panel3_user_bridge.html
ROUTER_USER_MENU=/opt/httpd/data/pages/panel3_user_router.html
MENU_USER_HTML=/opt/httpd/data/pages/panel3_user.html

LAN_SETTING_BRIDGE=/opt/httpd/data/pages/network_lan_settings_bridge.html
LAN_SETTING_ROUTER=/opt/httpd/data/pages/network_lan_settings_router.html
LAN_SETTING_HTML=/opt/httpd/data/pages/network_lan_settings.html
LAN_SETTING_BRIDGE_NEW=/opt/httpd/data/pages/network_lan_settings_bridge.html
LAN_SETTING_ROUTER_NEW=/opt/httpd/data/pages/network_lan_settings_router_new.html
LAN_SETTING_HTML_NEW=/opt/httpd/data/pages/network_lan_settings_new.html

FACTORY_DEFAULT_BRIDGE=/opt/httpd/data/pages/utilities_restore_factory_default_bridge.html
FACTORY_DEFAULT_ROUTER=/opt/httpd/data/pages/utilities_restore_factory_default_router.html
FACTORY_DEFAULT_HTML=/opt/httpd/data/pages/utilities_restore_factory_default.html

. $RC_CONF

if [ -f $metafile ]; then
	$WWWCTRL_BIN --kvprint_shell_escaped $metafile > /tmp/sh.$$;
	. /tmp/sh.$$; rm /tmp/sh.$$
else
	exit 1
fi

#if router mode
if [ "$ont_mode" = "1" ]; then
	cp -f $ROUTER_MENU $MENU_HTML
	cp -f $LAN_SETTING_ROUTER $LAN_SETTING_HTML
	cp -f $LAN_SETTING_ROUTER_NEW $LAN_SETTING_HTML_NEW
	cp -f $FACTORY_DEFAULT_ROUTER $FACTORY_DEFAULT_HTML
	cp -f $ROUTER_USER_MENU $MENU_USER_HTML
else
	cp -f $BRIDGE_MENU $MENU_HTML
	cp -f $LAN_SETTING_BRIDGE $LAN_SETTING_HTML
	cp -f $LAN_SETTING_BRIDGE_NEW $LAN_SETTING_HTML_NEW
	cp -f $FACTORY_DEFAULT_BRIDGE $FACTORY_DEFAULT_HTML
	cp -f $BRIDGE_USER_MENU $MENU_USER_HTML
fi
sync

if [ -f $metafile_diff.$CGI_PAGE_ID ]; then
	$WWWCTRL_BIN --kvprint_shell_escaped $metafile_diff.$CGI_PAGE_ID > /tmp/sh.$$;
	. /tmp/sh.$$; rm /tmp/sh.$$

	#rm -rf $HTTP_OUTPUT
	#echo "HTTP/1.1 301 Moved Permanently" >> $HTTP_OUTPUT
	#echo "Location: /cgi-bin/wwwctrl.cgi?action=wait_restart" >> $HTTP_OUTPUT
	sleep 5
	if [ "$ont_mode" = "1" ]; then
		`sh /etc/init.d/ont_mode.sh router`
	else
		`sh /etc/init.d/ont_mode.sh bridge`
	fi
fi

exit 0

