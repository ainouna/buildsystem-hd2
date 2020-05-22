#
# Makefile to build NEUTRINO
#
$(TARGET_DIR)/.version:
	echo "imagename=neutrinoHD2" > $@
	echo "homepage=https://github.com/mohousch" >> $@
	echo "creator=$(MAINTAINER)" >> $@
	echo "docs=https://github.com/mohousch" >> $@
	echo "forum=https://github.com/mohousch/neutrinohd2" >> $@
	echo "version=0200`date +%Y%m%d%H%M`" >> $@
	echo "git=`git log | grep "^commit" | wc -l`" >> $@

#AUDIODEC = ffmpeg

NEUTRINO_DEPS  = $(D)/bootstrap $(KERNEL) $(D)/system-tools
NEUTRINO_DEPS += $(D)/ncurses $(LIRC) $(D)/libcurl
NEUTRINO_DEPS += $(D)/libpng $(D)/libjpeg $(D)/giflib $(D)/freetype
NEUTRINO_DEPS += $(D)/ffmpeg
NEUTRINO_DEPS += $(D)/libfribidi

ifeq ($(INTERFACE), python)
NEUTRINO_DEPS += $(D)/python
endif
ifeq ($(INTERFACE), lua)
NEUTRINO_DEPS += $(D)/lua $(D)/luaexpat $(D)/luacurl $(D)/luasocket $(D)/luafeedparser $(D)/luasoap $(D)/luajson
endif
ifeq ($(INTERFACE), lua-python)
NEUTRINO_DEPS += $(D)/lua $(D)/luaexpat $(D)/luacurl $(D)/luasocket $(D)/luafeedparser $(D)/luasoap $(D)/luajson
NEUTRINO_DEPS += $(D)/python
endif

NEUTRINO_DEPS += $(LOCAL_NEUTRINO_DEPS)

ifeq ($(BOXTYPE), $(filter $(BOXTYPE), atevio7500 spark spark7162 ufs912 ufs913 ufs910))
NEUTRINO_DEPS += $(D)/ntfs_3g
ifneq ($(BOXTYPE), $(filter $(BOXTYPE), ufs910))
NEUTRINO_DEPS += $(D)/mtd_utils
NEUTRINO_DEPS += $(D)/gptfdisk
endif
endif

ifeq ($(BOXARCH), arm)
NEUTRINO_DEPS += $(D)/ntfs_3g
NEUTRINO_DEPS += $(D)/gptfdisk
NEUTRINO_DEPS += $(D)/mc
endif

ifeq ($(IMAGE), neutrino-wlandriver)
NEUTRINO_DEPS += $(D)/wpa_supplicant $(D)/wireless_tools
endif

NEUTRINO_DEPS2 = $(D)/libid3tag $(D)/libmad $(D)/flac

N_CFLAGS       = -Wall -W -Wshadow -pipe -Os
N_CFLAGS      += -D__KERNEL_STRICT_NAMES
N_CFLAGS      += -D__STDC_FORMAT_MACROS
N_CFLAGS      += -D__STDC_CONSTANT_MACROS
N_CFLAGS      += -fno-strict-aliasing -funsigned-char -ffunction-sections -fdata-sections
N_CFLAGS      += $(LOCAL_NEUTRINO_CFLAGS)

N_CPPFLAGS     = -I$(TARGET_DIR)/usr/include
N_CPPFLAGS    += -ffunction-sections -fdata-sections

ifeq ($(BOXARCH), arm)
N_CPPFLAGS    += -I$(CROSS_BASE)/$(TARGET)/sys-root/usr/include
endif

ifeq ($(BOXARCH), sh4)
N_CPPFLAGS    += -I$(DRIVER_DIR)/bpamem
N_CPPFLAGS    += -I$(KERNEL_DIR)/include
endif

ifeq ($(BOXTYPE), $(filter $(BOXTYPE), spark spark7162))
N_CPPFLAGS += -I$(DRIVER_DIR)/frontcontroller/aotom_spark
endif

N_CONFIG_OPTS  = $(LOCAL_NEUTRINO_BUILD_OPTIONS)
N_CONFIG_OPTS += --with-boxtype=$(BOXTYPE)

NEUTRINO_DEPS += $(D)/libid3tag
NEUTRINO_DEPS += $(D)/libmad
NEUTRINO_DEPS += $(D)/libvorbisidec
NEUTRINO_DEPS += $(D)/flac

ifeq ($(INTERFACE), python)
NHD2_OPTS += --enable-python
endif
ifeq ($(INTERFACE), lua)
NHD2_OPTS += --enable-lua
endif
ifeq ($(INTERFACE), lua-python)
NHD2_OPTS += --enable-lua
NHD2_OPTS += --enable-python
endif

ifeq ($(MEDIAFW), gstreamer)
NEUTRINO_DEPS  += $(D)/gst_plugins_dvbmediasink
N_CPPFLAGS     += $(shell $(PKG_CONFIG) --cflags --libs gstreamer-1.0)
N_CPPFLAGS     += $(shell $(PKG_CONFIG) --cflags --libs gstreamer-audio-1.0)
N_CPPFLAGS     += $(shell $(PKG_CONFIG) --cflags --libs gstreamer-video-1.0)
N_CPPFLAGS     += $(shell $(PKG_CONFIG) --cflags --libs glib-2.0)
NHD2_OPTS += --enable-gstreamer --with-gstversion=1.0
endif

ifeq ($(CICAM), ci-cam)
NHD2_OPTS += --enable-ci
endif

ifeq ($(SCART), scart)
NHD2_OPTS += --enable-scart
endif

ifeq ($(LCD), lcd)
NHD2_OPTS += --enable-lcd
endif

ifeq ($(LCD), 4-digits)
NHD2_OPTS += --enable-4digits
endif

ifeq ($(FKEYS), fkeys)
NHD2_OPTS += --enable-functionkeys
endif

NEUTRINO_HD2_PATCHES =

$(D)/neutrinohd2.do_prepare: | $(NEUTRINO_DEPS) $(NEUTRINO_DEPS2)
	$(START_BUILD)
	rm -rf $(SOURCE_DIR)/neutrinohd2
	rm -rf $(SOURCE_DIR)/neutrinohd2.org
	rm -rf $(SOURCE_DIR)/neutrinohd2.git
	[ -d "$(ARCHIVE)/neutrinohd2.git" ] && \
	(cd $(ARCHIVE)/neutrinohd2.git; git pull;); \
	[ -d "$(ARCHIVE)/neutrinohd2.git" ] || \
	git clone https://github.com/mohousch/neutrinohd2.git $(ARCHIVE)/neutrinohd2.git; \
	cp -ra $(ARCHIVE)/neutrinohd2.git $(SOURCE_DIR)/neutrinohd2.git; \
	ln -s $(SOURCE_DIR)/neutrinohd2.git/nhd2-exp $(SOURCE_DIR)/neutrinohd2;\
	cp -ra $(SOURCE_DIR)/neutrinohd2.git/nhd2-exp $(SOURCE_DIR)/neutrinohd2.org
	set -e; cd $(SOURCE_DIR)/neutrinohd2; \
		$(call apply_patches,$(NEUTRINO_HD2_PATCHES))
	@touch $@

$(D)/neutrinohd2.config.status:
	cd $(SOURCE_DIR)/neutrinohd2; \
		./autogen.sh; \
		$(BUILDENV) \
		./configure \
			--build=$(BUILD) \
			--host=$(TARGET) \
			--enable-silent-rules \
			--with-boxtype=$(BOXTYPE) \
			--with-datadir=/usr/share/tuxbox \
			--with-configdir=/var/tuxbox/config \
			--with-plugindir=/var/tuxbox/plugins \
			$(NHD2_OPTS) \
			$(N_CONFIG_OPTS) \
			PKG_CONFIG=$(PKG_CONFIG) \
			PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
			CPPFLAGS="$(N_CPPFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)"
	@touch $@

$(D)/neutrinohd2.do_compile: $(D)/neutrinohd2.config.status
	cd $(SOURCE_DIR)/neutrinohd2; \
		$(MAKE) all
	@touch $@

neutrinohd2: $(D)/neutrinohd2.do_prepare $(D)/neutrinohd2.do_compile
	$(MAKE) -C $(SOURCE_DIR)/neutrinohd2 install DESTDIR=$(TARGET_DIR)
	make $(TARGET_DIR)/.version
	touch $(D)/$(notdir $@)
	$(TUXBOX_CUSTOMIZE)

neutrinohd2-plugins: $(D)/neutrinohd2.do_prepare $(D)/neutrinohd2.do_compile
	$(MAKE) -C $(SOURCE_DIR)/neutrinohd2 install DESTDIR=$(TARGET_DIR)
	make $(TARGET_DIR)/.version
	touch $(D)/$(notdir $@)
	make neutrinohd2-plugins.build
	$(TUXBOX_CUSTOMIZE)

neutrinohd2-clean: neutrino-cdkroot-clean
	rm -f $(D)/neutrinohd2
	rm -f $(D)/neutrinohd2.config.status
	cd $(SOURCE_DIR)/neutrinohd2; \
		$(MAKE) clean

neutrinohd2-distclean: neutrino-cdkroot-clean
	rm -f $(D)/neutrinohd2*
	rm -f $(D)/neutrinohd2-plugins*

################################################################################
neutrino-cdkroot-clean:
	[ -e $(TARGET_DIR)/usr/local/bin ] && cd $(TARGET_DIR)/usr/local/bin && find -name '*' -delete || true
	[ -e $(TARGET_DIR)/usr/local/share/iso-codes ] && cd $(TARGET_DIR)/usr/local/share/iso-codes && find -name '*' -delete || true
	[ -e $(TARGET_DIR)/usr/share/tuxbox/neutrino ] && cd $(TARGET_DIR)/usr/share/tuxbox/neutrino && find -name '*' -delete || true
	[ -e $(TARGET_DIR)/usr/share/fonts ] && cd $(TARGET_DIR)/usr/share/fonts && find -name '*' -delete || true
	[ -e $(TARGET_DIR)/var/tuxbox ] && cd $(TARGET_DIR)/var/tuxbox && find -name '*' -delete || true


#
#
#
PHONY += $(TARGET_DIR)/.version
PHONY += $(SOURCE_DIR)/$(NEUTRINO_MP)/src/gui/version.h

