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


	local SOURCE="LAN"
[ ! -z "$HTTP_COOKIE" ] && eval "$HTTP_COOKIE"

[ "$sessuser" = "chtwan" ] && SOURCE="WAN"

log_msg() {
	local msg="$1"
	if [ -f "/nvram/security_log" ]; then
		echo `date +"%Y %b %d %T"`" User \"$sessuser\" from $SOURCE ($kv_remote_ip_k) $msg" >> /nvram/security_log
		lines=`wc -l /nvram/security_log | cut -d ' ' -f 1`
	        [ $lines -ge 350 ] && tail -n 300 /nvram/security_log > /nvram/security_log.$$ && mv /nvram/security_log.$$ /nvram/security_log && sync
	fi
}

#. /etc/wwwctrl/wwwctrl.cfg

if [ -f $metafile_diff.$CGI_PAGE_ID ]; then
	kvtool --kvprint_shell_escaped $metafile_diff.$CGI_PAGE_ID > /tmp/sh.$$
	. /tmp/sh.$$
	rm /tmp/sh.$$
fi

if [ "$fw_remotemng_accept_any" = "1" ]; then
	log_msg "set MCL disabled"
elif [ "$fw_remotemng_accept_any" = "0" ]; then
	log_msg "set MCL enabled"
fi

rule_numbers=`grep ^fw_remotemng_accept.*_ip /etc/wwwctrl/metafile.dat | wc -l`
rule_numbers=$(( $rule_numbers-1 ))
#for i in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
for i in `seq 0 $rule_numbers`; do
	if grep -q fw_remotemng_accept${i}_ip $metafile_diff.$CGI_PAGE_ID ; then
		eval "IP="$"fw_remotemng_accept${i}_ip"
		old_IP=`grep "fw_remotemng_accept${i}_ip" ${env_conf}.staging| cut -d '=' -f 2`
		if [ -z "$IP" ]; then
			if [ ! -z "$old_IP" ]; then
				log_msg "remove MCL accept IP $old_IP"
			else
				log_msg "change MCL accept IP"
			fi
		else
			if [ ! -z "$old_IP" ]; then
				log_msg "modify MCL IP cahnge $old_IP to \"$IP\""
			else
				log_msg "add MCL accept IP \"$IP\""
			fi
		fi
	fi
done

if [ "$fw_service_w0_telnet_enable" = "1" ]; then
	log_msg "TELNET for WAN is enabled"
elif [ "$fw_service_w0_telnet_enable" = "0" ]; then
	log_msg "TELNET for WAN is disabled"
fi

if [ "$fw_service_w0_ssh_enable" = "1" ]; then
	log_msg "SSH for WAN is enabled"
elif [ "$fw_service_w0_ssh_enable" = "0" ]; then
	log_msg "SSH for WAN is disabled"
fi

if [ "$fw_service_w0_tftp_enable" = "1" ]; then
	log_msg "TFTP for WAN is enabled"
elif [ "$fw_service_w0_tftp_enable" = "0" ]; then
	log_msg "TFTP for WAN is disabled"
fi

if [ "$fw_service_w0_web_enable" = "1" ]; then
	log_msg "WEB for WAN is enabled"
elif [ "$fw_service_w0_web_enable" = "0" ]; then
	log_msg "WEB for WAN is disabled"
fi

if [ "$fw_service_w0_snmp_enable" = "1" ]; then
	log_msg "SNMP for WAN is enabled"
elif [ "$fw_service_w0_snmp_enable" = "0" ]; then
	log_msg "SNMP for WAN is disabled"
fi

if [ "$fw_service_w0_ping_enable" = "1" ]; then
	log_msg "PING for WAN is enabled"
elif [ "$fw_service_w0_ping_enable" = "0" ]; then
	log_msg "PING for WAN is disabled"
fi

if [ "$fw_service_w0_traceroute_enable" = "1" ]; then
	log_msg "TRACEROUTE for WAN is enabled"
elif [ "$fw_service_w0_traceroute_enable" = "0" ]; then
	log_msg "TRACEROUTE for WAN is disabled"
fi

if [ "$fw_service_l0_telnet_enable" = "1" ]; then
	log_msg "TELNET for LAN is enabled"
elif [ "$fw_service_l0_telnet_enable" = "0" ]; then
	log_msg "TELNET for LAN is disabled"
fi

if [ "$fw_service_l0_ssh_enable" = "1" ]; then
	log_msg "SSH for LAN is enabled"
elif [ "$fw_service_l0_ssh_enable" = "0" ]; then
	log_msg "SSH for LAN is disabled"
fi

if [ "$fw_service_l0_tftp_enable" = "1" ]; then
	log_msg "TFTP for LAN is enabled"
elif [ "$fw_service_l0_tftp_enable" = "0" ]; then
	log_msg "TFTP for LAN is disabled"
fi

if [ "$fw_service_l0_web_enable" = "1" ]; then
	log_msg "WEB for LAN is enabled"
elif [ "$fw_service_l0_web_enable" = "0" ]; then
	log_msg "WEB for LAN is disabled"
fi

if [ "$fw_service_l0_snmp_enable" = "1" ]; then
	log_msg "SNMP for LAN is enabled"
elif [ "$fw_service_l0_snmp_enable" = "0" ]; then
	log_msg "SNMP for LAN is disabled"
fi
