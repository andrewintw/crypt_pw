include $(TOPDIR)/rules.mk

PKG_NAME:=crypt_pw
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/crypt_pw
  CATEGORY:=Properties
  SUBMENU:=Packages
  TITLE:=generate encrypted password
  DEPENDS:=
endef

define Package/crypt_pw/description
generate encrypted password string
endef

define Build/Prepare
	$(call Build/Prepare/Default)
endef

TARGET_CFLAGS +=
TARGET_LDFLAGS += -lcrypt

define Build/Compile
	$(call Build/Compile/Default)
endef

define Build/InstallDev
endef

define Package/crypt_pw/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/crypt_pw 	$(1)/usr/bin/
	$(INSTALL_BIN) ./files/chshadowpw.sh 		$(1)/usr/bin/
endef

$(eval $(call BuildPackage,crypt_pw))

