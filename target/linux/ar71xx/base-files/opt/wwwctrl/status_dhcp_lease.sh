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

#if [ -f $metafile ]; then
#	$WWWCTRL_BIN --kvprint_shell_escaped $metafile > /tmp/sh.$$; 
#	. /tmp/sh.$$; rm /tmp/sh.$$
#else
#	exit 1
#fi

DHCPLEASE_LOG_FILE=/var/run/dhcp/dhcpdv4.leases.br0
DHCPLEASE_LOG_CLEAN_FILE=/var/run/dhcp/dhcpdv4.leases.clean.br0
DHCP_IP_FILE=/tmp/leaseIP.txt

# for the first start after reset to default
# the lease file becomes dhcpdv4.leases~, don't know why
# get the correct file having the newest lease
lease_file () {
	t0=`grep starts $DHCPLEASE_LOG_FILE  2>/dev/null | sort -r | head -n1 | tr -d -c 0-9`
	if [ -z $t0 ]; then t0=0; fi
	t1=`grep starts $DHCPLEASE_LOG_FILE~ 2>/dev/null | sort -r | head -n1 | tr -d -c 0-9`
	if [ -z $t1 ]; then t1=0; fi

	if [ $t1 -gt $t0 ]; then
		echo $DHCPLEASE_LOG_FILE~
	else
		echo $DHCPLEASE_LOG_FILE
	fi
}

# remove old lease info for the same IP. keep the last one.
clean_log () {
	f=$( lease_file )
	# get ip uniq list
	grep "^lease " $f | cut -d' ' -f2 | sort -u > /tmp/dhcp_clean.$$.1
	# up side down
	cat $f | sed '1!G;h;$!d' > /tmp/dhcp_clean.$$.2

	# replace all "lease" to "log"
	# and replace the first "log" to "lease"
	while read ip; do
		c=`grep "^lease $ip " /tmp/dhcp_clean.$$.2 | wc -l`
		if [ $c > 1 ]; then
			sed -i "s/^lease $ip /log $ip /" /tmp/dhcp_clean.$$.2
			sed -i "s/^log $ip /lease $ip /; t loop; b; :loop; N; b loop;" /tmp/dhcp_clean.$$.2
		fi
	done < /tmp/dhcp_clean.$$.1

	# down side up
	cat /tmp/dhcp_clean.$$.2 | sed '1!G;h;$!d' > /tmp/dhcp_clean.$$.3
	cp -f /tmp/dhcp_clean.$$.3 $DHCPLEASE_LOG_CLEAN_FILE
	rm -f /tmp/dhcp_clean.$$.*
}

if [ "$1" = "get" ]; then

	`rm -f $DHCP_IP_FILE`
	 `grep { $( lease_file ) |awk '{print $2}' > $DHCP_IP_FILE`
	 
	 if [ -f $DHCP_IP_FILE ]; then
		clean_log
		awk 'BEGIN{
			while( (getline line < "/tmp/leaseIP.txt") > 0){
					leaseIP[line]
				}
				RS="}"
				FS="\n"
			}
			/lease/{
				for(i=1;i<=NF;i++){
					gsub(";","",$i)
					if ($i ~ /lease/) {
						m=split($i, IP," ")
						ip=IP[2]
					}
					if( $i ~ /hardware/ ){
						m=split($i, hw," ")
						ether=hw[3]
					}
					if ( $i ~ /client-hostname/){
						m=split($i,ch, " ")
						m=split(ch[2],hname, "\"")
						hostname=hname[2]
					}
					if ( $i ~ /uid/){
						m=split($i,ui, " ")
						uid=ui[2]
					}
					if ( $i ~ /ends/){
						m=split($i,end, " ")
						end_date=end[3]
						end_time=end[4]
					}
				}
				if ( ip in leaseIP ){
					count++
					printf("kv_dhcp_lease_ip%d=%s\n", count, ip)
					printf("kv_dhcp_lease_mac%d=%s\n", count, ether)
					printf("kv_dhcp_lease_hostname%d=%s\n", count, hostname)
					printf("kv_dhcp_lease_expiry%d=%s-%s\n", count, end_date, end_time )		
				}
			} 
			END{
				printf("kv_dhcp_lease_num=%d\n",count)
			}' $DHCPLEASE_LOG_CLEAN_FILE
		
	 fi
	
elif [ "$1" = "clear" ]; then
	echo "" > $DHCPLEASE_PRINT_FILE
fi
exit 0
