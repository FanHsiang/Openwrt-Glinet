-- Save this to /usr/lib/lua/luci/controller/myapp/index.lua
-- Browse to: /cgi-bin/luci/myapp/

module("luci.controller.myapp.index", package.seeall)

function index()
  page = entry({"myapp"}, cbi("myapp/traffic"),"Traffic")
  page.dependent = false

  page.sysauth = "root"
  page.sysauth_authenticator = "htmlauth"    

  entry({"myapp", "logout"}, call("action_logout"), "Logout")
end

function action_logout()
        local dsp = require "luci.dispatcher"
        local utl = require "luci.util"
        local sid = dsp.context.authsession

        if sid then
                utl.ubus("session", "destroy", { ubus_rpc_session = sid })

                dsp.context.urltoken.stok = nil

                luci.http.header("Set-Cookie", "sysauth=%s; expires=%s; path=%s/" %{
                        sid, 'Thu, 01 Jan 1970 01:00:00 GMT', dsp.build_url()
                })
        end

        luci.http.redirect(luci.dispatcher.build_url())
end

