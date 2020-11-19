#
# Makefile to build NEUTRINO-PLUGINS
#

#
# links
#
LINKS_VER = 2.7
LINKS_PATCH  = links-$(LINKS_VER).patch
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), spark spark7162))
LINKS_PATCH += links-$(LINKS_VER)-spark-input.patch
endif

$(ARCHIVE)/links-$(LINKS_VER).tar.bz2:
	$(WGET) http://links.twibright.com/download/links-$(LINKS_VER).tar.bz2

$(D)/links: $(D)/bootstrap $(D)/libpng $(D)/openssl $(ARCHIVE)/links-$(LINKS_VER).tar.bz2
	$(START_BUILD)
	$(REMOVE)/links-$(LINKS_VER)
	$(UNTAR)/links-$(LINKS_VER).tar.bz2
	$(CHDIR)/links-$(LINKS_VER); \
		$(call apply_patches, $(LINKS_PATCH)); \
		$(CONFIGURE) \
			--prefix= \
			--mandir=/.remove \
			--without-libtiff \
			--without-svgalib \
			--with-fb \
			--without-directfb \
			--without-pmshell \
			--without-atheos \
			--enable-graphics \
			--enable-javascript \
			--with-ssl=$(TARGET_DIR)/usr \
			--without-x \
		; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	mkdir -p $(TARGET_DIR)/var/tuxbox/plugins $(TARGET_DIR)/var/tuxbox/config/links
	mv $(TARGET_DIR)/bin/links $(TARGET_DIR)/var/tuxbox/plugins/links.so
	echo "name=Links Web Browser"	 > $(TARGET_DIR)/var/tuxbox/plugins/links.cfg
	echo "desc=Web Browser"		>> $(TARGET_DIR)/var/tuxbox/plugins/links.cfg
	echo "type=2"			>> $(TARGET_DIR)/var/tuxbox/plugins/links.cfg
	echo "bookmarkcount=0"		 > $(TARGET_DIR)/var/tuxbox/config/bookmarks
	touch $(TARGET_DIR)/var/tuxbox/config/links/links.his
	cp -a $(SKEL_ROOT)/var/tuxbox/config/links/bookmarks.html $(SKEL_ROOT)/var/tuxbox/config/links/tables.tar.gz $(TARGET_DIR)/var/tuxbox/config/links
	$(REMOVE)/links-$(LINKS_VER)
	$(TOUCH)

#
# xupnpd
#
XUPNPD_PATCH = xupnpd.patch

$(D)/xupnpd \
$(D)/neutrino-mp-plugin-xupnpd: $(D)/bootstrap $(D)/lua $(D)/openssl $(D)/neutrino-mp-plugin-scripts-lua
	$(START_BUILD)
	$(REMOVE)/xupnpd
	set -e; if [ -d $(ARCHIVE)/xupnpd.git ]; \
		then cd $(ARCHIVE)/xupnpd.git; git pull; \
		else cd $(ARCHIVE); git clone git://github.com/clark15b/xupnpd.git xupnpd.git; \
		fi
	cp -ra $(ARCHIVE)/xupnpd.git $(BUILD_TMP)/xupnpd
	$(CHDIR)/xupnpd; \
		$(call apply_patches, $(XUPNPD_PATCH))
	$(CHDIR)/xupnpd/src; \
		$(BUILDENV) \
		$(MAKE) embedded TARGET=$(TARGET) PKG_CONFIG=$(PKG_CONFIG) LUAFLAGS="$(TARGET_LDFLAGS) -I$(TARGET_INCLUDE_DIR)"; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	install -m 755 $(SKEL_ROOT)/etc/init.d/xupnpd $(TARGET_DIR)/etc/init.d/
	mkdir -p $(TARGET_DIR)/usr/share/xupnpd/config
	rm $(TARGET_DIR)/usr/share/xupnpd/plugins/staff/xupnpd_18plus.lua
	install -m 644 $(ARCHIVE)/plugin-scripts-lua.git/xupnpd/xupnpd_18plus.lua ${TARGET_DIR}/usr/share/xupnpd/plugins/
	install -m 644 $(ARCHIVE)/plugin-scripts-lua.git/xupnpd/xupnpd_cczwei.lua ${TARGET_DIR}/usr/share/xupnpd/plugins/
	: install -m 644 $(ARCHIVE)/plugin-scripts-lua.git/xupnpd/xupnpd_coolstream.lua ${TARGET_DIR}/usr/share/xupnpd/plugins/
	install -m 644 $(ARCHIVE)/plugin-scripts-lua.git/xupnpd/xupnpd_youtube.lua ${TARGET_DIR}/usr/share/xupnpd/plugins/
	$(REMOVE)/xupnpd
	$(TOUCH)

#
# neutrino-iptvplayer
#
$(D)/neutrino-mp-plugin-iptvplayer-nightly \
$(D)/neutrino-mp-plugin-iptvplayer: $(D)/librtmp $(D)/python_twisted_small
	$(START_BUILD)
	$(REMOVE)/iptvplayer
	set -e; if [ -d $(ARCHIVE)/iptvplayer.git ]; \
		then cd $(ARCHIVE)/iptvplayer.git; git pull; \
		else cd $(ARCHIVE); git clone https://github.com/TangoCash/crossplatform_iptvplayer.git iptvplayer.git; \
		fi
	cp -ra $(ARCHIVE)/iptvplayer.git $(BUILD_TMP)/iptvplayer
	@if [ "$@" = "$(D)/neutrino-mp-plugin-iptvplayer-nightly" ]; then \
		$(BUILD_TMP)/iptvplayer/SyncWithGitLab.sh $(BUILD_TMP)/iptvplayer; \
	fi
	install -d $(TARGET_DIR)/var/tuxbox/plugins
	install -d $(TARGET_DIR)/usr/share/E2emulator
	cp -R $(BUILD_TMP)/iptvplayer/E2emulator/* $(TARGET_DIR)/usr/share/E2emulator/
	install -d $(TARGET_DIR)/usr/share/E2emulator/Plugins/Extensions/IPTVPlayer
	cp -R $(BUILD_TMP)/iptvplayer/IPTVplayer/* $(TARGET_DIR)/usr/share/E2emulator//Plugins/Extensions/IPTVPlayer/
	cp -R $(BUILD_TMP)/iptvplayer/IPTVdaemon/* $(TARGET_DIR)/usr/share/E2emulator//Plugins/Extensions/IPTVPlayer/
	chmod 755 $(TARGET_DIR)/usr/share/E2emulator/Plugins/Extensions/IPTVPlayer/cmdlineIPTV.*
	chmod 755 $(TARGET_DIR)/usr/share/E2emulator/Plugins/Extensions/IPTVPlayer/IPTVdaemon.*
	PYTHONPATH=$(TARGET_DIR)/$(PYTHON_DIR) \
	$(HOST_DIR)/bin/python$(PYTHON_VER_MAJOR) -Wi -t -O $(TARGET_DIR)/$(PYTHON_DIR)/compileall.py \
		-d /usr/share/E2emulator -f -x badsyntax $(TARGET_DIR)/usr/share/E2emulator
	cp -R $(BUILD_TMP)/iptvplayer/addon4neutrino/neutrinoIPTV/* $(TARGET_DIR)/var/tuxbox/plugins/
	$(REMOVE)/iptvplayer
	$(TOUCH)

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


