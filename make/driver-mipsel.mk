# vudo
ifeq ($(BOXTYPE), vuduo)
DRIVER_VER = 3.9.6
DRIVER_DATE = 20151124
DRIVER_SRC = vuplus-dvb-modules-bm750-$(DRIVER_VER)-$(DRIVER_DATE).tar.gz

$(ARCHIVE)/$(DRIVER_SRC):
	$(WGET) http://archive.vuplus.com/download/drivers/$(DRIVER_SRC)
endif

# gb800se
ifeq ($(BOXTYPE), gb800se)
DRIVER_VER = 3.9.6
DRIVER_DATE = 20170803
DRIVER_SRC = gigablue-drivers-$(DRIVER_VER)-BCM7325-$(DRIVER_DATE).zip

$(ARCHIVE)/$(DRIVER_SRC):
	$(WGET) http://source.mynonpublic.com/gigablue/drivers/$(DRIVER_SRC)
endif

# osnino
ifeq ($(BOXTYPE), osnino)
DRIVER_VER = 4.8.17
DRIVER_DATE = 20201104
DRIVER_SRC = osnino-drivers-$(DRIVER_VER)-$(DRIVER_DATE).zip

$(ARCHIVE)/$(DRIVER_SRC):
	$(WGET) http://source.mynonpublic.com/edision/$(DRIVER_SRC)
endif

driver-clean:
	rm -f $(D)/driver $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra/$(BOXTYPE)*

driver: $(D)/driver
$(D)/driver: $(ARCHIVE)/$(DRIVER_SRC) $(D)/bootstrap $(D)/kernel
	$(START_BUILD)
	install -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
ifeq ($(BOXTYPE), vuduo)
	tar -xf $(ARCHIVE)/$(DRIVER_SRC) -C $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
endif
ifeq ($(BOXTYPE), gb800se)
	unzip -o $(ARCHIVE)/$(DRIVER_SRC) -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
endif
ifeq ($(BOXTYPE), osnino)
	unzip -o $(ARCHIVE)/$(DRIVER_SRC) -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
endif

	$(TOUCH)
