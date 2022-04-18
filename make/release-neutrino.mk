#
# release-neutrino
#
release-neutrino: $(D)/neutrino $(D)/neutrino-plugins release-none
	cp -rf $(TARGET_DIR)/usr/local/bin $(RELEASE_DIR)/usr/local/
	cp -rf $(TARGET_DIR)/.version $(RELEASE_DIR)/
	cp -rf $(TARGET_DIR)/var/tuxbox/* $(RELEASE_DIR)/var/tuxbox
	cp -rf $(TARGET_DIR)/usr/share/tuxbox/* $(RELEASE_DIR)/usr/share/tuxbox
#
# linux-strip all
#
ifneq ($(OPTIMIZATIONS), $(filter $(OPTIMIZATIONS), kerneldebug debug normal))
	find $(RELEASE_DIR)/ -name '*' -exec $(TARGET)-strip --strip-unneeded {} &>/dev/null \;
endif
	@echo "*****************************************************************"
	@echo -e "\033[01;32m"
	@echo " Build of Neutrino Release for $(BOXTYPE) successfully completed."
	@echo -e "\033[00m"
	@echo "*****************************************************************"
