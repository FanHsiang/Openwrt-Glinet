function showTail()
{
	var strHtml;
	strHtml = '</tr>'+
			'</table>'+
			'</form>'+
		'</body>';//+
//	'</html>';
	document.write(strHtml);
}

function showTail2()
{
	var strHtml;
	strHtml = '</tr>'+
			'</table>'+
		'</body>';//+
//	'</html>';
	document.write(strHtml);
}

function printMenuSection(name,end, content, color , flag)
{
	var pic;
	var strHtml;
	if (flag==0)
		pic = "/images/up.jpg";
	else
		pic = "/images/down.jpg";
	strHtml=		'<tr id="id_' + name + '_item' + (end + 2) + '">'+
          				'<td colspan="3" height="20" width="170" background="/images/blu_bar.gif" class="section" ' +
          				'onclick=setMenuFlag("' + name + '",' + 1 + ',' +	end + '); ' + 
          				'onmouseover=changeCursor("' + name + '",' + end + ');>'+
          				'&nbsp;&nbsp;&nbsp;' +
          				'<img height="12" width="12" id="id_' + name + '_item' + (end + 1) + '" src="' + pic + '" width="8" height="8">'+
        					'&nbsp;'+
          					'<font color="' + color + '">'+
          					content+
          					'</font>'+
          				'</td>'+
        			'</tr>';
    document.write(strHtml);
}

function printMenuItem(name , index, link, content, color, background,flag)
{
	var strHtml;
	if (flag)
		strHtml=	'<tr id="id_' + name + '_item' + index + '" height="20" style="display:none">';
  	else
  		strHtml=	'<tr id="id_' + name + '_item' + index+ '" height="20">';

        strHtml += '<td width="5" bgcolor="' + background + '">&nbsp;</td>'+
          		'<td width="155" class="leftLink" bgcolor="' + background + '">'+
          		'<a href="../cgi-bin/' + link + '" TARGET="contentfrm" ><font color="' + color + '">';

	if (background==darkBlue)
  		strHtml += '<span class="selected_css">' + content + '</span>';
  	else
  		strHtml += content ;

  
	strHtml += '</font></a></td>';
  	if (background==darkBlue)
        	strHtml += '<td width="10" bgcolor="' + background + '" align="right">&gt;&gt;</td>';
	else
		strHtml += '<td width="10" bgcolor="' + background + '" align="right">&nbsp;</td>';

	strHtml += '</tr>';
    	document.write(strHtml);
}

function fixedWindow(url)
{
		return true;
		//fw=window.open(url, "fw", "resizable=yes,status=yes,scrollbars,HEIGHT=580,WIDTH=480");
		//fw.focus();
}

//===  end menu.js    ====//
