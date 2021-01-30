depsclean:
	( cd $(D) && find . ! -name "*\.*" -delete )

clean:
	@echo -e "$(TERM_YELLOW)---> cleaning system build directories and files .. $(TERM_NORMAL)"
	@-$(MAKE) kernel-clean
	@-$(MAKE) driver-clean
	@-$(MAKE) tools-clean
	@-rm -rf $(RELEASE_DIR)
	@-rm -rf $(D)/*.do_*
	@-rm -rf $(D)/*.config.status
	@-rm -rf $(D)/*.build
	@-rm -rf $(D)/neutrino*
	@-rm -rf $(D)/release
	@-rm -rf $(D)/autofs
	@-rm -rf $(D)/busybox
	@-rm -rf $(D)/bzip2
	@-rm -rf $(D)/diverse-tools
	@-rm -rf $(D)/dvbsnoop
	@-rm -rf $(D)/e2fsprogs
	@-rm -rf $(D)/expat
	@-rm -rf $(D)/fbshot
	@-rm -rf $(D)/ffmpeg
	@-rm -rf $(D)/flac
	@-rm -rf $(D)/freetype
	@-rm -rf $(D)/giflib
	@-rm -rf $(D)/hdidle
	@-rm -rf $(D)/jfsutils
	@-rm -rf $(D)/jpeg
	@-rm -rf $(D)/libass
	@-rm -rf $(D)/libcurl
	@-rm -rf $(D)/libfribidi
	@-rm -rf $(D)/libid3tag
	@-rm -rf $(D)/libjpeg
	@-rm -rf $(D)/libmad
	@-rm -rf $(D)/libogg
	@-rm -rf $(D)/libpng
	@-rm -rf $(D)/libroxml
	@-rm -rf $(D)/libvorbisidec
	@-rm -rf $(D)/lirc
	@-rm -rf $(D)/lsb
	@-rm -rf $(D)/lua*
	@-rm -rf $(D)/ncurses
	@-rm -rf $(D)/nfs_utils
	@-rm -rf $(D)/openssl
	@-rm -rf $(D)/portmap
	@-rm -rf $(D)/system-tools
	@-rm -rf $(D)/sysvinit
	@-rm -rf $(D)/udpxy
	@-rm -rf $(D)/util_linux
	@-rm -rf $(D)/vsftpd
	@-rm -rf $(D)/wireless_tools
	@-rm -rf $(D)/wpa_supplicant
	@-rm -rf $(D)/zlib
	@-rm -rf $(D)/ca-bundle
	@-rm -rf $(D)/driver-symlink
	@-rm -rf $(TARGET_DIR)
	@-rm -rf $(D)/directories
	@echo -e "$(TERM_YELLOW)done\n$(TERM_NORMAL)"

distclean: depsclean
	@echo -e "$(TERM_YELLOW)---> cleaning whole build system .. $(TERM_NORMAL)"
	@-$(MAKE) kernel-clean
	@-$(MAKE) driver-clean
	@-$(MAKE) tools-distclean
	@-rm -rf $(TUFSBOX_DIR)
	@-rm -rf $(BUILD_TMP)
	@-rm -rf $(SOURCE_DIR)
	@-rm -rf $(CROSS_DIR)
	@echo -e "$(TERM_YELLOW)done\n$(TERM_NORMAL)"

%-clean:
	( cd $(D) && find . -name $(subst -clean,,$@) -delete )
