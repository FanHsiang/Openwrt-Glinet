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

CFM_MP_STATUS=/tmp/cfm_mp_status
CCM_Counter=/tmp/ccm_counter
LBM_Counter=/tmp/lbm_counter
CFM_Interface=/tmp/cfm_interface
LTR_Status=/tmp/ltr_status

	MEP_TCH=0
	CCM_TX_CNT=0
	CCM_TX_Drop=0
	CCM_FW=0
	LBM_TX_CNT=0
	LBR_TX_CNT=0
	LBR_RX_CNT=0

if [ "$1" = "action" ]; then
	MP_Tline=`omcicli -c "cfm mp" | grep total | cut -d" " -f2`
	MP_Tline=$((${MP_Tline}+2))
	omcicli -c "cfm mp" | grep -A 100 "idx" | head -${MP_Tline} > $CFM_MP_STATUS
	CFM_TLines=`cat $CFM_MP_STATUS | wc -l`

	for i in `seq 3 $CFM_TLines`; do
		CFM_info=`head -$i ${CFM_MP_STATUS} | tail -1`
		#echo $CFM_info
		MEP=`echo $CFM_info | awk '{ print $4 }'`
		MD_Level=`echo $CFM_info | awk '{ print $5 }'`
		PriVLAN=`echo $CFM_info | awk '{ print $8 }' | sed 's/\//\-/'`
		PBit=`echo $CFM_info | awk '{ print $9 }'`
		MEP_ID=`echo $CFM_info | awk '{ print $6 }'`
		Interface=`echo $CFM_info | awk '{ print $2 }' | sed 's/(.*)//g'`
		Dir=`echo $CFM_info | awk '{ print $3 }'`
		CCM=`echo $CFM_info | awk '{ print $11 }'`
		Select=`echo checkbox${MD_Level}_${MEP_ID}`
		MEP_MAC=`omcicli -c "cfm mp ${MD_Level} ${MEP_ID}" | grep "macaddr:" | sed 's/.*macaddr: //' `
		MD_Name=`omcicli -c "cfm mp ${MD_Level} ${MEP_ID}" | grep "MD name:" | sed 's/.*MD name: //' `
		MA_Name=`omcicli -c "cfm mp ${MD_Level} ${MEP_ID}" | grep "MA name:" | sed 's/.*MA name: //' `

		Cont_Line_no=$(($i-2))
		[ "$i" == "3" ] && echo -n "cfm_content_line$Cont_Line_no=[{"
		[ "$i" != "3" ] && echo -n "cfm_content_line$Cont_Line_no={"
		echo -n "\"Type\":\"$MEP\","
		echo -n "\"MD Level\":\"$MD_Level\","
		echo -n "\"MD Name\":\"(${MD_Name})_(${MA_Name})\","
		echo -n "\"VLAN ID\":\"$PriVLAN\","
		echo -n "\"P-Bit\":\"$PBit\","
		echo -n "\"ID\":\"$MEP_ID\","
		echo -n "\"Interface\":\"$Interface\","
		echo -n "\"Direction\":\"$Dir\","
		echo -n "\"MAC Address\":\"$MEP_MAC\","
		echo -n "\"CCM\":\"$CCM\","

		if [ "$i" = "$CFM_TLines" ] ; then
			echo "\"Select\":\"$Select\"}]"
		else
			echo "\"Select\":\"$Select\"},"
		fi

	done

elif [ "$1" = "status" ]; then

	# LTR Status
	ONU_SN=`grep onu_serial /nvram/gpon.dat	 | cut -d= -f2`
	omcicli -c "cfm show ltr" | grep -A 100 "idx" | grep -i -v ${ONU_SN} | grep -v client > $LTR_Status
	LTR_TLines=`cat $LTR_Status | wc -l`
	#Ltr_s=`omcicli -c "cfm show ltr" | grep -A 2 "idx" | tail -1 | grep -v ${ONU_SN}`

	if [ $LTR_TLines -gt 2 ]; then
		for i in `seq 3 $LTR_TLines`; do
			Ltr_s=`head -$i ${LTR_Status} | tail -1`

			Ltr_Ind=`echo $Ltr_s | awk '{ print $1 }'`
			Ltr_MDLPid=`echo $Ltr_s | awk '{ printf("%s-%s",$2,$3) }'`
			Ltr_MAC=`echo $Ltr_s | awk '{ print $4 }'`
			Ltr_TTL=`echo $Ltr_s | awk '{ print $6 }'`
			Ltr_RepT=`echo $Ltr_s | awk '{ print $7 }'`

			Cont_Line_no=$(($i-2))
			[ "$i" == "3" ] && echo -n "ltm_status_line$Cont_Line_no=[{"
			[ "$i" != "3" ] && echo -n "ltm_status_line$Cont_Line_no={"
			echo -n "\"Index\":\"$Ltr_Ind\","
			echo -n "\"MDL-MPid\":\"$Ltr_MDLPid\","
			echo -n "\"MAC\":\"$Ltr_MAC\","
			echo -n "\"TTL\":\"$Ltr_TTL\","
			#echo	 "\"Response Time\":\"$Ltr_RepT\"}]"
			if [ "$i" = "$LTR_TLines" ] ; then
				echo "\"Response Time\":\"$Ltr_RepT\"}]"
			else
				echo "\"Response Time\":\"$Ltr_RepT\"},"
			fi
		done
	fi

	# CCM/LBM Status
	MP_Tline=`omcicli -c "cfm mp" | grep total | cut -d" " -f2`
	MP_Tline=$((${MP_Tline}+2))
	omcicli -c "cfm counter ccm" | grep -A 100 "idx" | head -${MP_Tline}  > $CCM_Counter
	omcicli -c "cfm counter lbm" | grep -A 100 "idx" | head -${MP_Tline}  > $LBM_Counter
	Counter_TLines=`cat $CCM_Counter | wc -l`

	for k in `seq 3 $Counter_TLines`; do

		## CCM Counter
		CCM_CNT_t=`cat $CCM_Counter | head -${k} | tail -1`
		# CCM_TX
		CCM_TX_CNT_t=`echo $CCM_CNT_t | tr -s ' ' | cut -d" " -f4`
		CCM_TX_CNT=$(($CCM_TX_CNT + $CCM_TX_CNT_t))
		# CCM_Drp
		CCM_TX_Drop_t=`echo $CCM_CNT_t | tr -s ' ' | cut -d" " -f6`
		CCM_TX_Drop=$(($CCM_TX_Drop + $CCM_TX_Drop_t))
		# CCM_FW
		CCM_FW_t=`echo $CCM_CNT_t | tr -s ' ' | cut -d" " -f7`
		CCM_FW=$(($CCM_FW + $CCM_FW_t))

		## LBM Counter
		LBM_CNT_t=`cat $LBM_Counter | head -${k} | tail -1`
		# LBM_TX
		LBM_TX_CNT_t=`echo $LBM_CNT_t | tr -s ' ' | cut -d" " -f4`
		LBM_TX_CNT=$(($LBM_TX_CNT + $LBM_TX_CNT_t))
		# LBM_RX
		LBR_RX_CNT_t=`echo $LBM_CNT_t | tr -s ' ' | cut -d" " -f9`
		LBR_RX_CNT=$(($LBR_RX_CNT + $LBR_RX_CNT_t))
		# LBR_TX
		LBR_TX_CNT_t=`echo $LBM_CNT_t | tr -s ' ' | cut -d" " -f8`
		LBR_TX_CNT=$(($LBR_TX_CNT + $LBR_TX_CNT_t))
	done

	echo "sentCCM=$CCM_TX_CNT"
	echo "invalidCCM=$CCM_TX_Drop"
	echo "crossCCM=$CCM_FW"
	echo "sentLBM=$LBM_TX_CNT"
	echo "inorderLBR=$LBR_RX_CNT"
	echo "outorderLBR=$LBR_TX_CNT"

elif [ "$1" = "set" ]; then

	if [ -f $metafile ]; then
		$WWWCTRL_BIN --kvprint_shell_escaped $metafile > /tmp/sh.$$;
		. /tmp/sh.$$; rm /tmp/sh.$$
	else
		exit 1
	fi
	if [ -f $metafile_diff.$CGI_PAGE_ID ]; then
		$WWWCTRL_BIN --kvprint_shell_escaped $metafile_diff.$CGI_PAGE_ID > /tmp/sh.$$
		. /tmp/sh.$$ ;rm /tmp/sh.$$
	else
		exit 1
	fi

	if [ ! -z "$selected_mep" ]; then
		ccm_md_level=`echo $selected_mep | cut -d_ -f 1`
		ccm_mepid=`echo $selected_mep | cut -d_ -f 2`
		if [ "$enable_ccm" = "1" ]; then
			omcicli -c "cfm mp config ccm_enable $ccm_md_level $ccm_mepid 1"
			omcicli -c "cfm mp config ccm_interval $ccm_md_level $ccm_mepid 6"
		fi
		if [ "$disable_ccm" = "1" ]; then
			omcicli -c "cfm mp config ccm_enable $ccm_md_level $ccm_mepid 0"
			omcicli -c "cfm mp config ccm_interval $ccm_md_level $ccm_mepid 0"
		fi
	fi

	if [ ! -z "$mep_send_ltm" ]; then
		ltm_md_level=`echo $mep_send_ltm | cut -d_ -f 1`
		ltm_mepid=`echo $mep_send_ltm | cut -d_ -f 2`
		omcicli -c "cfm send ltm $ltm_md_level $ltm_mepid $mep_send_mac"
		#echo "cfm send ltm $ltm_md_level $ltm_mepid $mep_send_mac" > /dev/console
	fi

	if [ ! -z "$mep_send_lbm" ]; then
		lbm_md_level=`echo $mep_send_lbm | cut -d_ -f 1`
		lbm_mepid=`echo $mep_send_lbm | cut -d_ -f 2`
		omcicli -c "cfm send lbm $lbm_md_level $lbm_mepid $mep_send_mac $lbm_send_count"
	fi

	[ "$cfm_clear_all" = "1" ] && omcicli -c "cfm counter clear"
	[ "$cfm_clear_ccm" = "1" ] && omcicli -c "cfm counter clear"
	[ "$cfm_clear_lbm" = "1" ] && omcicli -c "cfm counter clear"
	[ "$cfm_clear_ltm" = "1" ] && omcicli -c "cfm clear ltr"

fi
