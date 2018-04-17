include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-traffic_GUI
PKG_VERSION=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-traffic_GUI
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=Traffic Generator GUI
	PKGARCH:=all
endef

define Package/luci-app-traffic_GUI/description
	This package contains LuCI configuration pages for Traffic Generator
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-traffic_GUI/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/myapp
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/myapp
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/myapp
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/myapp_mymodule
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/admin_system
	
	$(INSTALL_CONF) ./files/root/etc/config/traffic $(1)/etc/config/traffic
	$(INSTALL_DATA) ./files/root/usr/lib/lua/luci/model/cbi/myapp/traffic.lua $(1)/usr/lib/lua/luci/model/cbi/myapp/traffic.lua
	$(INSTALL_DATA) ./files/root/usr/lib/lua/luci/controller/traffic_generator.lua $(1)/usr/lib/lua/luci/controller/traffic_generator.lua
	$(INSTALL_DATA) ./files/root/usr/lib/lua/luci/controller/myapp/index.lua $(1)/usr/lib/lua/luci/controller/myapp/index.lua
	$(INSTALL_DATA) ./files/root/usr/lib/lua/luci/controller/myapp/mymodule.lua $(1)/usr/lib/lua/luci/controller/myapp/mymodule.lua
	$(INSTALL_DATA) ./files/root/usr/lib/lua/luci/view/myapp_mymodule/time.htm $(1)/usr/lib/lua/luci/view/myapp_mymodule/time.htm
	$(INSTALL_DATA) ./files/root/usr/lib/lua/luci/view/admin_system/traffic_generator.htm $(1)/usr/lib/lua/luci/view/admin_system/traffic_generator.htm
endef

$(eval $(call BuildPackage,luci-app-traffic_GUI))
