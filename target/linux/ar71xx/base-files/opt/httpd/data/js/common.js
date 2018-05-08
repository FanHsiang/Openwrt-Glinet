//===  start common.js ===//

var countZero=0;
var LANG;

function isChinese(word)
{
	var i=0;
	var c;
	for(i=0;i<word.length;i++)
	{
	   c = word.charCodeAt(i);
	   if (!(c>=32&&c<=126))
		return 1;
	}
	return 0;
}

function getDigit(str, num)
{
	i=1;
	if ( num != 1 ) {
		while (i!=num && str.length!=0)
		{
			if ( str.charAt(0) == '.' )
			{
				i++;
			}
			str = str.substring(1);
		}
		if ( i!=num )
			return -1;
	}
	for (i=0; i<str.length; i++) {
		if ( str.charAt(i) == '.' ) {
			str = str.substring(0, i);
			break;
		}
	}
	if ( str.length == 0)
		return -1;
	d = parseInt(str, 10);
	return d;
}


function checkSubnet(ip, mask, client)
{
	ip_d = getDigit(ip, 1);
	mask_d = getDigit(mask, 1);
	client_d = getDigit(client, 1);
	if ( (ip_d & mask_d) != (client_d & mask_d ) )
		return false;

	ip_d = getDigit(ip, 2);
	mask_d = getDigit(mask, 2);
	client_d = getDigit(client, 2);
	if ( (ip_d & mask_d) != (client_d & mask_d ) )
		return false;

	ip_d = getDigit(ip, 3);
	mask_d = getDigit(mask, 3);
	client_d = getDigit(client, 3);
	if ( (ip_d & mask_d) != (client_d & mask_d ) )
		return false;

	ip_d = getDigit(ip, 4);
	mask_d = getDigit(mask, 4);
	client_d = getDigit(client, 4);
	if ( (ip_d & mask_d) != (client_d & mask_d ) )
		return false;

	return true;
}


function setMenuFlag(name,start,end)
{
	var i=0;
	var flag;
	if (name=="status")
		flag = parent.hide_status_item;
	else if (name=="net")
		flag = parent.hide_net_item;
	else if (name=="wifi")
		flag = parent.hide_wifi_item;
	else if (name=="firewall")
		flag = parent.hide_firewall_item;
	else if (name=="adv")
		flag = parent.hide_adv_item;
	else if (name=="qos")
		flag = parent.hide_qos_item;
	else if (name=="qos_atm")
		flag = parent.hide_qos_atm_item;
	else if (name=="phone")
		flag = parent.hide_phone_item;
	else if (name=="util")
		flag = parent.hide_util_item;
	else
		return;

	for (i=start;i<=end;i++)
	{
		var obj=document.getElementById("id_" + name + "_item" + i);
		if (flag==0)
			obj.style.display="none";
		else
			obj.style.display="";
	}

	if (flag == 0)
		document.getElementById("id_" + name + "_item" + (end+1)).src = "/images/down.jpg";
	else
		document.getElementById("id_" + name + "_item" + (end+1)).src = "/images/up.jpg";

	if (name=="status")
		parent.hide_status_item = (flag==0)?1:0;
	else if (name=="net")
		parent.hide_net_item = (flag==0)?1:0;
	else if (name=="wifi")
		parent.hide_wifi_item = (flag==0)?1:0;
	else if (name=="firewall")
		parent.hide_firewall_item = (flag==0)?1:0;
	else if (name=="adv")
		parent.hide_adv_item = (flag==0)?1:0;
	else if (name=="qos")
		parent.hide_qos_item = (flag==0)?1:0;
	else if (name=="qos_atm")
		parent.hide_qos_atm_item = (flag==0)?1:0;
	else if (name=="phone")
		parent.hide_phone_item = (flag==0)?1:0;
	else if (name=="util")
		parent.hide_util_item = (flag==0)?1:0;

}

function changeCursor(name,end)
{
	document.getElementById("id_" + name + "_item" + (end+2)).style.cursor="pointer";
}

function moreInfo(url)
{
	var enhancePopup = true;
	if(enhancePopup) // usual case
	{
		fw=window.open(url, "fw", "resizable=yes,status=yes,scrollbars,HEIGHT=600,WIDTH=800");
		fw.focus();
	}
	else
	{
		self.location.href=url;
	}
}

function isBlank(s)
{
	for(i=0;i<s.length;i++)
	{
		c=s.charAt(i);
		if((c!=' ')&&(c!='\n')&&(c!='\t'))
		{
			return false;
		}
	}

	return true;
}
function isStringOK(s)
{
	if(isBlank(s))
		return false;
	else if(s.length>0)
		return true;
	else
		return false;
}

function isInitialZero(num)
{
	if((num.length > 1)&&(num.charAt(0) == '0'))
	{
		return true;
	}
	else
	{
		return false;
	}
}

function check_integer(a)
{
	var i;
	var c;

	if(a.length==0)
	{
		if((a>='0')&&(a<='9'))
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	else
	{
		for(i=0; i<a.length; i++)
		{
			c=a.charAt(i);

			if((c>='0')&&(c<='9'))
			{
				continue;
			}
			else
			{
				return false;
			}
		}
	}

	return true;
}

function check_0Tof(a)
{
	var i;
	var c;

	if(a.length==0)
	{
		if(((a>='0')&&(a<='9'))||((a>='a')&&(a<='f'))||((a>='A')&&(a<='F')))
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	else
	{
		for(i=0; i<a.length; i++)
		{
			c=a.charAt(i);

			if(((c>='0')&&(c<='9'))||((c>='a')&&(c<='f'))||((c>='A')&&(c<='F')))
			{
				continue;
			}
			else
			{
				return false;
			}
		}
	}

	return true;
}

function convertBinary(a)
{
	var num1;
	var num2;
	var currnum;
	currnum = 128;
	num1=a;

	if(num1 >= currnum)		/* next bit is "1" */
	{
		if(countZero==0)		/* don't have a one yet */
		{
			num2 = "1";
			num1 = num1 - currnum;
			currnum = currnum / 2;
		}
		else
		{
			countZero=0;		/* Reset mask flag*/
			return false;
		}
	}
	else				/* next bit is "0" */
	{
		/* doesn't matter what u have before is zero or one */
		countZero=1;
		num2 = "0";
		currnum = currnum / 2;
	}

	for(p = 1; p <= 7; p++)
	{
		if(num1 >= currnum)	/* next bit is "1" */
		{
			if(countZero==0)		/*	have all ones*/
			{
				num2 = num2 + "1";
				num1 = num1 - currnum;
				currnum = currnum / 2;
			}
			else				/*have both a zero and one before hand*/
			{
				countZero=0;	/* Reset mask flag*/
				return false;
			}
		}
		else			/* next bit is "0" */
		{
			/* doesn't matter what u have before is zero or one */
			num2 = "0";
			countZero=1;
			currnum = currnum / 2;
		}
	}

	return true;
}
function check_ip_dst(ip,netmask)
{
	var i;
	var n;
	var m;
	var o;
	var flag1=0,flag2=0,flag3=0,flag4=0;

	if(ip.length > 0)
	{
		n = ip.split('.');
		if(n.length == 4)
		{
			if(n[0]==127)
			{
				return false;
			}

			if((isNaN(n[0]))||(n[0]<=0)||(n[0]>=224)||(isBlank(n[0]))||(isInitialZero(n[0]))||(!check_integer(n[0])))
			{
				return false;
			}
			if((isNaN(n[1]))||(n[1]<0)||(n[1]>255)||isBlank(n[1])||(isInitialZero(n[1]))||(!check_integer(n[1])))
			{
				return false;
			}
			if((isNaN(n[2]))||(n[2]<0)||(n[2]>255)||isBlank(n[2])||(isInitialZero(n[2]))||(!check_integer(n[2])))
			{
				return false;
			}
			if (n[3]==0)
				return true;
			else if((isNaN(n[3]))||(n[3]<0)||(n[3]>255)||isBlank(n[3])||(isInitialZero(n[3]))||(!check_integer(n[3])))
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}
	if (netmask)
	{
		if ((netmask.length < 0)||(ip.length<0))
		{
			return false
		}
		o = netmask.split('.');
		n = ip.split('.');
		if (n.length==4 && o.length==4)
		{
			if (((255-parseInt(o[0]))|(parseInt(n[0])))==parseInt(n[0]))
				flag1=1;
			if (((255-parseInt(o[1]))|(parseInt(n[1])))==parseInt(n[1]))
				flag2=1;
			if (((255-parseInt(o[2]))|(parseInt(n[2])))==parseInt(n[2]))
				flag3=1;
			if (((255-parseInt(o[3]))|(parseInt(n[3])))==parseInt(n[3]))
				flag4=1;
			if (flag1 && flag2 && flag3 && flag4)
				return false;
		}
	}
	return true;
}
function check_ip(ip,netmask)
{
	var i;
	var n;
	var m;
	var o;
	var flag1=0,flag2=0,flag3=0,flag4=0;

	if(ip.length > 0)
	{
		n = ip.split('.');
		if(n.length == 4)
		{
			if(n[0]==127)
			{
				return false;
			}

			if((isNaN(n[0]))||(n[0]<=0)||(n[0]>=240)||(isBlank(n[0]))||(isInitialZero(n[0]))||(!check_integer(n[0])))
			{
				return false;
			}
			if((isNaN(n[1]))||(n[1]<0)||(n[1]>255)||isBlank(n[1])||(isInitialZero(n[1]))||(!check_integer(n[1])))
			{
				return false;
			}
			if((isNaN(n[2]))||(n[2]<0)||(n[2]>255)||isBlank(n[2])||(isInitialZero(n[2]))||(!check_integer(n[2])))
			{
				return false;
			}
			if((isNaN(n[3]))||(n[3]<=0)||(n[3]>255)||isBlank(n[3])||(isInitialZero(n[3]))||(!check_integer(n[3])))
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}
	if (netmask)
	{
		if ((netmask.length < 0)||(ip.length<0))
		{
			return false
		}
		o = netmask.split('.');
		n = ip.split('.');
		if (n.length==4 && o.length==4)
		{
			if (((255-parseInt(o[0]))|(parseInt(n[0])))==parseInt(n[0]))
				flag1=1;
			if (((255-parseInt(o[1]))|(parseInt(n[1])))==parseInt(n[1]))
				flag2=1;
			if (((255-parseInt(o[2]))|(parseInt(n[2])))==parseInt(n[2]))
				flag3=1;
			if (((255-parseInt(o[3]))|(parseInt(n[3])))==parseInt(n[3]))
				flag4=1;
			if (flag1 && flag2 && flag3 && flag4)
				return false;
		}
	}
	return true;
}

function check_ip_range(ip,netmask)
{
	var i;
	var n;
	var m;
	var o;
	var flag1=0,flag2=0,flag3=0,flag4=0;

	if(ip.length > 0)
	{
		n = ip.split('.');
		if (netmask && !check_netmask(netmask) )
			return false;
		if (netmask && netmask.length > 0)
			o = netmask.split('.');
		if(n.length == 4)
		{
			if(n[0]==127)
			{
				return false;
			}

			if((isNaN(n[0]))||(n[0]<=0)||(n[0]>=240)||(isBlank(n[0]))||(isInitialZero(n[0]))||(!check_integer(n[0])))
			{
				return false;
			}
			if((isNaN(n[1]))||(n[1]<0)||(n[1]>255)||isBlank(n[1])||(isInitialZero(n[1]))||(!check_integer(n[1])))
			{
				return false;
			}
			if((isNaN(n[2]))||(n[2]<0)||(n[2]>255)||isBlank(n[2])||(isInitialZero(n[2]))||(!check_integer(n[2])))
			{
				return false;
			}
			if((isNaN(n[3]))||(n[3]<0)||(!netmask&&n[3]==0)||(o.length==4&&o[3]==255&&n[3]==0)||(n[3]>255)||isBlank(n[3])||(isInitialZero(n[3]))||(!check_integer(n[3])))
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}
	if (netmask)
	{
		if ((netmask.length < 0)||(ip.length<0))
		{
			return false
		}
		o = netmask.split('.');
		n = ip.split('.');
		if (n.length==4 && o.length==4 && !(o[0]==255&&o[1]==255&&o[2]==255&&o[3]==255))
		{
			if (((255-parseInt(o[0]))|(parseInt(n[0])))==parseInt(n[0]))
				flag1=1;
			if (((255-parseInt(o[1]))|(parseInt(n[1])))==parseInt(n[1]))
				flag2=1;
			if (((255-parseInt(o[2]))|(parseInt(n[2])))==parseInt(n[2]))
				flag3=1;
			if (((255-parseInt(o[3]))|(parseInt(n[3])))==parseInt(n[3]))
				flag4=1;
			if (flag1 && flag2 && flag3 && flag4)
				return false;
		}
	}
	return true;
}

// Convert a subnet mask array into CIDR (# of bits) (255.255.255.0 = 24 etc.)
function mask2cidr(aMask)
{
	var mask = octet2dec(aMask);
	// get binary string
	var mask_2 = parseInt(mask, 10).toString(2);
	// return mask length
	if ( mask_2.indexOf(0) < 0 )
		return "32";
	else
		return mask_2.indexOf(0);
}
// Convert our array of 4 ints into a decimal (watch out for 16 bit JS integers here)
function octet2dec(a)
{
	var a_s = a.split(".");
	var d = 0;
	d = d + parseInt(a_s[0]) * 16777216 ;	//Math.pow(2,24);
	d = d + parseInt(a_s[1]) * 65536;		//Math.pow(2,16);
	d = d + parseInt(a_s[2]) * 256;			//Math.pow(2,8);
	d = d + parseInt(a_s[3]);
	return d;
}
// check whether the str is a right IPv6 address
function checkIPv6(str)
{
	var idx = str.indexOf("::");
	// there is no "::" in the ip address
	if (idx == -1)
	{
		var items = str.split(":");
		if (items.length != 8)
		{
			return false;
		}
		else
		{
			for (i in items)
			{
				if (!isHex(items[i]))
				{
					return false;
				}
			}
			return true;
		}
	}
	else
	{
		// at least, there are two "::" in the ip address
		if (idx != str.lastIndexOf("::"))
		{
			return false;
		}
		else
		{
			var items = str.split("::");
			var items0 = items[0].split(":");
			var items1 = items[1].split(":");
			if ((items0.length + items1.length) > 7)
			{
				return false;
			}
			else
			{
				for (i in items0)
				{
					if (!isHex(items0[i])) {return false;}
				}
				for (i in items1)
				{
					if (!isHex(items1[i])) {return false;}
				}
				return true;
			}
		}
	}
}

// check whether every char of the str is a Hex char(0~9,a~f,A~F)
function isHex(str)
{
	if(str.length == 0 || str.length > 4) {return false;}
	str = str.toLowerCase();
	var ch;
	for(var i=0; i< str.length; i++)
	{
		ch = str.charAt(i);
		if(!(ch >= '0' && ch <= '9') && !(ch >= 'a' && ch <= 'f')) {return false;}
	}
	return true;
}

function check_gateway(gateway,netmask)
{
	if(gateway == '0.0.0.0')
		return true;

	if ( !check_ip(gateway,netmask) )
		return false;
	else
		return true;
}


function check_gateway2(gateway,netmask,ip)
{
	if(gateway == '0.0.0.0')
		return true;

	gateway = gateway.split(".");
	netmask = netmask.split(".");
	ip = ip.split(".");

	var gw_mask = (gateway[0]&netmask[0])+"."+(gateway[1]&netmask[1])+"."+(gateway[2]&netmask[2])+"."+(gateway[3]&netmask[3]);
	var ip_mask = (ip[0]&netmask[0])+"."+(ip[1]&netmask[1])+"."+(ip[2]&netmask[2])+"."+(ip[3]&netmask[3]);

	if (gw_mask != ip_mask )
		return false;
	else
		return true;
}

function check_netmask(mask)
{
	var i;
	var n;
	var temp;

	countZero=0;

	if(mask.length > 0)
	{
		n=mask.split('.');

		if(n.length==4)
		{
			for(i=0; i<4; i++)
			{
				if((isNaN(n[i]))||(n[0]<128)||(n[i]>255)||(isBlank(n[i]))||(isInitialZero(n[i]))||(!check_integer(n[i])))
				{
					return false;
				}
			}

			if((convertBinary(n[0]))&&(convertBinary(n[1]))&&(convertBinary(n[2]))&&(convertBinary(n[3])))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}

	return true;
}

function check_mac_plus(mac)
{
	var i;
	var n;
	var count=0;
	var ff_valid=0;
	var zero_valid=0;
	var odd_valid=0;
	var valid=0;
	var odd_array="02468AaCcEe";



	if(mac.length > 0)
	{
		n = mac.split(':');

		if(n.length==6)
		{
			if (n[0]!="*")
			{
				for (i=0;i<odd_array.length;i++)
				{
					if (n[0].charAt(1) == odd_array.charAt(i))
						odd_valid=1;
					else
						continue;
				}
			}
			else
				odd_valid=1;

				for(i=0; i<6; i++)
				{
					if (n[i]=="*")
					{
						count++;
						if (count>5)
							return false;

						continue;
					}
					else
					{
						if((isBlank(n[i]))||(!check_0Tof(n[i]))||(n[i].length != 2))
						{
							return false;
						}
					}
				}

				for(i=0; i<6; i++)
				{
					if(((n[i].charAt(0)=='f')||(n[i].charAt(0)=='F'))&&((n[i].charAt(1)=='f')||(n[i].charAt(1)=='F')))
					{
						continue;
					}
					else
					{
						ff_valid=1;
						break;
					}
				}

			for(i=0; i<6; i++)
				{
					if((n[i].charAt(0)=='0')&&(n[i].charAt(1)=='0'))
					{
						continue;
					}
					else
					{
						zero_valid=1;
						break;
					}
				}
				if((ff_valid==1)&&(zero_valid==1)&&(odd_valid==1))
				{
					return true;
				}
				else
				{
					return false;
				}
		}
		return false;
	}
	return true;
}

function check_mac(mac)
{
	var i;
	var n;
	var ff_valid=0;
	var zero_valid=0;
	var odd_valid=0;
	var valid=0;
	var odd_array="02468AaCcEe";

	if(mac.length > 0)
	{
		n = mac.split(':');

		if(n.length==6)
		{
			for (i=0;i<odd_array.length;i++)
			{
				if (n[0].charAt(1) == odd_array.charAt(i))
					odd_valid=1;
				else
					continue;
			}


			for(i=0; i<6; i++)
			{
				if((isBlank(n[i]))||(!check_0Tof(n[i]))||(n[i].length != 2))
				{
					return false;
				}
			}

			for(i=0; i<6; i++)
			{
				if(((n[i].charAt(0)=='f')||(n[i].charAt(0)=='F'))&&((n[i].charAt(1)=='f')||(n[i].charAt(1)=='F')))
				{
					continue;
				}
				else
				{
					ff_valid=1;
					break;
				}
			}

			for(i=0; i<6; i++)
			{
				if((n[i].charAt(0)=='0')&&(n[i].charAt(1)=='0'))
				{
					continue;
				}
				else
				{
					zero_valid=1;
					break;
				}
			}

			if((ff_valid==1)&&(zero_valid==1)&&(odd_valid==1))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}

	return true;
}

function check_port(a)
{
	if(a.length > 0)
	{
		if((isNaN(a))||(a<1)||(a>65535)||(!check_integer(a))||(isInitialZero(a)))
		{
			return false;
		}
	}

	return true;
}

function check_integer_range(inputValue, minValue, maxValue)
{
	if(inputValue.length > 0)
	{
		if((!check_integer(inputValue))||(inputValue<minValue)||(inputValue>maxValue)||(isInitialZero(inputValue)))
		{
			return false;
		}
	}

	return true;
}

function check_num_range(inputValue, minValue, maxValue)
{
	if(inputValue.length > 0)
	{
		if((inputValue<minValue)||(inputValue>maxValue)||(isInitialZero(inputValue)))
		{
			return false;
		}
	}

	return true;
}

function check_overlap(s, e, s_ed, e_ed)
{
	if(((parseInt(s)>=parseInt(s_ed))&&(parseInt(s)<=parseInt(e_ed)))||((parseInt(e)>=parseInt(s_ed))&&(parseInt(e)<=parseInt(e_ed))))
	{
		return false;
	}

	if(((parseInt(s_ed)>=parseInt(s))&&(parseInt(s_ed)<=parseInt(e)))||((parseInt(e_ed)>=parseInt(s))&&(parseInt(e_ed)<=parseInt(e))))
	{
		return false;
	}

	return true;
}

function merge_ip(target, item1, item2, item3, item4)
{
	var target_item=document.getElementById(target);
	var value1=document.getElementById(item1).value;
	var value2=document.getElementById(item2).value;
	var value3=document.getElementById(item3).value;
	var value4=document.getElementById(item4).value;
	target_item.value=value1+"."+value2+"."+value3+"."+value4;

	if(target_item.value=="...")
		target_item.value="";

	return true;
}

function merge_mac(target, item1, item2, item3, item4, item5, item6)
{
	var target_item=document.getElementById(target);
	var value1=document.getElementById(item1).value;
	var value2=document.getElementById(item2).value;
	var value3=document.getElementById(item3).value;
	var value4=document.getElementById(item4).value;
	var value5=document.getElementById(item5).value;
	var value6=document.getElementById(item6).value;
	target_item.value=value1+":"+value2+":"+value3+":"+value4+":"+value5+":"+value6;

  if(target_item.value==":::::")
	target_item.value="";

	return true;
}
/*function getlink(pn,aq,ae,am,av,at,ai,ar,au)
{
	return pn+ ".html?_aq=" + aq + ";_ae=" + ae + ";_am="
			+ am + ";_av=" + av + ";_at=" + at + ";_ai=" + ai + ";_ar=" + ar + ";_au=" + au + ";";
}*/
function getlink_add(pn,aq,ae,am,av,at,ai,ar,au,aa)
{
	return "wwwctrl.cgi?action="+pn+ "&_aq=" + aq + "&_ae=" + ae + "&_am="
			+ am + "&_av=" + av + "&_at=" + at + "&_ai=" + ai + "&_ar=" + ar + "&_au=" + au + "&_aa="+ aa + "&";
}
//url = getlink("wan_route_static",sb,svt,svi,svp,s8,si,sn,sg,sd1,sd2,sd3,smt,sm,au,aa);
function getlink_static_edit(pn,sb,svt,svi,svp,s8,si,sn,sg,sd1,sd2,sd3,smt,sm,au,aa,ab,an,aw)
{
	return "wwwctrl.cgi?action="+pn+ "&_sb=" + sb + "&_svt=" + svt + "&_svi="
			+ svi + "&_svp=" + svp + "&_s8=" + s8 + "&_si=" + si + "&_sn=" + sn + "&_sg="
			+ sg + "&_sd1="+ sd1 + "&_sd2=" + sd2 + "&_sd3=" + sd3 + "&_smt="+ smt + "&_sm="
			+ sm + "&_au=" + au + "&_aa="+ aa + "&_ab="+ ab + "&_an="+ an +"&_aw="+ aw +"&";
}
//url = getlink("wan_route_dhcp",db,dvt,dvi,dvp,d8,dh,dv,dc,dmt,dm,au,aa,ab,an,aw);
function getlink_dhcp_edit(pn,db,dvt,dvi,dvp,d8,dh,do60en,do60vid,do61en,do61mac,do61iaid,do61duid,do125en,do125enum,do125oui,do125pdc,do125mn,do125snum,dmt,dm,au,aa,ab,an)
{
	return "wwwctrl.cgi?action="+pn+ "&_db=" + db + "&_dvt=" + dvt + "&_dvi=" + dvi + "&_dvp="
			+ dvp + "&_d8=" + d8 + "&_dh=" + dh + "&_do60en=" + do60en + "&_do60vid=" + do60vid + "&_do61en="
			+ do61en + "&_do61mac=" + do61mac + "&_do61iaid=" + do61iaid + "&_do61duid="
			+ do61duid + "&_do125en=" + do125en + "&_do125enum=" + do125enum + "&_do125oui="
			+ do125oui + "&_do125pdc=" + do125pdc + "&_do125mn=" + do125mn + "&_do125snum=" + do125snum + "&_dmt="
			+ dmt + "&_dm="	+ dm + "&_au=" + au + "&_aa="+ aa + "&_ab="+ ab +"&_an="+ an +"&_aw="+ aw +"&";
}
//url = getlink("wan_route_pppoe",pb,pvt,pvi,pvb,pu,pp,pac,ps,pi,pc,pd,pa,pmt,pm,au,aa,ab);
//url = getlink("wan_route_pppoe",pb,pvt,pvi,pvb,pu,pp,pac,ps,pi,pc,pd,pa,pmt,pm,au,aa,ab);
function getlink_pppoe_edit(pn,pb,pvt,pvi,pvb,pu,pp,pac,ps,pi,pc,pd,pa,pmt,pm,au,aa,ab,ppa,an,aw)
{
	return "wwwctrl.cgi?action="+pn+ "&_pb=" + pb + "&_pvt=" + pvt + "&_pvi="
			+ pvi + "&_pvb=" + pvb + "&_pu=" + pu + "&_pp=" + pp + "&_pac=" + pac + "&_ps=" + ps + "&_pi="+ pi + "&_pc="
			+ pc + "&_pd=" + pd + "&_pa=" + pa + "&_pmt=" + pmt + "&_pm=" + pm + "&_au=" + au + "&_aa="+ aa + "&_ab="+ ab +"&_ppa=" + ppa +"&_an="+ an +"&_aw="+ aw +"&";
}

function getlink_bridge_edit(pn,bvi,bvb,bup,bo,bet,bsm,bsmm,bdm,bdmm,bsi,bsim,bdi,bdim,bipp,bsp,bdp,bten,btid,btpb,au,aa,ab)
{
	return "wwwctrl.cgi?action="+pn+ "&_bvi=" + bvi + "&_bvb=" + bvb + "&_bup="
			+ bup + "&_bo=" + bo + "&_bet=" + bet + "&_bsm=" + bsm + "&_bsmm=" + bsmm + "&_bdm=" + bdm + "&_bdmm="+ bdmm + "&_bsi="
			+ bsi + "&_bsim=" + bsim + "&_bdi=" + bdi + "&_bdim=" + bdim + "&_bipp=" + bipp + "&_bsp=" + bsp + "&_bdp="
			+ bdp + "&_bten=" + bten + "&_btid=" + btid + "&_btpb=" + btpb + "&_au=" + au + "&_aa="+ aa + "&_ab="+ ab +"&";
}

function setbindport()
{
	var i;
	var wifi_num=ssidNum;//fanny edit 2012/05/29 NvramGet(WIFISsidnum) to ssidNum
	for(i=1;i<=4;i++)
	{
		lport=document.getElementById("id_tmplanport"+i).value;
		//fanny edit 2012/05/23 add	 check disabled
		if (document.getElementById("id_tmplanport"+i).disabled==true)
			document.getElementById("id_lanport"+i).value="0";
		else
			//document.getElementById("id_lanport"+i).value=(document.getElementById("id_tmplanport"+i).checked)?1:"0";
			document.getElementById("id_lanport"+i).value=(document.getElementById("id_tmplanport"+i).checked)?i:"0";
	}
	for(i=1;i<=wifi_num;i++)//fanny edit 2012/05/23 wifi_num to 4
	{
		wlport=document.getElementById("id_tmpwlanport"+i).value;
		//fanny edit 2012/05/23 add	 check disabled
		if (document.getElementById("id_tmpwlanport"+i).disabled==true)
			document.getElementById("id_wlanport"+i).value="0";
		else
			//document.getElementById("id_wlanport"+i).value=(document.getElementById("id_tmpwlanport"+i).checked)?1:"0";
			document.getElementById("id_wlanport"+i).value=(document.getElementById("id_tmpwlanport"+i).checked)?i:"0";
	}

}

function enableVlan(name)
{
	var obj=document.getElementById("id_chk" + name + "VlanId");
	var textname="id_" + name + "VlanId";
	var textname_pbit="id_" + name + "PBit";//Fanny add 2012/04/24
	if (obj.checked)
	{
		document.getElementById(textname).disabled=false;
		document.getElementById(textname_pbit).disabled=false;//Fanny add 2012/04/24
		if(name=="Br")
			document.getElementById("id_"+name+"QoSCosValue").disabled=false;
	}
	else
	{
		document.getElementById(textname).value="";
		document.getElementById(textname).disabled=true;
		document.getElementById(textname_pbit).value="";
		document.getElementById(textname_pbit).disabled=true;
		if(name=="Br")
		{
			document.getElementById("id_"+name+"QoSCosValue").value="";
			document.getElementById("id_"+name+"QoSCosValue").disabled=true;
		}
	}

}

function enableADSLVlan(name)
{
	var obj=document.getElementById("id_chk" + name + "VlanId");
	var textname="id_" + name + "VlanId";
	if (obj.checked)
	{
		document.getElementById(textname).disabled=false;
	}
	else
	{
		document.getElementById(textname).value="";
		document.getElementById(textname).disabled=true;
	}
}

function disableQMT(val)
{
	var val2=false;
	var val3=false;
	//document.getElementById("id_QM_queue").disabled = val;
	document.getElementById("id_QMT_item0").disabled = val;
	document.getElementById("id_QMT_item1").disabled = val;
	document.getElementById("id_QMT_item2").disabled = val;
	//if (!val)
	//{
		if (!document.getElementById("id_QMT_item1").checked)
			val2=true;

		if (!document.getElementById("id_QMT_item2").checked)
			val3=true;
	//}
	document.getElementById("id_QMT_tos").disabled = val2;
	document.getElementById("id_QMT_dscp").disabled = val3;
}

function disableLanQMT(val)
{
	var val2=false;
	var val3=false;
	document.getElementById("id_LanQMT_item0").disabled = val;
	document.getElementById("id_LanQMT_item1").disabled = val;
	document.getElementById("id_LanQMT_item2").disabled = val;
	if (!document.getElementById("id_LanQMT_item1").checked)
		val2=true;

	if (!document.getElementById("id_LanQMT_item2").checked)
		val3=true;
	document.getElementById("id_LanQMT_tos").disabled = val2;
	document.getElementById("id_LanQMT_dscp").disabled = val3;
}

function QoSMappingChange(wan_type)
{
	if (document.getElementById("id_QM_item0").checked)
		document.getElementById("id_QM_queue").disabled = true;
	else
		document.getElementById("id_QM_queue").disabled = false;

	disableQMT(false);
	QoSCosChange(wan_type);
}

function QoSLanMappingChange()
{
	if (document.getElementById("id_LanQM_item0").checked)
		document.getElementById("id_LanQM_queue").disabled = true;
	else
		document.getElementById("id_LanQM_queue").disabled = false;
	//disableLanQMT(false);
}

function QoSCosChange(wan_type)
{
	var vlan_nvenable="VLAN";
	var vlan_selected=0;
	if (wan_type!="" && wan_type!='policy')
	{
		if(document.getElementById("id_chk"+wan_type+"VlanId").checked == true)
			vlan_selected=1;
	}
	if ((vlan_nvenable=="ROUTE")&&(vlan_selected==0))
	{
		document.getElementById("id_QMC_item2").disabled = false;
		document.getElementById("id_QMC_item2").checked = true;
		document.getElementById("id_QMC_item1").disabled = true;
		document.getElementById("id_QMC_item0").disabled = true;
		document.getElementById("id_QMC_value").disabled=true;
	}
	else
	{
		document.getElementById("id_QMC_item1").disabled = false;
		document.getElementById("id_QMC_item2").disabled = false;
		/*
		if (document.getElementById("id_QM_item1").checked)
		{
			document.getElementById("id_QMC_item0").disabled = true;
			if (document.getElementById("id_QMC_item0").checked==true)
			{
				document.getElementById("id_QMC_item1").checked=true;
				document.getElementById("id_QMC_value").disabled=false;
			}
			else if(document.getElementById("id_QMC_item1").checked==true)
				document.getElementById("id_QMC_value").disabled=false;
			else
				document.getElementById("id_QMC_value").disabled=true;
		}
		else
		{
			*/
			document.getElementById("id_QMC_item0").disabled = false;
			if (document.getElementById("id_QMC_item1").checked)
				document.getElementById("id_QMC_value").disabled=false;
			else
				document.getElementById("id_QMC_value").disabled=true;
		//}
	}

}

function check_item(pb1,pb2,pb3,pb4,pb5,pb6,pb7,pb8)
{
	var obj1=0,obj2=0,obj3=0,obj4=0,obj5=0,obj6=0,obj7=0,obj8=0;
	var vb;
	var item,min,max;
	if (document.getElementById("id_QM_item0").checked)
		obj1 = 0;
	else
		obj1 = 1;

	if (obj1)
	{
		obj2=document.getElementById("id_QM_queue").value;
		vb=document.getElementById("id_QM_queue");
		if (!check_integer_range(obj2,0,7) || obj2.length==0)
		{
			object="Qos Upstream Classification";
			section="Specified Queue";
			min = 0;
			max = 7;
			warn_int_betweenQosU(section,min,max);
			//alert("Input value of "+ object + " in "+ section +" should be an integer between "+min+" and "+max);
			vb.focus();
			return false;
		}
	}
	if (document.getElementById("id_QMT_item0").checked)
		obj3=0;
	else if (document.getElementById("id_QMT_item1").checked)
	{
		obj3 = 1;
		obj4 = document.getElementById("id_QMT_tos").value;
		vb = document.getElementById("id_QMT_tos");
		if (!check_integer_range(obj4,0,7) || obj4.length==0)
		{
			object="Qos Upstream Classification";
			section="New ToS value";
			min = 0;
			max = 7;
			warn_int_betweenQosU(section,min,max);
			//alert("Input value of "+ object + " in "+ section +" should be an integer between "+min+" and "+max);
			vb.focus();
			return false;
		}
	}
	else
	{
		obj3 = 2;
		obj5 = document.getElementById("id_QMT_dscp").value;
		vb = document.getElementById("id_QMT_dscp");
		if (!check_integer_range(obj5,0,63) || obj5.length==0)
		{
			object="Qos Upstream Classification";
			section="New DSCP value";
			min = 0;
			max = 63;
			warn_int_betweenQosU(section,min,max);
			//alert("Input value of "+ object + " in "+ section +" should be an integer between "+min+" and "+max);
			vb.focus();
			return false;
		}
	}

	if (pb6!=0&&pb7!=0&&pb8!=0)
	{
		if (document.getElementById("id_QMC_item2").checked==true)
			obj6 = 0;
		else
			obj6 = 1;

		if (document.getElementById("id_QMC_item0").checked)
			obj7=2;
		else if(document.getElementById("id_QMC_item2").checked)
			obj7=0;
		else
		{
			obj7 = 1;
			obj8 = document.getElementById("id_QMC_value").value;
			vb = document.getElementById("id_QMC_value");
			if (!check_integer_range(obj8,0,7) || obj8.length==0)
			{
				object="Qos Upstream Classification";
				section="New CoS value";
				min = 0;
				max = 7;
				warn_int_betweenQosU(section,min,max);
				//alert("Input value of "+ object + " in "+ section +" should be an integer between "+min+" and "+max);
				vb.focus();
				return false;
			}
		}
		pb6.value=obj7;
		//pb7.value=obj7;
		pb8.value=obj8;
	}
	pb1.value=obj1;
	pb2.value=obj2;
	pb3.value=obj3;
	pb4.value=obj4;
	pb5.value=obj5;

	return true;
}

function check_Lanitem(pb1,pb2,pb3,pb4,pb5)
{
	var obj1=0,obj2=0,obj3=0,obj4=0,obj5=0;
	var vb;
	var item,min,max;
	if (document.getElementById("id_LanQM_item0").checked)
		obj1 = 0;
	else
		obj1 = 1;

	if (obj1)
	{
		obj2=document.getElementById("id_LanQM_queue").value;
		vb=document.getElementById("id_LanQM_queue");
		if (!check_integer_range(obj2,0,7) || obj2.length==0)
		{
			object="QoS Downstream Classification";
			section="Specified Queue";
			min = 0;
			max = 7;
			warn_int_betweenQosD(section,min,max);
			//alert("Input value of "+ object + " in "+ section +" should be an integer between "+min+" and "+max);
			vb.focus();
			return false;
		}
	}
	if (document.getElementById("id_LanQMT_item0").checked)
		obj3=0;
	else if (document.getElementById("id_LanQMT_item1").checked)
	{
		obj3 = 1;
		obj4 = document.getElementById("id_LanQMT_tos").value;
		vb = document.getElementById("id_LanQMT_tos");
		if (!check_integer_range(obj4,0,7) || obj4.length==0)
		{
			object="QoS Downstream Classification";
			section="New ToS value";
			min = 0;
			max = 7;
			warn_int_betweenQosD(section,min,max);
			//	alert("Input value of "+ object + " in "+ section +" should be an integer between "+min+" and "+max);
			vb.focus();
			return false;
		}
	}
	else
	{
		obj3 = 2;
		obj5 = document.getElementById("id_LanQMT_dscp").value;
		vb = document.getElementById("id_LanQMT_dscp");
		if (!check_integer_range(obj5,0,63) || obj5.length==0)
		{
			object="QoS Downstream Classification";
			section="New DSCP value";
			min = 0;
			max = 63;
			warn_int_betweenQosD(section,min,max);
			//alert("Input value of "+ object + " in "+ section +" should be an integer between "+min+" and "+max);
			vb.focus();
			return false;
		}
	}

	pb1.value=obj1;
	pb2.value=obj2;
	pb3.value=obj3;
	pb4.value=obj4;
	pb5.value=obj5;
	return true;
}

function check_item_adv()
{
	var obj1=0,obj2=0,obj3=0,obj4=0,obj5=0,obj6=0,obj7=0,obj8=0;
	var vb;
	var item,min,max;
	if (document.getElementById("id_QM_item0").checked)
		obj1 = 0;
	else
		obj1 = 1;

	if (obj1)
	{
		obj2=document.getElementById("id_QM_queue").value;
		vb=document.getElementById("id_QM_queue");
		if (!check_integer_range(obj2,0,7) || obj2.length==0)
		{
			object="Qos Upstream Classification";
			section="Specified Queue";
			min = 0;
			max = 7;
			warn_int_betweenQosU(section,min,max);
			//alert("Input value of "+ object + " in "+ section +" should be an integer between "+min+" and "+max);
			vb.focus();
			return false;
		}
	}
	if (document.getElementById("id_QMT_item0").checked)
		obj3=0;
	else if (document.getElementById("id_QMT_item1").checked)
	{
		obj3 = 1;
		obj4 = document.getElementById("id_QMT_tos").value;
		vb = document.getElementById("id_QMT_tos");
		if (!check_integer_range(obj4,0,7) || obj4.length==0)
		{
			object="Qos Upstream Classification";
			section="New ToS value";
			min = 0;
			max = 7;
			warn_int_betweenQosU(section,min,max);
			//alert("Input value of "+ object + " in "+ section +" should be an integer between "+min+" and "+max);
			vb.focus();
			return false;
		}
	}
	else
	{
		obj3 = 2;
		obj5 = document.getElementById("id_QMT_dscp").value;
		vb = document.getElementById("id_QMT_dscp");
		if (!check_integer_range(obj5,0,63) || obj5.length==0)
		{
			object="Qos Upstream Classification";
			section="New DSCP value";
			min = 0;
			max = 63;
			warn_int_betweenQosU(section,min,max);
			//alert("Input value of "+ object + " in "+ section +" should be an integer between "+min+" and "+max);
			vb.focus();
			return false;
		}
	}

	if (document.getElementById("id_QMC_item2").checked==true)
		obj6 = 0;
	else
		obj6 = 1;

	if (document.getElementById("id_QMC_item0").checked)
		obj7=0;
	else if(document.getElementById("id_QMC_item2").checked)
		obj7=2;
	else
	{
		obj7 = 1;
		obj8 = document.getElementById("id_QMC_value").value;
		vb = document.getElementById("id_QMC_value");
		if (!check_integer_range(obj8,0,7) || obj8.length==0)
		{
			object="Qos Upstream Classification";
			section="New CoS value";
			min = 0;
			max = 7;
			warn_int_betweenQosU(section,min,max);
			//alert("Input value of "+ object + " in "+ section +" should be an integer between "+min+" and "+max);
			vb.focus();
			return false;
		}
	}
	return true;
}

function check_Lanitem_adv()
{
	var obj1=0,obj2=0,obj3=0,obj4=0,obj5=0;
	var vb;
	var item,min,max;
	if (document.getElementById("id_LanQM_item0").checked)
		obj1 = 0;
	else
		obj1 = 1;

	if (obj1)
	{
		obj2=document.getElementById("id_LanQM_queue").value;
		vb=document.getElementById("id_LanQM_queue");
		if (!check_integer_range(obj2,0,7) || obj2.length==0)
		{
			object="QoS Downstream Classification";
			section="Specified Queue";
			min = 0;
			max = 7;
			warn_int_betweenQosD(section,min,max);
			//alert("Input value of "+ object + " in "+ section +" should be an integer between "+min+" and "+max);
			vb.focus();
			return false;
		}
	}
	if (document.getElementById("id_LanQMT_item0").checked)
		obj3=0;
	else if (document.getElementById("id_LanQMT_item1").checked)
	{
		obj3 = 1;
		obj4 = document.getElementById("id_LanQMT_tos").value;
		vb = document.getElementById("id_LanQMT_tos");
		if (!check_integer_range(obj4,0,7) || obj4.length==0)
		{
			object="QoS Downstream Classification";
			section="New ToS value";
			min = 0;
			max = 7;
			warn_int_betweenQosD(section,min,max);
			//alert("Input value of "+ object + " in "+ section +" should be an integer between "+min+" and "+max);
			vb.focus();
			return false;
		}
	}
	else
	{
		obj3 = 2;
		obj5 = document.getElementById("id_LanQMT_dscp").value;
		vb = document.getElementById("id_LanQMT_dscp");
		if (!check_integer_range(obj5,0,63) || obj5.length==0)
		{
			object="QoS Downstream Classification";
			section="New DSCP value";
			min = 0;
			max = 63;
			warn_int_betweenQosD(section,min,max);
			//alert("Input value of "+ object + " in "+ section +" should be an integer between "+min+" and "+max);
			vb.focus();
			return false;
		}
	}
	return true;
}

function ADSLQoSMappingChange()
{
	if (document.getElementById("id_QM_item0").checked)
		document.getElementById("id_QM_queue").disabled = true;
	else
		document.getElementById("id_QM_queue").disabled = false;
	disableQMT(false);
}

function ADSLcheck_item_adv()
{
	var obj1=0,obj2=0,obj3=0,obj4=0,obj5=0;
	var vb;
	var item,min,max;
	if (document.getElementById("id_QM_item0").checked)
		obj1 = 0;
	else
		obj1 = 1;

	if (obj1)
	{
		obj2=document.getElementById("id_QM_queue").value;
		vb=document.getElementById("id_QM_queue");
		if (!check_integer_range(obj2,0,7) || obj2.length==0)
		{
			object="Qos Upstream Classification";
			section="Specified Queue";
			min = 0;
			max = 7;
			warn_int_betweenQosU(section,min,max);
			//alert("Input value of "+ object + " in "+ section +" should be an integer between "+min+" and "+max);
			vb.focus();
			return false;
		}
	}
	if (document.getElementById("id_QMT_item0").checked)
		obj3=0;
	else if (document.getElementById("id_QMT_item1").checked)
	{
		obj3 = 1;
		obj4 = document.getElementById("id_QMT_tos").value;
		vb = document.getElementById("id_QMT_tos");
		if (!check_integer_range(obj4,0,7) || obj4.length==0)
		{
			object="Qos Upstream Classification";
			section="New ToS value";
			min = 0;
			max = 7;
			warn_int_betweenQosU(section,min,max);
			//alert("Input value of "+ object + " in "+ section +" should be an integer between "+min+" and "+max);
			vb.focus();
			return false;
		}
	}
	else if (document.getElementById("id_QMT_item2").checked)
	{
		obj3 = 2;
		obj5 = document.getElementById("id_QMT_dscp").value;
		vb = document.getElementById("id_QMT_dscp");
		if (!check_integer_range(obj5,0,63) || obj5.length==0)
		{
			object="Qos Upstream Classification";
			section="New DSCP value";
			min = 0;
			max = 63;
			warn_int_betweenQosU(section,min,max);
			//alert("Input value of "+ object + " in "+ section +" should be an integer between "+min+" and "+max);
			vb.focus();
			return false;
		}
	}
	return true;
}

function check_ADSLParameter(Wan_type)
{
	var item = new Array ("VPI","VCI","QoSMaxPCR", "QoSPCR", "QoSBurst", "QoSCDVT");
	var item_name = new Array ("!###!","!###!",
			"!###!","!###!",
			"!###!", "!###!" );
	var item_mix = new Array (0,32,40,40,0,0 );
	var item_max = new Array (255,65535,26000,26000,60000000,60000000);
	var check_flag=0;

	for (i=0;i<6;i++)
	{
		var item_value=document.getElementById("id_"+Wan_type+item[i]).value;

		if(document.getElementById("id_"+Wan_type+"QoSType").value=="cbr" && (i==3 || i==4))
			check_flag++;
		else
			check_flag=0;

		if (!check_flag)
		{
			if((document.getElementById("id_"+Wan_type+"QoSType").value=="ubr")&&(i!=2))
			{
				if (item_value.length==0)
				{
					item=item_name[i];
					warn_not_empty(item);
					//alert(item+" can't be empty!");
					return false;
				}
			}

			if(!check_integer_range(item_value,item_mix[i],item_max[i]))
			{
					item =item_name[i];
					msg = "";
					min = item_mix[i];
					max = item_max[i];
					warn_int_between(item,min,max);
					//alert(msg +" "+item+" should be an integer between "+min+" and "+max);
					return false;
			}
		}
	}
	if ((Wan_type!="IPv6Over")||(Wan_type=="Br"))
	{
		var WNum=document.getElementById("id_PVCNum").value;
		var nowVPC=document.getElementById("id_"+Wan_type+"VPI").value+","+document.getElementById("id_"+Wan_type+"VCI").value;

		if (Wan_type=="Br")
		{
			for (i=1;i<=WNum;i++)
			{
				if (nowVPC==document.getElementById("id_chkPVC"+i).value)
				{

					if (r_macbased==1)
					{
						if (document.getElementById("id_TblAdslBrPolicyType"+i).value=="Default")
						{
							item="!###!";
							warn_rule_conflict(item);
							//alert("The "	+ item + " of new rule is conflicted with current rules");
							return false;
						}
					}
					else
					{
						item="!###!";
						warn_rule_conflict(item);
						//	alert("The "  + item + " of new rule is conflicted with current rules");
						return false;
					}
				}
			}
		}
		else
		{
			for (i=1;i<=WNum;i++)
			{
				if (nowVPC==document.getElementById("id_chkPVC"+i).value)
				{
					item="!###!";
					warn_rule_conflict(item);
					//alert("The "	+ item + " of new rule is conflicted with current rules");
					return false;
				}
			}
		}
	}
	return true;
}

function changePolicy()
{
	var i=0;
	document.getElementById("id_dhcp60").disabled=true;
	document.getElementById("id_ethType").disabled=true;
	document.getElementById("id_srcmac").disabled=true;
	document.getElementById("id_dstmac").disabled=true;
	for (i=0;i<=5;i++)
		document.getElementById("id_srcmac_item" +i).disabled=true;
	for (i=0;i<=5;i++)
		document.getElementById("id_dstmac_item" +i).disabled=true;
	if (document.getElementById("id_tmpPB1").checked)
		document.getElementById("id_dhcp60").disabled=false;
	else if (document.getElementById("id_tmpPB2").checked)
		document.getElementById("id_ethType").disabled=false;
	else if (document.getElementById("id_tmpPB3").checked)
	{
		document.getElementById("id_srcmac").disabled=false;
		for (i=0;i<=5;i++)
			document.getElementById("id_srcmac_item" +i).disabled=false;
	}
	else if (document.getElementById("id_tmpPB4").checked)
		{
			document.getElementById("id_dstmac").disabled=false;
			for (i=0;i<=5;i++)
				document.getElementById("id_dstmac_item" +i).disabled=false;
		}
}

function set_QosParamenter(wan_type)
{
	if (document.getElementById("id_"+wan_type+"QoSType").value=="cbr")
	{
		document.getElementById("id_"+wan_type+"QoSPCR").value="";
		document.getElementById("id_"+wan_type+"QoSPCR").disabled=true;
		document.getElementById("id_"+wan_type+"QoSBurst").value="";
		document.getElementById("id_"+wan_type+"QoSBurst").disabled=true;
	}
	else
	{
		document.getElementById("id_"+wan_type+"QoSPCR").disabled=false;
		document.getElementById("id_"+wan_type+"QoSBurst").disabled=false;
	}
}

function ckbindport() // add by Nina for check bind port 2010.7.19
{
	var i=0, j=0, z=0;
	var wifi_num=ssidNum; //fanny edit 2012/05/21//fanny edit 2012/05/29 wifi_num to ssidNum
	for (i=1;i<=4;i++)
	{
		if(document.getElementById("id_tmplanport"+i).checked==true &&
			document.getElementById("id_tmplanport"+i).disabled==false)
			j++;
		if(document.getElementById("id_tmplanport"+i).disabled==true)
			z++;
	}
	for(i=1;i<=wifi_num;i++)
	{
		if(document.getElementById("id_tmpwlanport"+i).checked==true &&
			document.getElementById("id_tmpwlanport"+i).disabled==false)
			j++;
		if(document.getElementById("id_tmpwlanport"+i).disabled==true)
			z++;
	}
	if((4+wifi_num)>z)
	{
		if (j>0)
			return 0;
		else
			return 1;
	}
	else
		return 0;
}

//Fanny add20120307 for xml strat
var xmldoc;
var xmlHttp;
var browser;
function createXMLObject() {
	try {
		if (window.XMLHttpRequest) {
			xmlHttp = new XMLHttpRequest();
		}
		// code for IE
		else if (window.ActiveXObject) {
			xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
		}
	} catch (e) {
		xmlHttp=false
	}
	return xmlHttp;
}
function createDocument()
{
	var aVersions = ["Microsoft.XmlDom","MSXML2.DOMDocument.5.0","MSXML2.DOMDocument.4.0","MSXML2.DOMDocument.3.0","MSXML2.DOMDocument"];
	for (var i = 0; i < aVersions.length; i++) {
		try {
			return new ActiveXObject(aVersions[i]);
		} catch (oError) {
			// 不做任何处理
		}
	}
	return "";
}
function loadXml(dname)
{
	if (navigator.userAgent.indexOf("Trident")>0)//Internet Explorer
	{
		browser="IE";
		//xmldoc = createIeDocument();

		xmldoc=new ActiveXObject("Microsoft.XMLDOM");
		xmldoc.async="false";
		while(xmldoc.readyState != 4) {};
		xmldoc.load(dname);
		return xmldoc;
	}

	try //Firefox, Mozilla, Opera, etc.
	{
		browser="ETC";
		if (window.XMLHttpRequest)
		{// code for all new browsers
			xmlHttp=new window.XMLHttpRequest();
		}
		else if (window.ActiveXObject)
		{// code for IE5 and IE6
			xmlHttp=new window.ActiveXObject("Microsoft.XMLHTTP");
		}
		if (xmlHttp!=null)
		{
			//xmlHttp.onreadystatechange=stateChange;
			xmlHttp.open("GET",dname,false);
			xmlHttp.send(null);
			var text = xmlHttp.responseText;
			var oParser = new DOMParser();
			return oParser.parseFromString(text,"text/xml");
		}
		/*if (navigator.userAgent.indexOf("Firefox")>0)//Firefox
		{
			browser="FF";
			xmldoc = xmlHttp.responseXML.documentElement;
			return xmldoc;
		}
		else if(navigator.userAgent.indexOf("Chrome")>0)//chrome
		{
			browser="CR";
			var text = xmlHttp.responseText;

			var oParser = new DOMParser();
			return oParser.parseFromString(text,"text/xml");
		   // if(xmlHttp.responseXML){
			//	return xmlHttp.responseXML.loadXML(text);
		  //  }else{
			//	var oParser = new DOMParser();
			//	return oParser.parseFromString(text,"text/xml");  ;

		   // }
		}*/

	}
	catch(e)
	{
		return NULL;
	}

}
function changeFace(items,size)
{
	var div = document.getElementsByTagName("div");
	var len = div.length;
	var id=0;

	for(var i=0; i<len&&div[i];i++)
	{
		if(div[i].getAttribute("ctrlid"))
		{
			id = parseInt(div[i].getAttribute("ctrlid"));

			if(id > size)
				continue;

			var value = getxmlNodeValue(items,id,size);
			if(value && value!='')
			{
				div[i].innerHTML = value;
			}
		}
	}
}
function getxmlNodeValue(TagName,index,len)
{
	var id;
	var value="";
	var x=xmldoc.getElementsByTagName(TagName)[0];

	if(browser == "IE")
	{
		id=x.childNodes[index-1].attributes[0].value;
	}
	else if(browser == "ETC")
	{
		id=x.childNodes[index*2-1].attributes["id"].value;
	}
	if(parseInt(id) == index)
	{
		if(browser == "IE")
			value = x.childNodes[index-1].text;
		else if(browser == "ETC")
			value = x.childNodes[index*2-1].textContent;
	}
	return value;
}
function getNodeValueByName(items,name,len)
{
	var x=xmldoc.getElementsByTagName(items)[0];
	var value = "";
	var i=0;

	if(browser == "IE")
	{
		for(i=0;i<len;i++)
		{
			if(name == x.childNodes[i].attributes[1].value)
				value = x.childNodes[i].text;
		}
	}
	else if(browser == "ETC")
	{
		for(i=1;i<len*2;i+=2)
		{
			if(name == x.childNodes[i].attributes[1].value)
				value = x.childNodes[i].textContent;
		}
	}
	return value;
}
function getNodeLength(TagName)
{
	var x;
	var length;

	x=xmldoc.getElementsByTagName(TagName);
	if(browser == "IE")
	{
		length=parseInt(x[0].attributes[0].value);
	}
	else
	{
		length=parseInt(x[0].attributes["len"].value);
	}
	return length;
}
function totxtAR(items)
{
	var div = document.getElementsByTagName("div");
	var len = div.length;
	var txt = "";
	var x="";

	for(var i=0; i<len;i++)
	{
		if(div[i].getAttribute("ctrltxt"))
		{
			txt = div[i].getAttribute("ctrltxt");
			x = xmldoc.getElementsByTagName(txt)[0];
			if(browser == "IE")
			{
				if(x.childNodes[1].attributes[0].value == "AR")
					value = x.childNodes[1].text;
			}
			else if(browser == "ETC")
			{
				if(x.childNodes[3].attributes[0].value == "AR")
					value = x.childNodes[3].textContent;
			}
			if(value)
			{
				div[i].innerHTML = value;
			}
		}
	}
}
function get_xml()
{//ar.xml
	xmldoc=loadXml("wwwctrl.cgi?action=arconf");
}
function inputtoAR()
{
	var input = document.getElementsByTagName("input");
	var len = input.length;

	for(var i=0; i<len;i++)
	{
		if(input[i].type=="button" ||input[i].type== "submit" )
		{
			value=getARbyName(input[i].value);
			input[i].value = value;
		}
	}
}
function toAR(items)//Arabic language
{
	var len=0;
	var value="";

	get_xml();
	if(!xmldoc)
	{
		return;
	}
	if(!items)
	{
		totxtAR(items);
	}
	else
	{
		len = getNodeLength(items);
		changeFace(items,len);
	}
	inputtoAR();
}
function do_translate(items)//to translate language
{

	//read browser language
	var lang=get_lang();
	if("AR" == lang)
	{
		toAR(items);
	}
}
function getARbyName(name)
{
	var items = "other";
	var value="";

	if(!name) return '';
	if(get_lang()=="AR")
	{
		if(!xmldoc)
		{
			get_xml();
		}

		var len = getNodeLength(items);
		value = getNodeValueByName(items,name,len);
		if(!value||value=='')
		{
			items = "pages";
			len = getNodeLength(items);
			value = getNodeValueByName(items,name,len);
		}
		if(!value||value=='')
		{
			items = "menu";
			len = getNodeLength(items);
			value = getNodeValueByName(items,name,len);
		}
		if(!value||value=='')
		{
			value = name;
		}
	}
	else
		value = name;
	return value;
}
/*HTTP Basic Authentication logout*/
function clearAuthenticationCache(page)
{
	if (!page) page = '/';

	try {
		var agt=navigator.userAgent.toLowerCase();

		if (agt.indexOf("msie") != -1)
		{
			// IE clear HTTP Authentication
			document.execCommand("ClearAuthenticationCache");
		}
		else
		{
			// Let's create an xmlhttp object
			var logout=String(Math.random()*65536 + 1);
			var xmlhttp = createXMLObject();
			// Let's prepare invalid credentials
			xmlhttp.open("GET", page, true, "admins", logout);
			// Let's send the request to the server
			xmlhttp.send(null);
			// Let's abort the request
//			if(agt.indexOf("chrome") < 0)
//				xmlhttp.abort();
//			if(agt.indexOf("chrome") > 0)
//			{
				logout=String(Math.random()*65536 + 1);
				var user=String(Math.random()*65536 + 1);
				xmlhttp.open("GET", page, false, user, logout);
				xmlhttp.send(null);
//			}
		}
	} catch(e) {
		warn_logout_fail();
		window.location.href="wwwctrl.cgi?action=DEFAULT";
		return;
	}

	return;
}
/*end  HTTP Basic Authentication logout*/
function documentLoaded (e) {
	alert(new XMLSerializer().serializeToString(e.target)); // Gives querydata.xml contents as string
}

function getwebhidden(wanType,name,index,account,Value)
{
	var result="";
	if (account>0)
		result="<input id='id_Tbl"+(wanType+name+index)+"_"+account+"' type='hidden' value='"+Value+"'>";
	else
		result="<input id='id_Tbl"+(wanType+name+index)+"' type='hidden' value='"+Value+"'>";
	return result;
}

/*function URLParams(varname)
{
  var url = window.location.href;
  var qparts = url.split("?");
  if (qparts.length == 0){return "";}
  var query = qparts[1];
  var vars = query.split(";");
  var value = "";
  for (i=0; i<vars.length; i++)
  {
	var parts = vars[i].split("=");

	if (parts[0] == varname)
	{
	  value = parts[1];
	  break;
	}
  }
  value = unescape(value);
  value.replace(/\+/g," ");
  return value;
}*/
function URLParams(varname)
{
	var url = window.location.href;
	var qparts = url.split("?");
	if (qparts.length == 0){return "";}
	var query = qparts[1];
	var vars = query.split("&");
	var value = "";
	for (i=0; i<vars.length; i++)
	{
		var parts = vars[i].split("=");

		if (parts[0] == varname)
		{
			value = parts[1];
		break;
		}
	}
	value = unescape(value);
	value.replace(/\+/g," ");
	return value;
}
//fanny add 05/17
function Str_delMulti(string,splitchar)
{
	var strArr = string.split(splitchar);
	var str = splitchar;
	var value = "";
	for(i = 0; i < strArr.length; i++)
	{
		if(str.indexOf(splitchar + strArr[i] + splitchar) == -1)
			str += strArr[i] + splitchar ;
	}

	value=str.substring(1,str.length - 1);
	return value;
}

//fanny add 2012/06/18

function padLeft(str, lenght)
{
	if (str.length >= lenght)
		return str;
	else
		return padLeft("0" + str, lenght);
}
///cookie
function setCookie(c_name,value,expiredays)
{
	var exdate=new Date();
	exdate.setDate(exdate.getDate()+expiredays);
	document.cookie=c_name+ "=" +escape(value)+
		((expiredays==null) ? "" : ";expires="+exdate.toGMTString());
}
function getCookie(c_name)
{
	if (document.cookie.length>0)
	{
		c_start=document.cookie.indexOf(c_name + "=")
		if (c_start!=-1)
		{
			c_start=c_start + c_name.length+1 ;
			c_end=document.cookie.indexOf(";",c_start);
			if (c_end==-1) c_end=document.cookie.length
				return unescape(document.cookie.substring(c_start,c_end));
		}
	}
	return "";
}
function SetCookie()
{
//	setCookie("USERNAME","root",100);
//	setCookie("LEVEL","admin",100);
}
function SetLanguage(lang)
{
	setCookie("CLANGUAGE",lang,30*24*60*1000);
}
function get_lang()
{
	var lang = getCookie('CLANGUAGE');

	if(!lang || lang =="")
	{
		var l="";
		if(navigator.userAgent.indexOf("Trident")>0)
		{
			l = navigator.userLanguage.toUpperCase();
		}
		else if(navigator.userAgent.indexOf("Firefox")>0 || navigator.userAgent.indexOf("Chrome")>0)
		{
			l = navigator.language.toUpperCase();
		}
		else
			l = navigator.language.toUpperCase();

		if(l.match("ZH"))
			lang = "EN";
		else if(l.match("EN"))
			lang = "EN";
		else if(l.match("AR"))
			lang = "AR";
		else
			lang = "AR";
		SetLanguage(lang);
	}
	LANG = lang;
	return lang;
}
function set_level()
{
	var ltmp=fvt_meta_config('login_level');
	if((ltmp != "user") && (ltmp != "admin"))
		return false;
	else
	{
		level = ltmp;
		setCookie("LEVEL",level,30*24*60*1000);
		return true;
	}
}
function get_level()
{
	var level = getCookie('LEVEL');
	if((level != "user") && (level != "admin"))
	{
		var ltmp=fvt_meta_config('login_level');
		if((ltmp != "user") && (ltmp != "admin"))
			return "";
		else
		{
			level = ltmp;
			setCookie("LEVEL",level,60*1000);
		}
	}
	return level;
}
function delCookie(c_name)
{
	setCookie(c_name,"",-1);
}
///cookie end
///reset parent size of iframe
function reSizeParentIframe(w)
{
//	window.parent.document.getElementById("main_frame").style.display="none";
	var height,width,h = 20;
	var fram=window.parent.document.getElementById("tdframe");
	if(w > 630)
	{
		setClass1(fram,"scroll_xy");
	}
	else
	{
		setClass1(fram,"scroll_y");
	}
	if (navigator.userAgent.indexOf("Firefox")>0) { // Mozilla, Safari, ...
		h += Math.max(window.document.body.clientHeight,window.document.body.scrollHeight);
	}else if (navigator.userAgent.indexOf("Trident")>0) { // IE
		h += Math.max(window.document.body.clientHeight,window.document.body.scrollHeight);
	}else if(navigator.userAgent.indexOf("Chrome")>0){//Chrome not do
		h += window.document.body.clientHeight;
	}else{//other
		h += window.document.body.clientHeight;
	}
	height = Math.max(h,450);
	if(get_lang()=="AR")
	{
		if(navigator.userAgent.indexOf("Chrome")>0)
		{
			if(height > 450)
				window.parent.document.getElementById("main_frame").style.marginRight='-17px';
			width = Math.max(w,635);
		}
		//else if(height > 450)
		//	width = Math.max(w,618);
		//else
			width = Math.max(w,635);
	}
	else
		width = Math.max(w,635);

	window.parent.document.getElementById("main_frame").style.height=height + "px";
	window.parent.document.getElementById("main_frame").style.width=width + "px";
//	window.parent.document.getElementById("main_frame").style.textAlign="right";
	window.parent.document.getElementById("main_frame").style.overflowY="hidden";
	fram.style.width="635px";
	fram.style.height="450px";
	selectie9();
}
///reset parent size of iframe end
///Flip horizontal
function addClass(element,className){
	 //must flow the rule ---split each other by whitespace(one or more)
	 //and the whitespace do not just space(制表符或者换行符)
	 var classArray =className.split(/\s+/),
		 result = element.className,  //element old className
		 i =0,
		 classMatch = " "+result+" ",  //used to check if has then decide if add
		 _length=classArray.length;
	 for(;i<_length;i++){
		 if(classMatch.indexOf(" "+classArray[i]+" ") <0){
			//if classArray[i] is new add it
			//and attention (result ? " ":"") if element old className is empty
			result += (result ? " ":"") + classArray[i];
		 }
	 }
	 element.className = result;
	 return element;
};
function delClass1(e,className)
{
	e.className=e.className.replace(new RegExp("\\b"+className+"\\b\\s*","g"),"");
}
function setClass1(e,className)
{
	e.className=className;
}
function changeSelect()
{
	var objs = document.getElementsByTagName("select");

	for(var i=0;i<objs.length;i++)
	{
		if(objs[i].getAttribute("ar")!='1')
			continue;
		for(var j=0;j<objs[i].options.length;j++)
		{
			var v=objs[i].options[j].text;
			value = getARbyName(v);
			objs[i].options[j].text = value;
		}
	}
}
function changeInputFliph()
{
	var objs = document.getElementsByTagName("input");
	var len = objs.length;

	for(var i=0;i<len;i++)
	{
		switch (objs[i].type) {
			case 'checkbox':
				objs[i].className = 'checkboxL';
			case 'radio':
				objs[i].className = 'radioL';
			case 'select-one':
			case 'text':
			default:
				continue;
		}
	}
}

function changeFlipHorizontal()
{
	var objs = document.getElementsByTagName("*");
	var len = objs.length;
	if(get_lang()!="AR")
		return;

	document.getElementsByTagName('body')[0].dir='rtl';
	for(var i=0;i< len; i++)
	{
		if(objs[i].getAttribute("ctrlflip"))
		{
			var ctrl = objs[i].getAttribute("ctrlflip");

			if(ctrl == "etc")
			{
				//addClass(objs[i],"flip");
				addClass(objs[i],"right");
			}
			else if(ctrl == "right")
			{
				addClass(objs[i],"right");
			}
			else if(ctrl == "left")
			{
				if(objs[i].align == 'right')
				{
					objs[i].align='left';
				}
				//addClass(objs[i],"left");
			}
			else if(ctrl == "al")
			{
				objs[i].align = 'left';
			}
			else if(ctrl == "center")
			{
				addClass(objs[i],"center");
			}
		}
	}
	changeSelect();
	changeInputFliph();
}
///Flip horizontal end
///log.xml about start
var xmlLog;
function loadComXml(dname)
{
	var doc;
	var http;
	if (navigator.userAgent.indexOf("Trident")>0)//Internet Explorer
	{
		browser="IE";
		//xmldoc = createIeDocument();

		doc=new ActiveXObject("Microsoft.XMLDOM");
		doc.async="false";
		while(doc.readyState != 4) {};
		doc.load(dname);

		return doc;
	}

	try //Firefox, Mozilla, Opera, etc.
	{
		browser="ETC";
		if (window.XMLHttpRequest)
		{// code for all new browsers
			http=new window.XMLHttpRequest();
		}
		else if (window.ActiveXObject)
		{// code for IE5 and IE6
			http=new window.ActiveXObject("Microsoft.XMLHTTP");
		}

		if (http!=null)
		{
			//xmlHttp.onreadystatechange=stateChange;
			http.open("GET",dname,false);
			http.send(null);
			var text = http.responseText;
			var oParser = new DOMParser();
			return oParser.parseFromString(text,"text/xml");
		}
	}
	catch(e)
	{
		return NULL;
	}

}
function getLogNodeValue(TagName,index)
{
	var value="";
	var x=xmlLog.getElementsByTagName("items");
	var len=x.length;

	if(index < len)
	{
		if(browser == "IE")
		{
			value=x[index].getElementsByTagName(TagName)[0].text;
		}
		else if(browser == "ETC")
		{
			value=x[index].getElementsByTagName(TagName)[0].textContent;
		}
	}
	return value;
}
function getComxml(xml)
{
	//return loadComXml("wwwctrl.cgi?action="+xml);
	return loadComXml(xml);
}
function load_syslog_item(i, item)
{
	if(!xmlLog)
	{
		xmlLog = getComxml('wwwctrl.cgi?action=logconf');
		if(!xmlLog)
		{
			return "";
		}
	}

	return getLogNodeValue(item,i);
}
function testlog()
{
	var time,module,level,msg;
	for(var i=0;i<12;i++)
	{
		time = load_syslog_item(i,"time");
		module = load_syslog_item(i,"module");
		level = load_syslog_item(i,"level");
		msg = load_syslog_item(i,"msg");

		if(!time || !module||!level||!msg)
		{
			return;
		}
	}
}
///log.xml end
function selectie9()
{

	if(!isselectie9())
		return;

	var objs = document.getElementsByTagName("select");

	for(var i=0;i<objs.length;i++)
	{
		if(!(objs[i].getAttribute("ie9")=='1'))
		{
			var width=objs[i].offsetWidth;
			objs[i].style.width=(width-3)+'px';
		}
	}
}
function isselectie9(web)
{
	if(web=='ie')
	{
		if(navigator.userAgent.indexOf("Windows NT 6.1")>0&&navigator.userAgent.indexOf("Trident")>0)
			return true;
		else
			return false;
	}
	else if(web=='ff')
	{
		if(navigator.userAgent.indexOf("Windows NT 6.1")>0&&navigator.userAgent.indexOf("Firefox")>0)
			return true;
		else
			return false;
	}
	else
	{
		if(navigator.userAgent.indexOf("Windows NT 6.1")>0&&(navigator.userAgent.indexOf("Trident")>0||navigator.userAgent.indexOf("Firefox")>0))
			return true;
		else
			return false;
	}

}
function ToBreakWord(strContent, length)
{

	if (!strContent||strContent=='')
	{
		return '';
	}
			//如果长度不够，则直接返回
	if (strContent.length <= length)
	{
		return strContent;
	}
	var strTemp = '';
	//如果足够长，则在其中加入空格
	while (strContent.length > length)
	{
		strTemp += strContent.substr(0, length) + " ";
		strContent = strContent.substr(length, strContent.length);
	}
	strTemp += " " + strContent;
	return strTemp;
}
function time_zone()
{
	if(get_lang()!="AR")
	{
		document.write('<option value="GMT-12">GMT-12:00  Eniwetok, Kwajalein</option>');
		document.write('<option value="GMT-11">GMT-11:00  Midway Island, Samoa</option>');
		document.write('<option value="GMT-10">GMT-10:00  Hawaii</option>');
		document.write('<option value="GMT-9">GMT-09:00	 Alaska</option>');
		document.write('<option value="GMT-8">GMT-08:00	 Pacific Time (US &amp; Canada), Tijuana</option>');
		document.write('<option value="GMT-7">GMT-07:00	 Arizona; Mountain Time (US &amp; Canada)</option>');
		document.write('<option value="GMT-6">GMT-06:00	 Central Time (US &amp; Canada)</option>');
		document.write('<option value="GMT-5">GMT-05:00	 Eastern Time (US &amp; Canada)</option>');
		document.write('<option value="GMT-4">GMT-04:00	 Atlantic Time (Canada)</option>');
		document.write('<option value="GMT-3">GMT-03:00	 Buenos Aires, Georgetown</option>');
		document.write('<option value="GMT-2">GMT-02:00	 Mid-Atlantic </option>');
		document.write('<option value="GMT-1">GMT-01:00	 Azores; Cape Verde Is.</option>');
		document.write('<option selected="selected" value="GMT+0">GMT  Greenwich Mean Time:	 Dublin, Edinburgh, London</option>');
		document.write('<option value="GMT+1">GMT+01:00	 Berlin, Rome, Vienna, Paris, Sarajevo</option>');
		document.write('<option value="GMT+2">GMT+02:00	 Israel</option>');
		document.write('<option value="GMT+3">GMT+03:00	 St. Petersburg, Volgograd, Nairobi</option>');
		document.write('<option value="GMT+4">GMT+04:00	 Abu Dhabi, Muscat, Yerevan</option>');
		document.write('<option value="GMT+5">GMT+05:00	 Islamabad, Karachi, Tashkent</option>');
		document.write('<option value="GMT+6">GMT+06:00	 Almaty, Dhaka</option>');
		document.write('<option value="GMT+7">GMT+07:00	 Bangkok, Hanoi, Jakarta</option>');
		document.write('<option value="GMT+8">GMT+08:00	 Taipei, Beijing, Chongqing, Hong Kong</option>');
		document.write('<option value="GMT+9">GMT+09:00	 Osaka, Sapporo, Toyko, Seoul, Yakutsk</option>');
		document.write('<option value="GMT+10">GMT+10:00  Guam, Port Moresby</option>');
		document.write('<option value="GMT+11">GMT+11:00  Magadan, Solamon, New Caledonia</option>');
		document.write('<option value="GMT+12">GMT+12:00  Auckland, Wellington, Fiji</option>');
		document.write('<option value="Disabled">None</option>');
	}
	else
	{
		document.write('<option value="GMT-12">إنيويتوك، كواجالين	  12:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT-11">جزيرة ميدواي، ساموا	11:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT-10">هاواي				  10:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT-9">ألاسكا				  09:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT-8">تيخوانا، (الولايات المتحدة، كندا) بتوقيت المحيط الهادئ 08:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT-7">أريزونا؛ التوقيت الجبلي (الولايات المتحدة، كندا)		  07:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT-6">التوقيت المركزي (الولايات المتحدة، كندا)				 06:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT-5">التوقيت الشرقي (الولايات المتحدة، كندا)				 05:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT-4">التوقيت الأطلسي (كندا)								 04:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT-3">بوينس آيريس، جورج تاون							 03:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT-2">منتصف المحيط الأطلسي								 02:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT-1">الأزور، كيب فيردي إس								  01:00-توقيت غرينيتش</option>');
		document.write('<option selected="selected" value="GMT+0">توقيت غرينيتش: دوبلن، أدنبرة، لندن</option>');
		document.write('<option value="GMT+1">برلين وروما وفيينا وباريس وسراييفو				 +01:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT+2">إسرائيل												  +02:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT+3">سانت بطرسبورغ، فولغوغراد، نيروبي +03:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT+4">أبو ظبي، مسقط، يريفان +04:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT+5">اسلام اباد، كراتشي، طشقند +05:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT+6">الماتي، دكا  +06:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT+7">بانكوك، هانوي، جاكرتا +07:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT+8">تايبيه وبكين وتشونغتشينغ وهونج كونج +08:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT+9">أوساكا، سابورو، طوكيو، سيول، ياكوتسك +09:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT+10">غوام، بورت موريسبي +10:00-توقيت غرينيتش</option>');
		document.write('<option value="GMT+11">ماجادان، سولامون، كاليدونيا الجديدة +11:00 -توقيت غرينيتش</option>');
		document.write('<option value="GMT+12">أوكلاند، ولينغتون، فيجي +12:00 -توقيت غرينيتش</option>');
		document.write('<option value="Disabled">لا شيء</option>');
	}
}
//confirm ar start
function isitem(item)
{
	if(!item) return '';
	else return item;
}
function confirm_upload()
{
	if(LANG!="AR")
		return confirm("Are you sure you want to continue with uploading ?");
	else
		return confirm("Are you sure you want to continue with uploading ?111111111111111");
}
function confirm_defaultWarning()
{
	if(LANG!="AR")
		return confirm("WARNING:All your setting will be lost!Are you sure you want to do this?");
	else
		return confirm("WARNING:All your setting will be lost!Are you sure you want to do this?1111111111");
}
function confirm_reboot()
{
	if(LANG!="AR")
		return confirm("Reboot takes about 60 seconds to complete.Are you sure you want to reboot?");
	else
		return confirm("Reboot takes about 60 seconds11111111111 to complete.Are you sure you want to reboot?");
}
function confirm_wifi()
{
	if(LANG!="AR")
		return confirm("If you want to start WPS , the other setting will be saved!!");
	else
		return confirm("If you want to start WPS11111111111111 , the other setting will be saved!!");
}
function confirm_lan()
{
	if(LANG!="AR")
		return confirm("Change setting will stop connection before restart service");
	else
		return confirm("Change setting will1111111111 stop connection before restart service");
}
function confirm_logout()
{
	if(LANG!="AR")
		return confirm("Are you sure exit page?");
	else
		return confirm("Are 1111111111you sure exit page?");
}
//confirm ar end
//alert ar start
function warn_logout_fail()
{
	if(LANG != "AR")
		alert("Logout err! Please try again later!");
	else
		alert("Logout error!  يرجى المحاولة لاحقا");
}
function warn_wait()
{
	if(LANG!="AR")
		alert("Please wait! Another client is upgading firmware.");
	else
		alert("Please wait! Another client is upgading firmware.111111111");
}
function warn_restore_fail()
{
	if(LANG!="AR")
		alert("Error:This file is not a configuration file!");
	else
		alert("Error:This file is not a configuration file!11111111111111");
}
function warn_restore_Exist()
{
	if(LANG!="AR")
		alert("Please wait! Another client is restoring configuration.");
	else
		alert("Please wait! Another client is restoring configuration.11111111111111");
}
function warn_restore_cfg0()
{
	if(LANG!="AR")
		alert("Please specify upgrade file's location.Either type the file's path and file name or click browse to the file's location.");
	else
		alert("Please specify upgrade file's location.Either type the file's path and file name or click browse to the file's location.1111111111111");
}
function warn_restore_upload()
{
	if(LANG!="AR")
		alert("At the end of uploading, the Router may not respond\n to commands for as long as 90 seconds.\n\nThis is normal. Do not power down the base station during this time.");
	else
		alert("At the end of uploading, the Router may not respond\n to commands for as long as 90 seconds.\n\nThis is normal. Do not power down the base station during this time.11111111111111111111");
}
function warn_firmware_err()
{
	if(LANG!="AR")
		confirm("Firmware update error!");
	else
		confirm("Firmware update error!111111111111111");
}
function warn_firmware_upload()
{
	if(LANG!="AR")
		alert("At the end of upgrading, the Gateway may not respond to commands for as long as 150 seconds.This is normal. Do not power down the base station during this time.");
	else
		alert("111111111111111At the end of upgrading, the Gateway may not respond to commands for as long as 150 seconds.This is normal. Do not power down the base station during this time.");
}
function warn_defaults1()
{
	if(LANG!="AR")
		alert("Restoring default settings will take up to 90 seconds.Do not turn off power during this process.");
	else
		alert("Restoring default settings 1111111111111111111will take up to 90 seconds.Do not turn off power during this process.");
}
function warn_defaults2()
{
	if(LANG!="AR")
		alert("It will not restore factory defaults.No settings will be lost!");
	else
		alert("It will not r1111111111111111estore factory defaults.No settings will be lost!");
}
function warn_urlstring()
{
	if(LANG!="AR")
		alert('It should be "http:// " or "https:// " at the beginning of URL.');
	else
		alert('It should be111111111 "http:// " or "https:// " at the beginning of URL.');
}
function warn_apply()
{
	if(LANG!="AR")
		alert("After applying changes, you shall reboot it.");
	else
		alert("After applying11111111111111 changes, you shall reboot it.");
}
function warn_mask()
{
	if(LANG!="AR")
		alert("Subnet Mask at first position must be 255!");
	else
		alert("Subnet Mask at111111111111 first position must be 255!");
}
function warn_ipdhcp()
{
	if(LANG!="AR")
		alert("Invalid DHCP range value! Please check IP address and DHCP Address!");
	else
		alert("Invalid DHCP range11111111 value! Please check IP address and DHCP Address!");
}
function warn_lantime()
{
	if(LANG!="AR")
		alert("Each character of the number must be 0~9 in DHCP Lease Time");
	else
		alert("Each character of the 111111111number must be 0~9 in DHCP Lease Time");
}
function warn_wan_choose()
{
	if(LANG!="AR")
		alert("Please choose one local service at least.");
	else
		alert("Please 11111111choose one local service at least.");
}
function warn_reboot1(item)
{
	if(LANG!="AR")
		alert("Warning: The WAN config is empty, please add one wan rule at least before reboot!");
	else
		alert("Warning: The WAN config is empty, please add one wan rule at least11111111111 before reboot!");
}
function warn_int_betweenQosU(item,min,max)
{
	if(LANG!="AR")
		alert("Input value of Qos Upstream Classification in "+isitem(item)+" should be an integer between "+min+" and "+max);
	else
		alert("Input value of Qos Upstream Classification in "+getARbyName(item)+" 11111111111111 "+min+" and "+max);
}
function warn_int_betweenQosD(item,min,max)
{
	if(LANG!="AR")
		alert("Input value of QoS Downstream Classification in "+isitem(item)+" should be an integer between "+min+" and "+max);
	else
		alert("Input value of QoS Downstream Classification in "+getARbyName(item)+" 11111111111111 "+min+" and "+max);
}
function warn_rule_conflict(item)
{
	if(LANG!="AR")
		alert("The "  + isitem(item) + " of new rule is conflicted with current rules");
	else
		alert("The "  + getARbyName(item) + " ARAR11111111111111111111111");
}
function warn_int_between(item,min,max,msg)
{
	if(LANG!="AR")
		alert("The "+isitem(msg)+" "+isitem(item)+" should be an integer between "+min+" and "+max);
	else
		alert(getARbyName(msg)+" "+getARbyName(item)+" should 11111111111111111integer between "+min+" and "+max);
}
function warn_num_between(item,min,max,msg)
{
	if(LANG!="AR")
		alert("The "+isitem(msg)+" "+isitem(item)+" should be a number between "+min+" and "+max);
	else
		alert(getARbyName(msg)+" "+getARbyName(item)+" should 11111111111111111integer between "+min+" and "+max);
}
function warn_int_between_group(item,no,min,max)
{
	if(LANG!="AR")
		alert("The " + isitem(item) + " of group "+ no + " should be an integer between "+min+" and "+max);
	else
		alert("The " + getARbyName(item) + " of group "+ no + " 111111111111111should be an integer between "+min+" and "+max);
}
function warn_not_empty(item)
{
	if(LANG!="AR")
		alert("The "+isitem(item)+" can't be empty!");
	else
		alert(getARbyName(item)+" can't be empty!1111111111111111111111111");
}
function warn_not_empty2(item,mm)
{
	if(LANG!="AR")
		alert("The "+isitem(mm)+" "+isitem(item)+" can't be empty!");
	else
		alert(getARbyName(mm)+" "+getARbyName(item)+" can't be empty!1111111111111111111111111");
}
function warn_not_empty_int(item,no)
{
	if(LANG!="AR")
		alert(isitem(item)+""+no+" can't be empty!");
	else
		alert(getARbyName(item)+""+no+" can't be empty!1111111111111111111111111");
}
function warn_char(item,m,n)
{
	if(LANG!="AR")
		alert(isitem(item)+" should be characters in "+m+" and "+n);
	else
		alert(getARbyName(item)+" should be characters111111111 in "+m+" and "+n);
}
function warn_syssetting_ConfirmErr(item)
{
	if(LANG!="AR")
		alert(isitem(item)+" Confirm new password error or new password is empty!");
	else
		alert(getARbyName(item) +" Confirm new password error or new password is empty!1111111111111");
}
function warn_invalid_int(item,i,mm)
{
	if(LANG!="AR")
		alert("The "+isitem(mm)+" " + isitem(item) + " "+i+" is invalid!");
	else
		alert("The "+getARbyName(mm)+" " +i+" "	 + getARbyName(item) + " is invalid!111111111");
}
function warn_invalid_int2(item,i,m)
{
	if(LANG!="AR")
		alert(isitem(m)+" "	 + isitem(item) + " "+i+" is invalid!");
	else
		alert(getARbyName(m)+" "+i+" "	+ getARbyName(item) + " is invalid!111111111");
}
function warn_invalid(item)
{
	if(LANG!="AR")
		alert("The "  + isitem(item) +" is invalid!");
	else
		alert("The " + getARbyName(item) + " is invalid!111111111");
}
function warn_invalid2(item,mm)
{
	if(LANG!="AR")
		alert(isitem(mm)+" " + isitem(item) +" is invalid!");
	else
		alert(getARbyName(mm)+" " + getARbyName(item) + " is invalid!111111111");
}
function warn_invalidMAC(item,No)
{
	if(LANG!="AR")
		alert(isitem(item) + " MAC " + No + " is invalid!!");
	else
		alert(getARbyName(item) + " MAC " + No + " is inva1111111111111111lid!!");
}
function warn_invalidgroup(item,no)
{
	if(LANG!="AR")
		alert("The "+ isitem(item) +" of group "+ no +" is invalid!");
	else
		alert("The "+ getARbyName(item) +" of1111111111111 group "+ no +" is invalid!");
}
function warn_invalid_group(item,no)
{
	if(LANG!="AR")
		alert(isitem(item) + " of group " + no + " is invalid!");
	else
		alert(getARbyName(item) + " of group11111111 " + no + " is invalid!");
}
function warn_int(item)
{
	if(LANG!="AR")
		alert("The "  + isitem(item) +" should be an integer.");
	else
		alert(getARbyName(item) + " should be an integer.111111111");
}
function warn_num(item)
{
	if(LANG!="AR")
		alert("The "  + isitem(item) +" should be a number.");
	else
		alert(getARbyName(item) + " should be an integer.111111111");
}
function warn_syssetting_passwordErr(item)
{
	if(LANG!="AR")
		alert("Your current "+isitem(item)+" password is error, please check it and try again.");
	else
		alert("Your current "+getARbyName(item)+" password is error, please check it and try again.1111111111111");
}

function warn_CWMP_checkSyb(item,syb)
{//syb= char
	if(LANG!="AR")
		alert(isitem(item) + " can't include special symbol ' " + syb + " '.");
	else
		alert(getARbyName(item) + " can't include special symbol11111111111111 ' " + syb + " '.");
}
function warn_route_group(i)
{
	if(LANG!="AR")
		alert("The group " + (i+1) + " rule incomplete!");
	else
		alert("The group " + (i+1) + " rule111111111 incomplete!");
}
function warn_group_same(item,i,j)
{
	if(LANG!="AR")
		alert(isitem(item)+" of group "+ (i+1) +" and group " + (j+1)  +" are the same !");
	else
		alert(getARbyName(item)+" of group11111111111 "+ (i+1) +" and group " + (j+1)  +" are the same");
}
function warn_rule_duplicate(item,No)
{
	if(LANG!="AR")
		alert(isitem(item) + " of Rule" + No + " is duplicate!!");
	else
		alert(getARbyName(item) + " of Rule1111111111111111" + No + " is duplicate!!");
}
function warn_input(item,value)
{
	if(LANG!="AR")
		alert("The "+isitem(item) + " is invalid! please input value "+value+".");
	else
		alert("The "+getARbyName(item) + " is invalid!11111111111 please input value "+value+".");
}
function warn_reduplicate(item,No)
{
	if(LANG!="AR")
		alert(isitem(item) + " MAC " + No + " is reduplicate!!");
	else
		alert(getARbyName(item) + " MAC11111111111111111 " + No + " is reduplicate!!");
}
function warn_port_equal(no)
{
	if(LANG!="AR")
		alert("Starting Port of group "+no+" should be equal or smaller than the relative Ending Port!");
	else
		alert("Starting Port of group1111111111111 "+no+" should be equal or smaller than the relative Ending Port!");
}
function warn_not_match(no)
{
	if(LANG!="AR")
		alert("Starting IP and Ending IP of group "+no+" don't match!");
	else
		alert("Starting IP and 1111111111111111Ending IP of group "+no+" don't match!");
}
function warn_wifi_not_match(item1,item2)
{
	if(LANG!="AR")
		alert(isitem(item1)+" and "+isitem(item2)+" don't match!");
	else
		alert(getARbyName(item1)+" and1111111 "+getARbyName(item2)+" don't match!");
}
function warn_wifi_not_match2(item1,item2,item)
{
	if(LANG!="AR")
		alert(isitem(item)+" "+isitem(item1)+" and "+isitem(item2)+" don't match!");
	else
		alert(getARbyName(item)+" "+getARbyName(item1)+" and1111111 "+getARbyName(item2)+" don't match!");
}
function warn_l3_fill(no)
{
	if(LANG!="AR")
		alert("Please fill with the " + no + " group data!");
	else
		alert("Please fill1111111 with the " + no + " group data!");
}
function warn_l3_ruleConflict(i,j)
{
	if(LANG!="AR")
		alert("Filter Rule " + i + "and Rule " + j + " are conflicted");
	else
		alert("Filter Rule " + i + "and111111111 Rule " + j + " are conflicted");
}
function warn_ssid_illegal(item)
{
	if(LANG!="AR")
		alert(isitem(item)+" contains illegal characters, like" + " \";\"");
	else
		alert(getARbyName(item)+" contains illegal111111111 characters, like" + " \";\"");
}
function warn_ssid_illegal2(item)
{
	if(LANG!="AR")
		alert(item+" contains illegal characters.");
	else
		alert(getARbyName(item)+" contains illegal111111111 characters.");
}
function warn_ssid_cant_same(item1,item2)
{
	if(LANG!="AR")
		alert(isitem(item1) + " can't be the same as " + isitem(item2) + ".");
	else
		alert(getARbyName(item1) + " can't be1111111111 the same as " + getARbyName(item2) + ".");
}
function warn_ssid_cant_same2(item1,item2,no)
{
	if(LANG!="AR")
		alert(isitem(item1) + " can't be the same as " + isitem(item2) +' '+no+ ".");
	else
		alert(getARbyName(item1) + " can't be1111111111 the same as " + getARbyName(item2) +' '+no+	 ".");
}
function warn_larger(item,no)
{
	if(LANG!="AR")
		alert(isitem(item)+" should be larger than "+no);
	else
		alert(getARbyName(item)+" should11111111111111 be larger than "+no);
}
//alert ar end

function GetNavLang()
{
var userLang = navigator.language || navigator.userLanguage;
var ReturnLang;
switch (userLang) {
	case 'zh':
	case 'zh-tw':
	case 'zh-TW':
		ReturnLang="ZH";
		break;
	case 'en':
	case 'en-US':
		ReturnLang="EN";
		break;
	default:
		ReturnLang="OT";
		break;
	}
	return ReturnLang;
}

//===  end common.js ===//
