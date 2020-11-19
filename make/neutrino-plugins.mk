#
# Makefile to build NEUTRINO-PLUGINS
#

#
# neutrinohd2 plugins
#
NEUTRINO_HD2_PLUGINS_PATCHES =

$(D)/neutrinohd2-plugins.do_prepare:
	$(START_BUILD)
	rm -rf $(SOURCE_DIR)/neutrinohd2-plugins
	ln -s $(SOURCE_DIR)/neutrinohd2.git/plugins $(SOURCE_DIR)/neutrinohd2-plugins
	set -e; cd $(SOURCE_DIR)/neutrinohd2-plugins; \
		$(call apply_patches, $(NEUTRINO_HD2_PLUGINS_PATCHES))
	@touch $@

$(D)/neutrinohd2-plugins.config.status: $(D)/bootstrap neutrino
	cd $(SOURCE_DIR)/neutrinohd2-plugins; \
		./autogen.sh; \
		$(BUILDENV) \
		./configure $(SILENT_OPT) \
			--host=$(TARGET) \
			--build=$(BUILD) \
			--prefix= \
			--with-target=cdk \
			--with-boxtype=$(BOXTYPE) \
			--with-plugindir=/var/tuxbox/plugins \
			--with-datadir=/usr/share/tuxbox \
			--with-configdir=/var/tuxbox/config \
			--enable-silent-rules \
			$(NHD2_OPTS) \
			PKG_CONFIG=$(PKG_CONFIG) \
			PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
			CPPFLAGS="$(CPPFLAGS) -I$(driverdir) -I$(KERNEL_DIR)/include -I$(TARGET_DIR)/include" \
			LDFLAGS="$(TARGET_LDFLAGS)"
	@touch $@

$(D)/neutrinohd2-plugins.do_compile: $(D)/neutrinohd2-plugins.config.status
	cd $(SOURCE_DIR)/neutrinohd2-plugins; \
	$(MAKE) top_srcdir=$(SOURCE_DIR)/neutrinohd2
	@touch $@

$(D)/neutrinohd2-plugins.build: neutrinohd2-plugins.do_prepare neutrinohd2-plugins.do_compile
	$(MAKE) -C $(SOURCE_DIR)/neutrinohd2-plugins install DESTDIR=$(TARGET_DIR) top_srcdir=$(SOURCE_DIR)/neutrinohd2
	$(TOUCH)

neutrino-plugins-clean:
	cd $(SOURCE_DIR)/neutrinohd2-plugins; \
	$(MAKE) clean
	rm -f $(D)/neutrinohd2-plugins.build
	rm -f $(D)/neutrinohd2-plugins.config.status

neutrino-plugins-distclean:
	rm -f $(D)/neutrinohd2-plugins.build
	rm -f $(D)/neutrinohd2-plugins.config.status
	rm -f $(D)/neutrinohd2-plugins.do_prepare
	rm -f $(D)/neutrinohd2-plugins.do_compile


