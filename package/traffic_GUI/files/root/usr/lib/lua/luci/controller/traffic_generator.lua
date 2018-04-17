module("luci.controller.traffic_generator",package.seeall)

function index()
    entry({"admin","system","traffic_generator"},alias("admin","system","traffic_generator.htm"),_("Traffic Generator")).index=true
    entry({"admin","system","traffic_generator"},template("admin_system/traffic_generator"),"Traffic Generator").index=true
end
function action_clock_status()
        local set = tonumber(luci.http.formvalue("set"))
        if set ~= nil and set > 0 then
                local date = os.date("*t", set)
                if date then
                        luci.sys.call("date -s '%04d-%02d-%02d %02d:%02d:%02d'" %{
                                date.year, date.month, date.day, date.hour, date.min, date.sec
                        })
                end
        end

        luci.http.prepare_content("application/json")
        luci.http.write_json({ timestring = os.date("%c") })
end
