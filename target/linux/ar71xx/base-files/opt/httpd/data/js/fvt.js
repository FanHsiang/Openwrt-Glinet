// public function list
//
// function fvt_paramlist_clear()
// function fvt_paramlist_cat_str(key_str, value_str)
// function fvt_paramlist_cat_table_str(table_id)	// not directly used
// function fvt_paramlist_presubmit(form_name)
// function fvt_form_obj_set(form_name, obj_name, value) 
// function fvt_form_obj_get(form_name, obj_name) 
// 
// function fvt_table_attr_config_set(key, value) 
// function fvt_table_attr_config_get(key) 
// function fvt_table_viewer(table_id, row_conf_prefix, max_line) 
// function fvt_table_editor(table_id, tbody_id, row_conf_prefix) 
// function fvt_table_editor_get(table_id) 		// not directly used
//
// function fvt_form_sample_js_show() 
// function fvt_meta_config(key)			// get value from meta_config

////////////////////////////////////////////////////////////////////////////////////////////////

// for CSRF protection
// since fvt.js might be included more than once, we need to ensure the fvt_sess_token is inited only in 1st include
if (typeof fvt_sess_token == 'undefined' || fvt_sess_token === null) {
	var fvt_sess_token = "";
}

var fvt_paramlist = "";

function fvt_paramlist_clear()
{
	fvt_paramlist = "";
}

function fvt_paramlist_cat_str(key_str, value_str)
{
	if (fvt_paramlist == "") {
		fvt_paramlist = key_str + "=" + encodeURIComponent(value_str);
	} else {
		fvt_paramlist = fvt_paramlist + "^^^" + key_str + "=" + encodeURIComponent(value_str);
	}
}

// as one table may have multiple lines
// the escape of each table line data is done inside fvt_table_editor_get()
function fvt_paramlist_cat_table_str(table_id)
{
	fvt_paramlist ='';
	if (fvt_paramlist == "") {
		fvt_paramlist = fvt_table_editor_get(table_id);
	} else {
		fvt_paramlist = fvt_paramlist + "^^^" + fvt_table_editor_get(table_id);
	}
}

function fvt_paramlist_presubmit(form_name)
{
	if (form_name == '' || form_name == undefined)
		return;

	form_obj = document.forms[form_name];

	var input_obj = document.createElement("input");
	input_obj.setAttribute("name", "wwwctrl_paramlist");
	input_obj.setAttribute("type", "hidden");
	input_obj.setAttribute("id", "fvt_hidden_param");
	input_obj.setAttribute("value", fvt_paramlist);
	form_obj.appendChild(input_obj);

	if (fvt_sess_token != "") {
		var input2_obj = document.createElement("input");
		input2_obj.setAttribute("name", "sess_token");
		input2_obj.setAttribute("type", "hidden");
		input2_obj.setAttribute("id", "fvt_hidden_token");
		input2_obj.setAttribute("value", fvt_sess_token);
		form_obj.appendChild(input2_obj);
	}
	return 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////

function fvt_form_text_set(form_name, text_name, value)
{
	if (form_name == '' || form_name == undefined)
		return;

	var form_obj = document.forms[form_name];

	if (form_obj == undefined) {
		return;
	}

	if (form_obj.elements[text_name] == undefined) {
		return;
	}

	form_obj.elements[text_name].value = value; 
}
function fvt_form_text_get(form_name, text_name)
{
	if (form_name == '' || form_name == undefined)
		return;

	var form_obj = document.forms[form_name];

	if (form_obj == undefined) {
		return "";
	}

	if (form_obj.elements[text_name] == undefined) {
		return "";
	}

	return form_obj.elements[text_name].value;
}
function fvt_form_radio_set(form_name, radio_name, value)
{
	if (form_name == '' || form_name == undefined)
		return;

	var form_obj = document.forms[form_name];

	if (form_obj == undefined) {
		return;
	}

	for (var j = 0; j < form_obj.length; j++) {
		if (radio_name == form_obj.elements[j].name) {
			form_obj.elements[j].checked = false;
			if (form_obj.elements[j].value == value) {
				form_obj.elements[j].checked = true;
			}
		}
	}
}
function fvt_form_radio_get(form_name, radio_name)
{
	if (form_name == '' || form_name == undefined)
		return;

	var form_obj = document.forms[form_name];

	if (form_obj == undefined) {
		return;
	}

	for (var j = 0; j < form_obj.length; j++) {
		//document.write(document.forms[i].elements[j].name);
		if (radio_name == form_obj.elements[j].name) {
			//document.forms[i].elements[j].checked = true;
			if (form_obj.elements[j].checked == true) {
				return form_obj.elements[j].value;
			}
		}
	}
	return "";
}
function fvt_form_selmenu_set(form_name, menu_name, value) 
{
	var i_default=0;

	if (form_name == '' || form_name == undefined)
		return;

	var form_obj = document.forms[form_name];

	if (form_obj == undefined) {
		return;
	}
	
	for (var i=0;i<form_obj.elements[menu_name].options.length;i++) {
	    if (form_obj.elements[menu_name].options[i].value==value) {
		form_obj.elements[menu_name].options[i].selected=true;
	    	return i;
	    }
	    if (form_obj.elements[menu_name].options[i].defaultSelected) {
		i_default=i;
	    }
	}
	form_obj.elements[menu_name].options[i_default].selected=true;
	return i_default;
	
}
function fvt_form_selmenu_get(form_name, menu_name) 
{
	if (form_name == '' || form_name == undefined)
		return;

	var form_obj = document.forms[form_name];

	if (form_obj == undefined) {
		return;
	}

 	var selectedindex = form_obj.elements[menu_name].options.selectedIndex;
	var s=form_obj.elements[menu_name].options[selectedindex].value;
	if (s.length==0)
		s=form_obj.elements[menu_name].options[selectedindex].text;
	return s;
}
function fvt_form_checkbox_set(form_name, checkbox_name, value) 
{
	if (form_name == '' || form_name == undefined)
		return;

	var form_obj = document.forms[form_name];

	if (form_obj == undefined) {
		return;
	}
	for (var j = 0; j < form_obj.length; j++) {
		if (checkbox_name == form_obj.elements[j].name) {
			if (form_obj.elements[j].value == value) {
				form_obj.elements[j].checked = true;
			}
		}
	}
}
function fvt_form_checkbox_get(form_name, checkbox_name) 
{
	if (form_name == '' || form_name == undefined)
		return;

	var form_obj = document.forms[form_name];

	if (form_obj == undefined) {
		return;
	}
	for (var j = 0; j < form_obj.length; j++) {
		if (checkbox_name == form_obj.elements[j].name) {
			if (form_obj.elements[j].checked == true) {
				return form_obj.elements[j].value;
			} else {
				// return "";
				return "0";	// NOTE: we change the default value of unchecked checkbox from "" to "0"
			}
		}
	}
	return "";
}

function fvt_form_obj_set(form_name, obj_name, value) 
{
	if (form_name == '' || form_name == undefined)
		return;

	var form_obj = document.forms[form_name];
	for (var j = 0; j < form_obj.elements.length; j++) {
		if (form_obj.elements[j].name == obj_name) {
			switch (form_obj.elements[j].type) {
				case 'checkbox':
					fvt_form_checkbox_set(form_obj.name, form_obj.elements[j].name, value);
					break;
				case 'radio':
					fvt_form_radio_set(form_obj.name, form_obj.elements[j].name, value);
					break;
				case 'select-one':
					fvt_form_selmenu_set(form_obj.name, form_obj.elements[j].name, value);
					break;
				case 'text':
				default:	// for file, password, hidden...
					fvt_form_text_set(form_obj.name, form_obj.elements[j].name, value);
					break;
			}
		}
	}
}

function fvt_form_obj_get(form_name, obj_name) 
{
	if (form_name == '' || form_name == undefined)
		return;

	var form_obj = document.forms[form_name];
	for (var j = 0; j < form_obj.elements.length; j++) {
		if (form_obj.elements[j].name == obj_name) {
			switch (form_obj.elements[j].type) {
				case 'checkbox':
					return fvt_form_checkbox_get(form_obj.name, form_obj.elements[j].name);
				case 'radio':
					return fvt_form_radio_get(form_obj.name, form_obj.elements[j].name);
				case 'select-one':
					return fvt_form_selmenu_get(form_obj.name, form_obj.elements[j].name);
				case 'text':
				default:	// for file, password, hidden...
					return fvt_form_text_get(form_obj.name, form_obj.elements[j].name);
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////

var fvt_table_attr_config = new Array();
fvt_table_attr_config['color_1'] = '#eeeeee';
fvt_table_attr_config['color_2'] = '#eeeeee';
fvt_table_attr_config['selected_color'] = '#dddec4';
fvt_table_attr_config['class_1'] = 'opt_list';
fvt_table_attr_config['class_2'] = 'opt_list';
fvt_table_attr_config['row_selected_class'] = 'opt_list_hicolor';
fvt_table_attr_config['insert_button'] = 'insert';
fvt_table_attr_config['delete_button'] = 'delete';
fvt_table_attr_config['submit_button'] = 'submit';

function fvt_table_attr_config_set(key, value) 
{
	fvt_table_attr_config[key] = value;
}

function fvt_table_attr_config_get(key) 
{
	return fvt_table_attr_config[key];
}

////////////////////////////////////////////////////////////////////////////////////////////////

var table_list= new Array();
var table_id_map= new Array();

function table_locate(table_id)
{
	if (table_id == '' || table_id == undefined)
		return;

	table = document.getElementById(table_id);
	return table;
}

function table_create(table_id)
{
	if (table_id == '' || table_id == undefined)
		return;

	div_id = "div_"+table_id;
	div_element = document.getElementById(div_id);
	table = document.createElement('table');
	table.setAttribute("id", table_id);
	div_element.appendChild(table);
	return table;
}

//rgbcolor2hex('rgba(255, 136, 17, 0.5)'); // '#ff8811'
//rgbcolor2hex('rgb(255, 136, 17)'); // '#ff8811'
function rgbcolor2hex(c) 
{
	var m = /rgba?\((\d+), (\d+), (\d+)/.exec(c);
	return m? '#' + (m[1] << 16 | m[2] << 8 | m[3]).toString(16): c;
}

function table_row_select(row)
{
	row_parent = row.parentNode;
	row_idx = row.rowIndex;

	var table ;

	if (row.parentNode.tagName.toLowerCase() == 'table')
		table = row.parentNode;
	else if (row_parent.parentNode.tagName.toLowerCase() == 'table')
		table = row_parent.parentNode;

	if (table.getAttribute('row_selected_class') == undefined || table.getAttribute('row_selected_class') == '') {
		var color;
		color = table.getAttribute('selected_color');

		if (row.getAttribute("orig_color") == undefined 
		    || rgbcolor2hex(row.style.backgroundColor).toLowerCase() != color.toLowerCase()) {
			row.setAttribute("orig_color", row.style.backgroundColor);
		}
		row.style.backgroundColor = color;
		for (var i = 0; i < table.rows.length; i++) {
			if (i == row_idx)
				continue;

			if (table.rows[i].style.backgroundColor != undefined && 
			    rgbcolor2hex(table.rows[i].style.backgroundColor).toLowerCase() == color.toLowerCase() )  {
				table.rows[i].style.backgroundColor = table.rows[i].getAttribute('orig_color');
			}
		}
	} else {
		selected_class = table.getAttribute('row_selected_class');

		// check if tr or td use the class definition
		if (row.cells[1].className != undefined && row.cells[1].className != '') {
			for (var i = 0; i < row.cells.length; i++) {
				if (row.cells[i].getAttribute("orig_class") == undefined ||
				    row.cells[i].className.toLowerCase() != selected_class.toLowerCase()) {
					row.cells[i].setAttribute("orig_class", row.cells[i].className);
					row.cells[i].className = selected_class;
				}
			}

			for (var i = 0; i < table.rows.length; i++) {
				if (i == row_idx)
					continue;

				for (var j = 0; j < table.rows[i].cells.length; j++) {
					if (table.rows[i].cells[j].className != undefined && 
					    table.rows[i].cells[j].className.toLowerCase() == selected_class.toLowerCase())  {
						table.rows[i].cells[j].className = table.rows[i].cells[j].getAttribute('orig_class');
					}
				}
			}

		} else if (row.className != undefined && row.className !='') {
			
			if (row.getAttribute("orig_class") == undefined ||
			    row.className.toLowerCase() != row.className.toLowerCase()) 
				row.setAttribute("orig_class", row.className);
			
			row.className = selected_class;
			for (var i = 0; i < table.rows.length; i++) {
				if (i == row_idx)
					continue;

				if (table.rows[i].className != undefined && 
				    table.rows[i].className.toLowerCase() == selected_class.toLowerCase() )  {
					table.rows[i].className = table.rows[i].getAttribute('orig_class');
				}
			}
		}
	}
}

function onclick_table_row_select(e)
{
	row = this;	
	table_row_select(row);
}

////////////////////////////////////////////////////////////////////////////////////////////////

function fvt_table_viewer_load_row(table_id, key_str)
{
	if (table_id == '' || table_id == undefined)
		return;

	table = table_locate(table_id);

	if (table_id_map[table_id] == undefined)
		table_id_map[table_id] = table_id_map.length;

	var table_idx= table_id_map[table_id];

	// table_list[] is 3 dimension array
	// 1st dimension means table index within all tables
	// 2nd dimention means row index with all rows of specific table
	// 3rd dimension means field index with all fields of specific row of specific table
	table_list[table_idx] = new Array();

	var row_idx = table_list[table_idx].length;
	table_list[table_idx][row_idx] = fvt_meta_config(key_str).split(';');
	if (table_list[table_idx][row_idx].length <= 1)
		return; 
	var row_dat = table_list[table_idx][row_idx];

	fvt_table_viewer_add_row(table, table.rows.length, row_dat, 'td');
}
function fvt_table_viewer_add_row(table, row_index, row_data, data_item)//data_item = 'th' or 'td'
{
	if (table == undefined)
		return;

	color_1 = table.getAttribute('color_1');
	color_2 = table.getAttribute('color_2');	

	// the rowobj.cloneNode in IE7 is borken, we use workaround instead
	//row = table.rows[1].cloneNode(true);
	//table.appendChild(row);

	// workaround for IE7: use table.insertRow() to create a new row and try to copy attrs/cells from old row
	row = table.insertRow(table.rows.length);
	row.className = table.rows[1].className;
	for(j = 0 ; j < table.rows[1].cells.length ; j++){
           var tmp_cell = table.rows[1].cells[j].cloneNode(true);
           row.appendChild(tmp_cell);
        }

	row.style.display = 'table-row';
	row.onclick = onclick_table_row_select;

	for (var i = 0; i < row_data.length; i ++) {
		var data = row_data[i].split('=');
		row.cells[i].appendChild(document.createTextNode(decodeURIComponent(data[1])));
	}

	if (color_1 != undefined && color_2 == undefined) {
		row.style.backgroundColor = color_1;
	}

	if ((row.rowIndex % 2) == 0) {
		if (table.getAttribute('row_selected_class') == undefined || table.getAttribute('row_selected_class') == '') {
			row.style.backgroundColor = table.getAttribute("color_1");
		} else {
			if (row.cells[1].className != undefined && row.cells[1].className != '') {
				for (var j = 0; j < row.cells.length; j++) 
					row.cells[j].className = table.getAttribute("class_1");
				
			} else if (row.className != undefined && row.className !='') {
				row.className = table.getAttribute("class_1");
			}
		}
	} else {
		if (table.getAttribute('row_selected_class') == undefined || table.getAttribute('row_selected_class') == '') {
			row.style.backgroundColor = table.getAttribute("color_2");
		} else {
			if (row.cells[1].className != undefined && row.cells[1].className != '') {
				for (var j = 0; j < row.cells.length; j++) 
					row.cells[j].className = table.getAttribute("class_2");

			} else if (row.className != undefined && row.className !='') {
				row.className = table.getAttribute("class_2");
			}
		}
	}
}

function fvt_table_viewer(table_id, row_conf_prefix, max_line) 
{
	if (table_id == undefined || table_id == '')
		return;

	table = table_locate(table_id);

	var value;
	for (var attr in fvt_table_attr_config) {
		value = fvt_table_attr_config[attr];
		table.setAttribute(attr, value.toString());
	}

	if (max_line == 0) {
		for (var key in meta_config) {
			if (row_conf_prefix == key.substr(0, row_conf_prefix.length))
				fvt_table_viewer_load_row(table_id, key);
		}
	} else {
		var i=0;
		for (var key in meta_config) {
			if (row_conf_prefix == key.substr(0, row_conf_prefix.length) && i < max_line)
				fvt_table_viewer_load_row(table_id, key);
			i++;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////

function fvt_table_editor_load_row(table_id, tbody_id, key_str)
{	
	if (table_id == '' || table_id == undefined 
			|| tbody_id == '' || tbody_id == undefined
			|| key_str == '' || key_str== undefined)
		return;

	table = table_locate(table_id);

	if (table_id_map[table_id] == undefined)
		table_id_map[table_id] = table_id_map.length;

	var table_idx= table_id_map[table_id];

	// table_list[] is 3 dimension array
	// 1st dimension means table index within all tables
	// 2nd dimention means row index with all rows of specific table
	// 3rd dimension means field index with all fields of specific row of specific table
	table_list[table_idx] = new Array();

	var row_idx = table_list[table_idx].length;
	table_list[table_idx][row_idx] = fvt_meta_config(key_str).split(';');
	if (table_list[table_idx][row_idx].length <= 1)
		return; 

	var row_dat = table_list[table_idx][row_idx];

	fvt_table_editor_add_row(table, tbody_id, table.rows.length, key_str, row_dat, 'td');
}
function fvt_table_editor_add_row(table, tbody_id, row_index, cfg_entry_id, row_data, data_item)//data_item = 'th' or 'td'
{
	if (table == undefined || tbody_id == '' || tbody_id == undefined)
		return;

	color_1 = table.getAttribute('color_1');
	color_2 = table.getAttribute('color_2');

	row = table.rows[1].cloneNode(true);
	row.style.display = 'table-row';
	row.setAttribute("id", cfg_entry_id);
	row.onclick = onclick_table_row_select;
	
	var tbody = document.getElementById(tbody_id);
	tbody.appendChild(row);

	for (var i = 0; i < row_data.length; i++) {
		fvt_table_editor_set_cell(row, row_index, data_item, i, row_data[i]);
	}
	
	if ((row.rowIndex % 2) == 0) {
		if (table.getAttribute('row_selected_class') == undefined || table.getAttribute('row_selected_class') == '') {
			row.style.backgroundColor = table.getAttribute("color_1");
		} else {
			if (row.cells[1].className != undefined && row.cells[1].className != '') {
				for (var j = 0; j < row.cells.length; j++) 
					row.cells[j].className = table.getAttribute("class_1");
				
			} else if (row.className != undefined && row.className !='') {
				row.className = table.getAttribute("class_1");
			}
		}
	} else {
		if (table.getAttribute('row_selected_class') == undefined || table.getAttribute('row_selected_class') == '') {
			row.style.backgroundColor = table.getAttribute("color_2");
		} else {
			if (row.cells[1].className != undefined && row.cells[1].className != '') {
				for (var j = 0; j < row.cells.length; j++) 
					row.cells[j].className = table.getAttribute("class_2");

			} else if (row.className != undefined && row.className !='') {
				row.className = table.getAttribute("class_2");
			}
		}
	}
}
function fvt_table_editor_set_cell(row, row_index, data_item, cell_idx, value)
{
	if (row.hasChildNodes())
		var clist = row.childNodes;
	else 
		return;

	var str_pair = value.toString().split("~");

	for (var i = 0; i < str_pair.length; i++) {
		pair = str_pair[i].split("=");

		// as a tr row may has child othan td, we need to find the cell of Nth td manually
		var cell_index = 0;
		var cell;
		for (var z = 0; z < clist.length; z++) {
			if (clist[z].tagName != undefined && clist[z].tagName.toLowerCase() == 'td') {
				if (cell_index == cell_idx)
					cell = clist[z];	
				cell_index++;
			}
		}

		for (var j = 0;  cell.childNodes[j] != undefined; j++) {
			if (cell.childNodes[j].type == 'text' || cell.childNodes[j].type == 'radio' 
				|| cell.childNodes[j].type == 'checkbox' || cell.childNodes[j].type == 'select-one' 
				|| cell.childNodes[j].type =='password') {
				if (pair[0] == cell.childNodes[j].name) { 
					cell.childNodes[j].style.display = "table-row";
					cell.childNodes[j].name = cell.childNodes[j].name + '$$$'+row.id;
					if (cell.childNodes[j].type == "text" || cell.childNodes[j].type == "password") {
						cell.childNodes[j].setAttribute("value", decodeURIComponent(pair[1]));
					}

					if (cell.childNodes[j].type == "checkbox" && cell.childNodes[j].value.toLowerCase() == pair[1]) {
						cell.childNodes[j].setAttribute('checked', 'true');
					}
					if (cell.childNodes[j].type == "radio" && cell.childNodes[j].value.toLowerCase() == pair[1]) {
						cell.childNodes[j].setAttribute('checked', 'true');
					}
					if (cell.childNodes[j].type == "select-one") {
						for (var z = 0; z < cell.childNodes[j].options.length;z++) {
							if (cell.childNodes[j].options[z].value.toLowerCase() == pair[1]) {
								cell.childNodes[j].options[z].setAttribute('selected', 'true');
							}
						}
					}
				}

			}
		}
	}
}

function fvt_table_editor_sort_row(table_id) 
{
	if (table_id == '' || table_id == undefined)
		return;

	table = document.getElementById(table_id);
	tbody_id = table.getAttribute('tbody_id');

	if (table == undefined)
		return;

	for (var i = 2; i < table.rows.length; i++) {
		var row_id = table.rows[i].id.split('_');
		row_id[row_id.length-1] = (i-1).toString();

		var new_row_id ='';

		var row_id_last = row_id.length -1;
		new_row_id = table.getAttribute('row_conf_prefix') + row_id[ row_id_last ];

		table.rows[i].setAttribute('id', new_row_id);

		if (table.rows[i].parentNode.id == tbody_id) {
			if ((table.rows[i].rowIndex % 2) == 0) {
				if (table.getAttribute('row_selected_class') == undefined || table.getAttribute('row_selected_class') == '') {
					table.rows[i].style.backgroundColor = table.getAttribute("color_1");
				} else {
					if (table.rows[i].cells[1].className != undefined && table.rows[i].cells[1].className != '') {
						for (var j = 0; j < table.rows[i].cells.length; j++) 
							table.rows[i].cells[j].className = table.getAttribute("class_1");
						
					} else if (table.row[i].className != undefined && table.row[i].className !='') {
						table.rows[i].className = table.getAttribute("class_1");
					}
				}
			} else {
				if (table.getAttribute('row_selected_class') == undefined || table.getAttribute('row_selected_class') == '') {
					table.rows[i].style.backgroundColor = table.getAttribute("color_2");
				} else {
					if (table.rows[i].cells[1].className != undefined && table.rows[i].cells[1].className != '') {
						for (var j = 0; j < table.rows[i].cells.length; j++) 
							table.rows[i].cells[j].className = table.getAttribute("class_2");

					} else if (table.rows[i].className != undefined && table.rows[i].className !='') {
						table.rows[i].className = table.getAttribute("class_2");
					}
				}
			}
		}
	
	}
	fvt_table_editor_renew_input_id(table_id);
}
function fvt_table_editor_renew_input_id(table_id)
{
	if (table_id == '' || table_id == undefined)
		return;

	table = document.getElementById(table_id);
	if (table == undefined)
		return;

	for (var i = 2; i < table.rows.length; i++) {
		for(var j = 0; j < table.rows[i].cells.length; j++) {
			row_id = table.rows[i].id;

			for(var k = 0; k < table.rows[i].cells[j].childNodes.length; k++) {
				var node = table.rows[i].cells[j].childNodes[k];
				if (node.nodeType != 1|| node.name == undefined)
					continue;
		
				if (node.type == 'text'|| node.type == 'password' || node.type == 'checkbox' 
					|| node.type == 'radio'|| node.type == 'select-one') {
					var node_name = node.name.split('$$$');
					var node_checked;
					var selectedindex;
					if (node.type == 'checkbox' || node.type == 'radio')
						node_checked = node.getAttribute("checked");
					if ((node.type == 'select-one'))
						selectedindex = node.options.selectedIndex;
					
					node.name = node_name[0] + '$$$' + row_id;
					if (node.type == 'checkbox' || node.type == 'radio') {
						node.checked = node_checked;
					}
					if (node.type == 'select-one')
						node.options.selectedIndex = selectedindex;
				}
			}
		}
	}
}

function fvt_table_editor_insert_row_by_color(table_id, tbody_id, row_conf_prefix) 
{
	if (table_id == '' || table_id == undefined || tbody_id == '' || tbody_id == undefined)
		return;
	table = document.getElementById(table_id);
	color = table.getAttribute('selected_color');

	for (var row_idx = 0; row_idx < table.rows.length; row_idx++) {
		if (table.getAttribute('row_selected_class') == undefined || table.getAttribute('row_selected_class') == '') {
			if (table.rows[row_idx].style.backgroundColor) {
				if (rgbcolor2hex(table.rows[row_idx].style.backgroundColor).toLowerCase() == color.toLowerCase()) {
					fvt_table_editor_insert_row(table_id, tbody_id, row_conf_prefix, row_idx);
				}
			}		
		} else {
			if (table.rows[row_idx].cells[0].className != undefined && table.rows[row_idx].cells[0].className != '') {
				if (table.rows[row_idx].cells[0].className == table.getAttribute("row_selected_class")) {
					fvt_table_editor_insert_row(table_id, tbody_id, row_conf_prefix, row_idx);
				}
			} else if (table.rows[row_idx].className != undefined && table.rows[row_idx].className !='') {
				if (table.rows.className == table.getAttribute("row_selected_class")) {
					fvt_table_editor_insert_row(table_id, tbody_id, row_conf_prefix, row_idx);
				}
			}
		}
	}
	if (table.rows.length < 4) {	
		fvt_table_editor_insert_row_default(table_id, tbody_id, row_conf_prefix, 2);
	}
}
function fvt_table_editor_insert_row_default(table_id, tbody_id, row_conf_prefix, row_idx) 
{
	if (table_id == '' || table_id == undefined || tbody_id == '' || tbody_id == undefined)
		return;
	table = document.getElementById(table_id);
	tbody = document.getElementById(tbody_id);
	if (table== undefined)
		return;
	
   	parent_node = table.rows[1].parentNode.id;
	new_row = table.rows[1].cloneNode(true);
	new_row_id = row_conf_prefix + "1000";

	tbody.appendChild(new_row);
	new_row.style.display = 'table-row';
	new_row.setAttribute("id", new_row_id);
	new_row.style.backgroundColor = new_row.getAttribute('orig_color');
 	fvt_table_editor_sort_row(table_id);
}
function fvt_table_editor_insert_row(table_id, tbody_id, row_conf_prefix, row_idx) 
{
	if (table_id == '' || table_id == undefined || tbody_id == '' || tbody_id == undefined)
		return;
	table = document.getElementById(table_id);
	tbody = document.getElementById(tbody_id);
	if (table== undefined)
		return;

	row = table.rows[row_idx];
	row_id = row.id;
	
	new_row = table.rows[1].cloneNode(true);
	new_row_id = row_conf_prefix+'1000';

	tbody.insertBefore(new_row, row);

	new_row.style.display = 'table-row';
	new_row.setAttribute("id", new_row_id);
	new_row.onclick = onclick_table_row_select;

	table.rows[row_idx+1].style.backgroundColor = table.rows[row_idx+1].getAttribute('orig_color');
 	fvt_table_editor_sort_row(table_id);
}

function fvt_table_editor_delete_row(row_id) 
{
	row = document.getElementById(row_id);
	if (row == undefined)
		return;

	row_idx = row.rowIndex
	if (row_idx == undefined)
		return;

	table = row.parentNode;	
	if (table.tagName.toLowerCase() != 'table')
		table = table.parentNode;

	if (table== undefined)
		return;
	var table_id = table.id
	table.deleteRow(row_idx);
 	fvt_table_editor_sort_row(table_id);
}

function fvt_table_editor_submit_form(form_name, table_id)
{
	if (form_name == '' || form_name == undefined)
		return;

	fvt_paramlist_cat_table_str(table_id);
	fvt_paramlist_presubmit(form_name);
	
	//document.getElementById('n').innerHTML = document.getElementById('n').innerHTML + form_name+ "   " + table_id +" " + fvt_paramlist +'<br>';
	form = document.forms[form_name];
	form.submit();
}

function onclick_table_editor_insert(e)
{
//	table = e.target.parentNode;
	
	table = this.parentNode;
	while (table.tagName.toLowerCase() != 'table')
		table = table.parentNode;

	if (table != undefined && table.tagName.toLowerCase() == 'table') {
		tbody = document.getElementById(table.getAttribute('tbody_id'));
		row_conf_prefix = table.getAttribute('row_conf_prefix');
		fvt_table_editor_insert_row_by_color(table.id, tbody.id, row_conf_prefix);
	}
}
function onclick_table_editor_delete(e)
{
	table = this.parentNode;
	while (table.tagName.toLowerCase() != 'table')
		table = table.parentNode;

	var tbody;
	if (table != undefined && table.tagName.toLowerCase() == 'table') {
		tbody = document.getElementById(table.getAttribute('tbody_id'));
		row_conf_prefix = document.getElementById(table.getAttribute('row_conf_prefix'));
	}

	if (table.rows.length > 3) {
		for (var i = 2; i < table.rows.length-1; i++) {
			if (table.getAttribute('row_selected_class') == undefined || table.getAttribute('row_selected_class') == '') {
				if (table.rows[i].style.backgroundColor) {
					if (rgbcolor2hex(table.rows[i].style.backgroundColor).toLowerCase() == color.toLowerCase()) {
						fvt_table_editor_delete_row(table.rows[i].id);
					}
				}		
			} else {
				if (table.rows[i].cells[0].className != undefined && table.rows[i].cells[0].className != '') {
					if (table.rows[i].cells[0].className == table.getAttribute("row_selected_class")) {
						fvt_table_editor_delete_row(table.rows[i].id);
					}
				} else if (table.rows[i].className != undefined && table.rows[i].className !='') {
					if (table.rows.className == table.getAttribute("row_selected_class")) {
						fvt_table_editor_delete_row(table.rows[i].id);
					}
				}
			}
		}
	}
}
function onclick_table_editor_submit(e)
{
	table = this.parentNode;
	while (table.tagName.toLowerCase() != 'table')
		table = table.parentNode;

	form = this.parentNode;
	while (form.tagName.toLowerCase() != 'form')
		form = form.parentNode;
	
	if (form != undefined && table != undefined)
		fvt_table_editor_submit_form(form.name, table.id);
}

function fvt_table_editor(table_id, tbody_id, row_conf_prefix) 
{
	table = document.getElementById(table_id);

	var value;
	for (var attr in fvt_table_attr_config) {
		value = fvt_table_attr_config[attr];
		table.setAttribute(attr, value);
	}

	table.setAttribute('row_conf_prefix', row_conf_prefix);
	table.setAttribute('tbody_id', tbody_id);

	var key_len;
	for (var key in meta_config) {
		if (row_conf_prefix == key.substr(0, row_conf_prefix.length))
			fvt_table_editor_load_row(table_id, tbody_id, key );
	}

	second_tbody= document.createElement('tbody'); 

	row = document.createElement('tr'); 
	cell = document.createElement('td');
	cell.colSpan = 3;	
	
	insert_button = document.createElement('input'); 
	insert_button.setAttribute('type', 'button');
	insert_button.setAttribute('name', 'insert_button');
	insert_button.setAttribute('value', fvt_table_attr_config['insert_button']);
	insert_button.onclick = onclick_table_editor_insert;

	delete_button = document.createElement('input'); 
	delete_button.setAttribute('type', 'button');
	delete_button.setAttribute('name', 'delete_button');
	delete_button.setAttribute('value', fvt_table_attr_config['delete_button']);
	delete_button.onclick = onclick_table_editor_delete;

	submit_button = document.createElement('input'); 
	submit_button.setAttribute('type', 'button');
	submit_button.setAttribute('name', 'submit_button');
	submit_button.setAttribute('value', fvt_table_attr_config['submit_button']);
	submit_button.onclick = onclick_table_editor_submit;

	table.appendChild(second_tbody);
	second_tbody.appendChild(row);
	row.appendChild(cell);
	cell.appendChild(insert_button);
	cell.appendChild(delete_button);
	cell.appendChild(submit_button);
}

function fvt_table_editor_get(table_id) 
{
	var table_param='';
	var row_param = new Array();
	var row_key;
	var rules = 0;
	var rows =0;
	
	if (table_id == '' || table_id == undefined)
		return;	
	
	table = document.getElementById(table_id);

	row_conf_prefix = table.getAttribute('row_conf_prefix');

	for (var entry_key in meta_config) {
		if (row_conf_prefix == entry_key.substr(0, row_conf_prefix.length))
			rules++;
	}

	for (var i = 2; i < table.rows.length-1; i++) {
		var row_str="";
		var input_name="";
		var input_value="";

		for(var j = 0; j < table.rows[i].cells.length; j++) {
			var cell_str = '';
			for(var k = 0; k < table.rows[i].cells[j].childNodes.length; k++) {
				var node = table.rows[i].cells[j].childNodes[k];
				if (node.nodeType != 1|| node.name == undefined)
					continue;
		
				if ((node.type == 'text'|| node.type == 'password') && node.value != undefined) {
					input_name = node.name.split('$$$');
					input_value = node.value;
				}

				if (node.type == 'checkbox' && node.name != undefined && node.value != undefined) {
					if (node.checked == true) {
						input_name = node.name.split('$$$');
						input_value = node.value;
					} else
						continue;
				}

				if (node.type == 'radio' && node.value != undefined) {
					if (node.checked == true) {
						input_name = node.name.split('$$$');
						input_value = node.value;
					} else
						continue;
				}

				if (node.type == 'select-one' && node.value != undefined) {
					var selectedindex = node.options.selectedIndex;
					input_name = node.name.split('$$$');
					input_value = node.options[selectedindex].value;
				}
				// escape one cell & merge cells
				if (cell_str == "") {
					cell_str = input_name[0] +"="+ encodeURIComponent(input_value);	
				} else {
					cell_str = cell_str + "~" + input_name[0] +"="+ encodeURIComponent(input_value);
				}
			}

			if (j == 0)	// 1st cell
				row_param[table.rows[i].id] = cell_str + ';';
			else if (j == table.rows[i].cells.length -1)	// last cell
				row_param[table.rows[i].id] = row_param[table.rows[i].id]+ cell_str;
			else
				row_param[table.rows[i].id] = row_param[table.rows[i].id]+ cell_str + ';';
		}

	}

	for (var key in row_param) {
		// escape table line
		if (table_param == '') {
			table_param = key + '='+ escape(row_param[key]);
			rows++;
		} else {
			table_param = table_param + '^^^'+ key + '='+ encodeURIComponent(row_param[key]);
			rows++;
		}
	}

	for (var i = rows; i < rules; i++) 
		table_param += '^^^'+row_conf_prefix+(i+1)+'=';
	
	return table_param;
}

////////////////////////////////////////////////////////////////////////////////////////////////

function fvt_form_sample_js_show() 
{	
	var total=0;

	for (var i = 0; i < document.forms.length; i++) {
		for (var j = 0; j < document.forms[i].elements.length; j++) {
			total++;
		}
	}
	if (total==0)
		return;
	
	document.write("&nbsp;<br>\n");
	document.write("<div><pre>\n");
	document.write("&lt;script language=\"JavaScript\"&gt;\n&lt;!--\n");

	document.write("function fvt_form_init(form_name) \n{\n");
	for (var i = 0; i < document.forms.length; i++) {
		if (i==0) {
			document.write("\tif (form_name=='"+document.forms[i].name+"' || form_name=='*') {\n");
		} else {
			document.write("\t} else if (form_name=='"+document.forms[i].name+"' || form_name=='*') {\n");
		}
		for (var j = 0; j < document.forms[i].elements.length; j++) {
			if (document.forms[i].elements[j].type == undefined)
				continue;
			if (document.forms[i].elements[j].type == 'checkbox'
				|| document.forms[i].elements[j].type == 'radio'
				|| document.forms[i].elements[j].type == 'select-one'
				|| document.forms[i].elements[j].type == 'text'
				|| document.forms[i].elements[j].type == 'file'
				|| document.forms[i].elements[j].type == 'password'
				|| (document.forms[i].elements[j].type == 'hidden' && document.forms[i].elements[j].name != 'wwwctrl_paramlist')
				)
				document.write("\t\tfvt_form_obj_set(\""+document.forms[i].name + "\", \"" +document.forms[i].elements[j].name +"\", fvt_meta_config(''));"+"\t\t//"+document.forms[i].elements[j].type+"\n");
			
		}
	}
	document.write("\t}\n");
	document.write("}\n");

	document.write("\n");
	document.write("function fvt_form_submit(form_name) \t{\n");
	document.write("\tfvt_paramlist_clear();\n");

	for (var i = 0; i < document.forms.length; i++) {
		if (i==0) {
			document.write("\tif (form_name=='"+document.forms[i].name+"' || form_name=='*') {\n");
		} else {
			document.write("\t} else if (form_name=='"+document.forms[i].name+"' || form_name=='*') {\n");
		}
		for (var j = 0; j < document.forms[i].elements.length; j++) {
			if (document.forms[i].elements[j].type == undefined)
				continue;
			if (document.forms[i].elements[j].type == 'checkbox'
				|| document.forms[i].elements[j].type == 'radio'
				|| document.forms[i].elements[j].type == 'select-one'
				|| document.forms[i].elements[j].type == 'text'
				|| document.forms[i].elements[j].type == 'file'
				|| document.forms[i].elements[j].type == 'password'
				|| (document.forms[i].elements[j].type == 'hidden' && document.forms[i].elements[j].name != 'wwwctrl_paramlist')
				)
				document.write("\t\tfvt_paramlist_cat_str('', fvt_form_obj_get(\""+document.forms[i].name + "\", \"" +document.forms[i].elements[j].name +"\"));"+"\t\t//"+document.forms[i].elements[j].type+"\n");
		}
	}
	document.write("\t}\n");
	document.write("\tfvt_paramlist_presubmit(form_name);\n");
	document.write("}\n\n\n");

	document.write("//--&gt;\n&lt;/script&gt;\n");
	document.write("</pre></div>\n");
}

function fvt_meta_config(key)
{
	if (meta_config[key] == undefined) {	// aggregate multiple line into one value
		var content='';
		for (var key2 in meta_config) {
			if (key == key2.substr(0, key.length)) {
				var postfix=key2.substr(key.length);
				if (parseInt(postfix) != NaN) {
					content = content + decodeURIComponent(meta_config[key2]) + "\n";
				}
			}
		}
		return content;
	} else {
		return decodeURIComponent(meta_config[key]);
	}
}
