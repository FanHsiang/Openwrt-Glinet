include $(TOPDIR)/rules.mk

PKG_NAME:=MCL_test
PKG_VERSION=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/MCL_test
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=MCL_test
endef

define Package/MCL_test/description
	This package contains MCL test script
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/MCL_test/install
	$(INSTALL_DIR) $(1)
	
	$(INSTALL_DATA) ./MCL_test/snmp/* $(1)
	$(INSTALL_DATA) ./MCL_test/tftp/* $(1)
endef

$(eval $(call BuildPackage,MCL_test))
