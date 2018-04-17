-- Save this to /usr/lib/lua/luci/model/cbi/myapp/traffic.lua
local fs = require "nixio.fs"
require "luci.sys"
local m = nil

if fs.access("/etc/config/traffic") then 
  m = Map("traffic", "Traffic Generator", 
            "Configure the header to generator package") 
            
  s = m:section(NamedSection, "main", translate("Main Settings"))
  o = s:option(Value, "package_num", translate("Quantity"))
  o = s:option(Value, "type", translate("Type"))
  o = s:option(Value, "srcMAC", translate("Source MAC"))
  o = s:option(Value, "desMAC", translate("Destination MAC"))
  o = s:option(Value, "srcIP", translate("Source IP"))
  o = s:option(Value, "desIP", translate("Destination IP"))
  o = s:option(Value, "vlan", translate("VLAN ID"))
  o = s:option(Value, "pbit", translate("PBIT ID"))
  local apply = luci.http.formvalue("cbi.apply") 
  if apply then
    local package_num = m.uci:get("traffic", "main", "package_num")
    local type = m.uci:get("traffic", "main", "type")
    local srcMAC = m.uci:get("traffic", "main", "srcMAC")
    local desMAC = m.uci:get("traffic", "main", "desMAC")
    local srcIP = m.uci:get("traffic", "main", "srcIP")
    local desIP = m.uci:get("traffic", "main", "desIP")
    local vlan = m.uci:get("traffic", "main", "vlan")
    local pbit = m.uci:get("traffic", "main", "pbit")

    local str = string.format("traffic_generator %s eth0 %s %s %s %s %s %s %s",
                package_num, type, srcMAC, desMAC, srcIP, desIP, vlan, pbit)
    os.execute(str)                
  end

end

return m

