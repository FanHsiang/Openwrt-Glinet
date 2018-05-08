#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/etc/init.d:/etc/bin; export PATH
if [ -d "/opt/wwwctrl/" ]; then
        RUNTIME_ROOTDIR="/"
else
        # find thr faked root dir for x86 runtime
        dir=`dirname $0`;dir=`dirname $dir`;dir=`dirname $dir`
        RUNTIME_ROOTDIR=$dir
fi

if [ "$1" = "reset" ]; then
	echo "--- Reset All Wan ---"
	# Reset all l2_proto_vlan parameter from metafile.resetl2p
	if [ -f /etc/wwwctrl/metafile.resetl2p ]; then
		/etc/init.d/cmd_dispatcher.sh diff /etc/wwwctrl/metafile.resetl2p
	fi
	# Reset all wan parameter from metafile.resetwan
	if [ -f /etc/wwwctrl/metafile.resetwan ]; then
		/etc/init.d/cmd_dispatcher.sh diff /etc/wwwctrl/metafile.resetwan
	fi
fi
exit 0