-- Save this to /usr/lib/lua/luci/controller/myapp/mymodule.lua
-- Browse to: /cgi-bin/luci/myapp/mymodule/

module("luci.controller.myapp.mymodule", package.seeall)

function index()
  page = entry({"myapp", "mymodule"}, 
               alias("myapp", "mymodule", "time.htm"), "My Module")
  page.dependent = false

  page = entry({"myapp", "mymodule", "time.htm"}, 
               template("myapp_mymodule/time"), "Time")    
  page = entry({"myapp", "mymodule","traffic"},
		cbi("myapp/traffic"),"Traffic")
  page.dependent = false; page.leaf = true        
end
 

