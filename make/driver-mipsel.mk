ifeq ($(BOXTYPE), vuduo)
DRIVER_VER = 3.9.6
DRIVER_DATE = 20151124
DRIVER_SRC = vuplus-dvb-modules-bm750-$(DRIVER_VER)-$(DRIVER_DATE).tar.gz

$(ARCHIVE)/$(DRIVER_SRC):
	$(WGET) http://archive.vuplus.com/download/drivers/$(DRIVER_SRC)
endif

ifeq ($(BOXTYPE), gb800se)
DRIVER_VER = 3.9.6
DRIVER_DATE = 20170803
DRIVER_SRC = gigablue-drivers-$(DRIVER_VER)-BCM7325-$(DRIVER_DATE).zip

$(ARCHIVE)/$(DRIVER_SRC):
	$(WGET) http://source.mynonpublic.com/gigablue/drivers/$(DRIVER_SRC)
endif

driver-clean:
	rm -f $(D)/driver $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra/$(KERNEL_TYPE)*

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

	$(TOUCH)
