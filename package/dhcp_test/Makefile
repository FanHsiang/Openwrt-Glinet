include $(TOPDIR)/rules.mk

PKG_NAME:=dhcp_test
PKG_VERSION=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/dhcp_test
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=dhcp_test
endef

define Package/dhcp_test/description
	This package contains dhcp option 60/61/125 test script
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/dhcp_test/install
	$(INSTALL_DIR) $(1)
	
	$(INSTALL_DATA) ./dhcp_test/* $(1)
endef

$(eval $(call BuildPackage,dhcp_test))
