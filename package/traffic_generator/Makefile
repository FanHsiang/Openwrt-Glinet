include $(TOPDIR)/rules.mk

PKG_NAME:=traffic_generator
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk


define Package/traffic_generator
	SECTION:=utils
	CATEGORY:=Utilities
	DEPENDS:=+libpcap
	TITLE:=Traffic_generator
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Package/traffic_generator/install
	$(INSTALL_DIR) $(1)/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/traffic_generator $(1)/bin/
endef

$(eval $(call BuildPackage,traffic_generator))

