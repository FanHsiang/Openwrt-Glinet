#!/bin/sh

alm_en="Alarm !"
alm_off="off"

if [ "$1" = "get" ]; then
	onu_state=`diag gpon get onu-state | grep 'ONU state' | cut -d'(' -f2 | cut -d')' -f1`
	SF_state=`omci -c "me 263" | grep alarm | grep -c -e "2"`
	SD_state=`omci -c "me 263" | grep alarm | grep -c -e "3"`
	#SD_state=`omcicli -c "me 263" | grep alarm | sed -e 's/.*(//' | sed -e 's/).*//' | sed -e 's/.*3/3/' | sed -e 's/3.*/3/'`

	if [  $SF_state == "1" ]; then alarm_sf=$alm_en; else alarm_sf=$alm_off; fi
	echo "kv_alarm_sf=$alarm_sf"
	if [  $SD_state == "1" ]; then alarm_sd=$alm_en; else alarm_sd=$alm_off; fi
	echo "kv_alarm_sd=$alarm_sd"

	alarm_pee="N/A PEE"
	echo "kv_alarm_pee=$alarm_pee"
	
	alarm_lom=`omci -c "gpon get alarm-status" | grep LOM | grep occur | sed -e 's/.*status: //'`
	if [  $alarm_lom == "occur" ]; then alarm_lom=$alm_en; else alarm_lom=$alm_off; fi
	echo "kv_alarm_lom=$alarm_lom"

	alarm_tf="N/A TF"
	echo "kv_alarm_tf=$alarm_tf"

	alarm_los=`omci -c "gpon get alarm-status" | grep LOS | grep occur | sed -e 's/.*status: //'`
	if [  $alarm_los == "occur" ]; then alarm_los=$alm_en; else alarm_los=$alm_off; fi
	echo "kv_alarm_los=$alarm_los"
	alarm_lof=`omci -c "gpon get alarm-status" | grep LOF | grep occur | sed -e 's/.*status: //'`
	if [  $alarm_lof == "occur" ]; then alarm_lof=$alm_en; else alarm_lof=$alm_off; fi
	echo "kv_alarm_lof=$alarm_lof"

	if [  "$onu_state" == "O2" ]; then alarm_dact=$alm_en; else alarm_dact=$alm_off; fi
	echo "kv_alarm_dact=$alarm_dact"

	if [  "$onu_state" == "O7" ]; then alarm_dis=$alm_en; else alarm_dis=$alm_off; fi
	echo "kv_alarm_dis=$alarm_dis"

	alarm_mis="N/A MIS"
	echo "kv_alarm_mis=$alarm_mis"
	alarm_mem="N/A MEM"
	echo "kv_alarm_mem=$alarm_mem"

	if [  "$onu_state" != "O5" ]; then alarm_suf=$alm_en; else alarm_suf=$alm_off; fi
	echo "kv_alarm_suf=$alarm_suf"

	alarm_rdi="N/A RDI"
	echo "kv_alarm_rdi=$alarm_rdi"
fi
