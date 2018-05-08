var darkBlue ='#ADAE9D';
var yellow   ='#FFFFFF';
var white    ='#FFFFFF';
var red	     ='#000000';
var blue     ='#CCCCCC';
var black    ='#000000';
function showMenu0(menuSection,menuItem)
{
	var strHtml;
	strHtml='<table border="0" cellspacing="0" cellpadding="0">'+
		'<tr>'+
		'<td width="185" height="100%" valign="top">'+
			'<table width="185" border="0" cellspacing="0" cellpadding="0" align="left">';
	document.write(strHtml);
	if(menuSection=='Home')
	{
		printMenuSection('status',9, 'Status', yellow,parent.hide_status_item);
		if(menuItem=='Status')
		{
			printMenuItem('status', 1 ,'wwwctrl.cgi?action=sysinfo', 'System Usage', red, darkBlue,parent.hide_status_item);
		}else{
			printMenuItem('status', 1 ,'wwwctrl.cgi?action=sysinfo', 'System Usage', black, blue,parent.hide_status_item);
		}
		if(menuItem=='WAN PON Status')
		{
			printMenuItem('status', 2 ,'wwwctrl.cgi?action=wan_pon', 'WAN PON Status', red, darkBlue,parent.hide_status_item);
		}else{
			printMenuItem('status', 2 ,'wwwctrl.cgi?action=wan_pon', 'WAN PON Status', black, blue,parent.hide_status_item);
		}
		if(menuItem=='GPON')
		{
			printMenuItem('status', 3 ,'wwwctrl.cgi?action=pon_link', 'PON Link Status', red, darkBlue,parent.hide_status_item);
		}else{
			printMenuItem('status', 3 ,'wwwctrl.cgi?action=pon_link', 'PON Link Status', black, blue,parent.hide_status_item);
		}
		if(menuItem=='Device')
		{
			printMenuItem('status', 4 ,'wwwctrl.cgi?action=device', 'Device Table', red, darkBlue,parent.hide_status_item);
		}else{
			printMenuItem('status', 4 ,'wwwctrl.cgi?action=device', 'Device Table', black, blue,parent.hide_status_item);
		}
		if(menuItem=='DHCP_tab')
		{
			printMenuItem('status', 5 ,'wwwctrl.cgi?action=dhcp', 'DHCP Lease', red, darkBlue,parent.hide_status_item);
		}else{
			printMenuItem('status', 5 ,'wwwctrl.cgi?action=dhcp', 'DHCP Lease', black, blue,parent.hide_status_item);
		}
		if(menuItem=='WiFi_tab')
		{
			printMenuItem('status', 6 ,'wwwctrl.cgi?action=wifi_association', 'WiFi Association', red, darkBlue,parent.hide_status_item);
		}else{
			printMenuItem('status', 6 ,'wwwctrl.cgi?action=wifi_association', 'WiFi Association', black, blue,parent.hide_status_item);
		}
		if(menuItem=='Statistics')
		{
			printMenuItem('status', 7 ,'wwwctrl.cgi?action=statistics', 'WAN/(W)LAN Statistics', red, darkBlue,parent.hide_status_item);
		}else{
			printMenuItem('status', 7 ,'wwwctrl.cgi?action=statistics', 'WAN/(W)LAN Statistics', black, blue,parent.hide_status_item);
		}
		/*
		if(menuItem=='IGMP Membership')
		{
			printMenuItem('status', 8 ,'wwwctrl.cgi?action=igmp', 'IGMP Membership', red, darkBlue,parent.hide_status_item);
		}else{
			printMenuItem('status', 8 ,'wwwctrl.cgi?action=igmp', 'IGMP Membership', black, blue,parent.hide_status_item);
		}
		if(menuItem=='IGMP Statistic')
		{
			printMenuItem('status', 9 ,'wwwctrl.cgi?action=igmp_statistic', 'IGMP Statistic', red, darkBlue,parent.hide_status_item);
		}else{
			printMenuItem('status', 9 ,'wwwctrl.cgi?action=igmp_statistic', 'IGMP Statistic', black, blue,parent.hide_status_item);
		}
		*/
	}else{
		printMenuSection('status',9, 'Status', white,parent.hide_status_item);
		printMenuItem('status', 1 ,'wwwctrl.cgi?action=sysinfo', 'System Usage', black, white,parent.hide_status_item);
		printMenuItem('status', 2 ,'wwwctrl.cgi?action=wan_pon', 'WAN PON Status', black, white,parent.hide_status_item);
		printMenuItem('status', 3 ,'wwwctrl.cgi?action=pon_link', 'PON Link Status', black, white,parent.hide_status_item);
		printMenuItem('status', 4 ,'wwwctrl.cgi?action=device', 'Device Table', black, white,parent.hide_status_item);
		printMenuItem('status', 5 ,'wwwctrl.cgi?action=dhcp', 'DHCP Lease', black, white,parent.hide_status_item);
		printMenuItem('status', 6 ,'wwwctrl.cgi?action=wifi_association', 'WiFi Association', black, white,parent.hide_status_item);
		printMenuItem('status', 7 ,'wwwctrl.cgi?action=statistics', 'WAN/(W)LAN Statistics', black, white,parent.hide_status_item);
		//printMenuItem('status', 8 ,'wwwctrl.cgi?action=igmp', 'IGMP Membership', black, white,parent.hide_status_item);
		//printMenuItem('status', 9 ,'wwwctrl.cgi?action=igmp_statistic', 'IGMP Statistic', black, white,parent.hide_status_item);
	}

	if(menuSection=='Network')
	{
		printMenuSection('net',3, 'Network', yellow,parent.hide_net_item);
		/*
		if(menuItem=='USB')
		{
			printMenuItem('net', 1 ,'wwwctrl.cgi?action=usb', 'USB', red, darkBlue,parent.hide_net_item);
		}else{
			printMenuItem('net', 1 ,'wwwctrl.cgi?action=usb', 'USB', black, blue,parent.hide_net_item);
		}
		*/
		if(menuItem=='LAN Setting')
		{
			printMenuItem('net', 2 ,'wwwctrl.cgi?action=lan', 'LAN Settings', red, darkBlue,parent.hide_net_item);
		}else{
			printMenuItem('net', 2 ,'wwwctrl.cgi?action=lan', 'LAN Settings', black, blue,parent.hide_net_item);
		}
		if(menuItem=='WAN Setting')
		{
			printMenuItem('net', 3 ,'wwwctrl.cgi?action=pon_connection', 'WAN PON Connections', red, darkBlue,parent.hide_net_item);
		}else{
			printMenuItem('net', 3 ,'wwwctrl.cgi?action=pon_connection', 'WAN PON Connections', black, blue,parent.hide_net_item);
		}
	}else{
		printMenuSection('net',3, 'Network', white,parent.hide_net_item);
		//printMenuItem('net', 1 ,'wwwctrl.cgi?action=usb', 'USB', black, white,parent.hide_net_item);
		printMenuItem('net', 1 ,'wwwctrl.cgi?action=lan', 'LAN Settings', black, white,parent.hide_net_item);
		printMenuItem('net', 2 ,'wwwctrl.cgi?action=pon_connection', 'WAN PON Connections', black, white,parent.hide_net_item);
	}

	if(menuSection=='WiFi')
	{
		printMenuSection('wifi',3, 'WiFi Setup', yellow,parent.hide_wifi_item);
		if(menuItem=='WiFi Setting')
		{
			printMenuItem('wifi', 1 ,'wwwctrl.cgi?action=wifi_setting', 'WiFi Settings', red, darkBlue,parent.hide_wifi_item);
		}else{
			printMenuItem('wifi', 1 ,'wwwctrl.cgi?action=wifi_setting', 'WiFi Settings', black, blue,parent.hide_wifi_item);
		}
		if(menuItem=='WiFi Security')
		{
			printMenuItem('wifi', 2 ,'wwwctrl.cgi?action=wifi_security', 'WiFi Security', red, darkBlue,parent.hide_wifi_item);
		}else{
			printMenuItem('wifi', 2 ,'wwwctrl.cgi?action=wifi_security', 'WiFi Security', black, blue,parent.hide_wifi_item);
		}
		if(menuItem=='WiFi MAC')
		{
			printMenuItem('wifi', 3 ,'wwwctrl.cgi?action=wifi_mac', 'WiFi Access', red, darkBlue,parent.hide_wifi_item);
		}else{
			printMenuItem('wifi', 3 ,'wwwctrl.cgi?action=wifi_mac', 'WiFi Access', black, blue,parent.hide_wifi_item);
		}
	}else{
		printMenuSection('wifi',3, 'WiFi Setup', white,parent.hide_wifi_item);
		printMenuItem('wifi', 1 ,'wwwctrl.cgi?action=wifi_setting', 'WiFi Settings', black, white,parent.hide_wifi_item);
		printMenuItem('wifi', 2 ,'wwwctrl.cgi?action=wifi_security', 'WiFi Security', black, white,parent.hide_wifi_item);
		printMenuItem('wifi', 3 ,'wwwctrl.cgi?action=wifi_mac', 'WiFi Access', black, white,parent.hide_wifi_item);
	}

	if(menuSection=='Firewall')
	{
		printMenuSection('firewall',6, 'Firewall Setup', yellow,parent.hide_firewall_item);
		if(menuItem=='Port Forwarding')
		{
			printMenuItem('firewall',1,'wwwctrl.cgi?action=portforward','Port Forwarding',red,darkBlue,parent.hide_firewall_item);
		}else{
			printMenuItem('firewall',1,'wwwctrl.cgi?action=portforward','Port Forwarding',black,blue,parent.hide_firewall_item);
		}
		if(menuItem=='DMZ')
		{
			printMenuItem('firewall', 2 ,'wwwctrl.cgi?action=dmz', 'Demilitarized Zone', red, darkBlue,parent.hide_firewall_item);
		}else{
			printMenuItem('firewall', 2 ,'wwwctrl.cgi?action=dmz', 'Demilitarized Zone', black, blue,parent.hide_firewall_item);
		}
		if(menuItem=='UPNP')
   		{
			printMenuItem('firewall', 3 ,'wwwctrl.cgi?action=upnp', 'UPnP', red, darkBlue,parent.hide_firewall_item);
		}else{
			printMenuItem('firewall', 3 ,'wwwctrl.cgi?action=upnp', 'UPnP', black, blue,parent.hide_firewall_item);
		}
		if(menuItem=='Layer 2 Filter')
   		{
			printMenuItem('firewall', 4 ,'wwwctrl.cgi?action=l2_filter', 'Layer 2 Filter', red, darkBlue,parent.hide_firewall_item);
		}else{
			printMenuItem('firewall', 4 ,'wwwctrl.cgi?action=l2_filter', 'Layer 2 Filter', black, blue,parent.hide_firewall_item);
		}
		if(menuItem=='Layer 3 Filter')
   		{
			printMenuItem('firewall', 5 ,'wwwctrl.cgi?action=l3_filter', 'Layer 3 Filter', red, darkBlue,parent.hide_firewall_item);
		}else{
			printMenuItem('firewall', 5 ,'wwwctrl.cgi?action=l3_filter', 'Layer 3 Filter', black, blue,parent.hide_firewall_item);
		}
		if(menuItem=='VPN')
   		{
			printMenuItem('firewall', 6 ,'wwwctrl.cgi?action=passthrough', 'NAT Passthrough', red, darkBlue,parent.hide_firewall_item);
		}else{
			printMenuItem('firewall', 6 ,'wwwctrl.cgi?action=passthrough', 'NAT Passthrough', black, blue,parent.hide_firewall_item);
		}
	}else{
		printMenuSection('firewall',6, 'Firewall Setup', white,parent.hide_firewall_item);
		printMenuItem('firewall', 1 ,'wwwctrl.cgi?action=portforward','Port Forwarding',black,white,parent.hide_firewall_item);
		printMenuItem('firewall', 2 ,'wwwctrl.cgi?action=dmz', 'Demilitarized Zone', black, white,parent.hide_firewall_item);
		printMenuItem('firewall', 3 ,'wwwctrl.cgi?action=upnp', 'UPnP', black, white,parent.hide_firewall_item);
		printMenuItem('firewall', 4 ,'wwwctrl.cgi?action=l2_filter', 'Layer 2 Filter', black, white,parent.hide_firewall_item);
		printMenuItem('firewall', 5 ,'wwwctrl.cgi?action=l3_filter', 'Layer 3 Filter', black, white,parent.hide_firewall_item);
		printMenuItem('firewall', 6 ,'wwwctrl.cgi?action=passthrough', 'NAT Passthrough', black, white,parent.hide_firewall_item);
	}

	if(menuSection=='Advanced')
	{
		printMenuSection('adv',6, 'Advanced Setup', yellow,parent.hide_adv_item);
		if(menuItem=='Route')
		{
			printMenuItem('adv', 1 ,'wwwctrl.cgi?action=route','Route Settings', red, darkBlue,parent.hide_adv_item);
		}else{
			printMenuItem('adv', 1 ,'wwwctrl.cgi?action=route','Route Settings', black, blue,parent.hide_adv_item);
		}
		if(menuItem=='Static DNS')
		{
			printMenuItem('adv', 2 ,'wwwctrl.cgi?action=dns','DNS Settings', red, darkBlue,parent.hide_adv_item);
		}else{
			printMenuItem('adv', 2 ,'wwwctrl.cgi?action=dns','DNS Settings', black, blue,parent.hide_adv_item);
		}
		if(menuItem=='Dynamic DNS')
		{
			printMenuItem('adv', 3 ,'wwwctrl.cgi?action=dynamic_dns', 'System Log', red, darkBlue,parent.hide_adv_item);
		}else{
			printMenuItem('adv', 3 ,'wwwctrl.cgi?action=dynamic_dns', 'System Log', black, blue,parent.hide_adv_item);
		}		
		if(menuItem=='System Log')
		{
			printMenuItem('adv', 4 ,'wwwctrl.cgi?action=system_log', 'System Log', red, darkBlue,parent.hide_adv_item);
		}else{
			printMenuItem('adv', 4 ,'wwwctrl.cgi?action=system_log', 'System Log', black, blue,parent.hide_adv_item);
		}
		if(menuItem=='Static arp')
		{
			printMenuItem('adv', 5 ,'wwwctrl.cgi?action=static_arp_entry', 'static_arp', red, darkBlue,parent.hide_adv_item);
		}else{
			printMenuItem('adv', 5 ,'wwwctrl.cgi?action=static_arp_entry', 'static_arp', black, blue,parent.hide_adv_item);
		}
		if(menuItem=='Slid')
		{
			printMenuItem('adv', 6 ,'wwwctrl.cgi?action=slid', 'slid', red, darkBlue,parent.hide_adv_item);
		}else{
			printMenuItem('adv', 6 ,'wwwctrl.cgi?action=slid', 'slid', black, blue,parent.hide_adv_item);
		}
		
		
		/*
		if(menuItem=='IGMP Setting')
		{
			printMenuItem('adv', 4 ,'wwwctrl.cgi?action=igmp_setting', 'IGMP Proxy/Snooping', red, darkBlue,parent.hide_adv_item);
		}else{
			printMenuItem('adv', 4 ,'wwwctrl.cgi?action=igmp_setting', 'IGMP Proxy/Snooping', black, blue,parent.hide_adv_item);
		}
		*/
	}else{
		printMenuSection('adv',6, 'Advanced Setup', white,parent.hide_adv_item);
		printMenuItem('adv', 1 ,'wwwctrl.cgi?action=route','Route Settings', black, white,parent.hide_adv_item);
		printMenuItem('adv', 2 ,'wwwctrl.cgi?action=dns','DNS Settings', black, white,parent.hide_adv_item);
		printMenuItem('adv', 3 ,'wwwctrl.cgi?action=dynamic_dns','Dynamic DNS', black, white,parent.hide_adv_item);		
		printMenuItem('adv', 4 ,'wwwctrl.cgi?action=systemlog', 'System Log', black, white,parent.hide_adv_item);
		printMenuItem('adv', 5 ,'wwwctrl.cgi?action=static_arp_entry', 'Static arp', black, white,parent.hide_adv_item);		
		printMenuItem('adv', 6 ,'wwwctrl.cgi?action=slid', 'SLID', black, white,parent.hide_adv_item);
		//printMenuItem('adv', 4 ,'wwwctrl.cgi?action=igmp_setting', 'IGMP Proxy/Snooping', black, white,parent.hide_adv_item);
	}
	/*
	if(menuSection=='Telephony')
	{
		printMenuSection('phone',4, 'Telephony', yellow,parent.hide_phone_item);
		if(menuItem=='Account Setting')
		{
			printMenuItem('phone', 1 ,'wwwctrl.cgi?action=phone_account', 'Account Setup', red, darkBlue,parent.hide_phone_item);
		}else{
			printMenuItem('phone', 1 ,'wwwctrl.cgi?action=phone_account', 'Account Setup', black, blue,parent.hide_phone_item);
		}
		if(menuItem=='Service Settings')
		{
			printMenuItem('phone', 2 ,'wwwctrl.cgi?action=phone_service', 'Service Settings', red, darkBlue,parent.hide_phone_item);
		}else{
			printMenuItem('phone', 2 ,'wwwctrl.cgi?action=phone_service', 'Service Settings', black, blue,parent.hide_phone_item);
		}
		if(menuItem=='SIP Server')
		{
			printMenuItem('phone', 3 ,'wwwctrl.cgi?action=sip_setting', 'SIP Server Settings', red, darkBlue,parent.hide_phone_item);
		}else{
			printMenuItem('phone', 3 ,'wwwctrl.cgi?action=sip_setting', 'SIP Server Settings', black, blue,parent.hide_phone_item);
		}
		if(menuItem=='upgradeDialPlan')
		{
			printMenuItem('phone', 4 ,'wwwctrl.cgi?action=dial_plan', 'Upgrade Dial Plan', red, darkBlue,parent.hide_phone_item);
		}else{
			printMenuItem('phone', 4 ,'wwwctrl.cgi?action=dial_plan', 'Upgrade Dial Plan', black, blue,parent.hide_phone_item);
		}
	}else{
		printMenuSection('phone',4, 'Telephony', white,parent.hide_phone_item);
		printMenuItem('phone', 1 ,'wwwctrl.cgi?action=phone_account', 'Account Setup', black, white,parent.hide_phone_item);
		printMenuItem('phone', 2 ,'wwwctrl.cgi?action=phone_service', 'Service Settings', black, white,parent.hide_phone_item);
		printMenuItem('phone', 3 ,'wwwctrl.cgi?action=sip_setting', 'SIP Server Settings', black, white,parent.hide_phone_item);
		printMenuItem('phone', 4 ,'wwwctrl.cgi?action=dial_plan', 'Upgrade Dial Plan', black,white,parent.hide_util_item);
	}
	*/
	if(menuSection=='Util')
	{
		printMenuSection('util',9, 'Utilities', yellow,parent.hide_util_item);
		if(menuItem=='CfgStore')
		{
			printMenuItem('util', 1 ,'wwwctrl.cgi?action=config_backup', 'Configuration Backup', red, darkBlue,parent.hide_util_item);
		}else{
			printMenuItem('util', 1 ,'wwwctrl.cgi?action=config_backup', 'Configuration Backup', black, blue,parent.hide_util_item);
		}
		if(menuItem=='CfgRestore')
		{
			printMenuItem('util', 2 ,'wwwctrl.cgi?action=config_restore', 'Configuration Restore', red, darkBlue,parent.hide_util_item);
		}else{
			printMenuItem('util', 2 ,'wwwctrl.cgi?action=config_restore', 'Configuration Restore', black, blue,parent.hide_util_item);
		}
		if(menuItem=='Webfirmware')
		{
			printMenuItem('util', 3 ,'wwwctrl.cgi?action=firmware_upgrade', 'Firmware Upgrade', red, darkBlue,parent.hide_util_item);
		}else{
			printMenuItem('util', 3 ,'wwwctrl.cgi?action=firmware_upgrade', 'Firmware Upgrade', black, blue,parent.hide_util_item);
		}
		if(menuItem=='WebBootload')
		{
			printMenuItem('util', 4 ,'wwwctrl.cgi?action=bootloader_upgrade', 'Bootloader Upgrade', red, darkBlue,parent.hide_util_item);
		}else{
			printMenuItem('util', 4 ,'wwwctrl.cgi?action=bootloader_upgrade', 'Bootloader Upgrade', black, blue,parent.hide_util_item);
		}
		if(menuItem=='System Settings')
		{
			printMenuItem('util', 5 ,'wwwctrl.cgi?action=system_setting', 'System Settings', red, darkBlue,parent.hide_util_item);
		}else{
			printMenuItem('util', 5 ,'wwwctrl.cgi?action=system_setting', 'System Settings', black, blue,parent.hide_util_item);
		}
		if(menuItem=='Remote Management')
		{
			printMenuItem('util', 6 ,'wwwctrl.cgi?action=cwmp','CWMP Management', red, darkBlue,parent.hide_util_item);
		}else{
			printMenuItem('util', 6 ,'wwwctrl.cgi?action=cwmp','CWMP Management', black, blue,parent.hide_util_item);
		}
		if(menuItem=='PingTest')
		{
			printMenuItem('util', 7 ,'wwwctrl.cgi?action=connection_test', 'Connection Test', red, darkBlue,parent.hide_util_item);
		}else{
			printMenuItem('util', 7 ,'wwwctrl.cgi?action=connection_test', 'Connection Test', black, blue,parent.hide_util_item);
		}
		if(menuItem=='Restore Factory Default')
		{
			printMenuItem('util', 8 ,'wwwctrl.cgi?action=factory_default', 'Restore Factory Defaults', red, darkBlue,parent.hide_util_item);
		}else{
			printMenuItem('util', 8 ,'wwwctrl.cgi?action=factory_default', 'Restore Factory Defaults', black, blue,parent.hide_util_item);
		}
		if(menuItem=='RebootGateway')
		{
			printMenuItem('util', 9 ,'wwwctrl.cgi?action=reboot', 'Reboot Gateway', red, darkBlue,parent.hide_util_item);
		}else{
			printMenuItem('util', 9 ,'wwwctrl.cgi?action=reboot', 'Reboot Gateway', black, blue,parent.hide_util_item);
		}
	}else{
		printMenuSection('util',9, 'Utilities', white,parent.hide_util_item);
		printMenuItem('util', 1 ,'wwwctrl.cgi?action=config_backup', 'Configuration Backup', black,white,parent.hide_util_item);
		printMenuItem('util', 2 ,'wwwctrl.cgi?action=config_restore', 'Configuration Restore', black,white,parent.hide_util_item);
		printMenuItem('util', 3 ,'wwwctrl.cgi?action=firmware_upgrade', 'Firmware Upgrade', black,white,parent.hide_util_item);
		printMenuItem('util', 4 ,'wwwctrl.cgi?action=bootloader_upgrade', 'Bootloader Upgrade', black,white,parent.hide_util_item);
		printMenuItem('util', 5 ,'wwwctrl.cgi?action=system_setting', 'System Settings',black,white,parent.hide_util_item);
		printMenuItem('util', 6 ,'wwwctrl.cgi?action=cwmp', 'CWMP Management', black,white,parent.hide_util_item);
		printMenuItem('util', 7 ,'wwwctrl.cgi?action=connection_test', 'Connection Test',black,white,parent.hide_util_item);
		printMenuItem('util', 8 ,'wwwctrl.cgi?action=factory_default', 'Restore Factory Defaults',black, white,parent.hide_util_item);
		printMenuItem('util', 9 ,'wwwctrl.cgi?action=reboot', 'Reboot Gateway',black,white,parent.hide_util_item);
	}

   	strHtml='</table>'+
		'</td>'+
		'<td valign="top" width="1" bgcolor="#CCCCCC" height="100%">'+
		'<img src="/images/shim.gif" width="1" height="1">'+
		'</td>';
	document.write(strHtml);
}

