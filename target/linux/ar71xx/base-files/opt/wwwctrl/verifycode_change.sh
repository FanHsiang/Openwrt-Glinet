#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/etc/init.d:/etc/bin; export PATH
. /var/run/rc.conf
if [ "$1" = "set" ]; then
	[ "x$system_http_verifycode" = "x1" ] && metacli -c "set system_http_verifycode 0"
	[ "x$system_http_verifycode" = "x0" ] && metacli -c "set system_http_verifycode 1"
fi
exit 0
