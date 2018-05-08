#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/etc/init.d:/etc/bin; export PATH
. /var/run/rc.conf
if [ "$1" = "get" ]; then
	[ -f "/root/version" ] && . /root/version 2> /dev/null > /dev/null
	echo "version=$version"
	VerifyCode=0
	[ "x$system_http_verifycode" != "x" ] && VerifyCode=$system_http_verifycode
	echo "VerifyCode=$VerifyCode"
fi
exit 0
