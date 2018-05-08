#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

if [ "$1" = "recovery" ]; then
	sed -i "/^root:/d" /etc/passwd
	sed -i "/^root:/d" /etc/shadow
	echo "root:\$1\$JXnZ3nCz\$6l2rk27y1nCqJbad5uxsY.:0:0:root:/root:/etc/init.d/login.sh" >> /etc/passwd
fi
