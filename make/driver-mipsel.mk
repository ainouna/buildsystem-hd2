# vudo
#ifeq ($(BOXTYPE), vuduo)
#DRIVER_VER = 3.9.6
#DRIVER_DATE = 20151124
#DRIVER_SRC = vuplus-dvb-modules-bm750-$(DRIVER_VER)-$(DRIVER_DATE).tar.gz

#$(ARCHIVE)/$(DRIVER_SRC):
#	$(WGET) http://archive.vuplus.com/download/drivers/$(DRIVER_SRC)
#endif

# gb800se
#ifeq ($(BOXTYPE), gb800se)
#DRIVER_VER = 3.9.6
#DRIVER_DATE = 20170803
#DRIVER_SRC = gigablue-drivers-$(DRIVER_VER)-BCM7325-$(DRIVER_DATE).zip

#$(ARCHIVE)/$(DRIVER_SRC):
#	$(WGET) http://source.mynonpublic.com/gigablue/drivers/$(DRIVER_SRC)
#endif

# osnino | osninoplus | osninopro
#ifeq ($(BOXTYPE), $(filter $(BOXTYPE), osnino osninoplus osninopro))
#DRIVER_VER = 4.8.17
#DRIVER_DATE = 20201104
#DRIVER_SRC = $(BOXTYPE)-drivers-$(DRIVER_VER)-$(DRIVER_DATE).zip

#$(ARCHIVE)/$(DRIVER_SRC):
#	$(WGET) http://source.mynonpublic.com/edision/$(DRIVER_SRC)
#endif

# vuduo2
#ifeq ($(BOXTYPE), vuduo2)
#DRIVER_VER = 3.13.5
#DRIVER_DATE = 20190429
#DRIVER_REV = r0
#DRIVER_SRC = vuplus-dvb-proxy-vuduo2-$(DRIVER_VER)-$(DRIVER_DATE).$(DRIVER_REV).tar.gz

#$(ARCHIVE)/$(DRIVER_SRC):
#	$(WGET) http://archive.vuplus.com/download/build_support/vuplus/$(DRIVER_SRC)
#endif

driver-clean:
	rm -f $(D)/driver $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra/*

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
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), osnino osninoplus osninopro))
	unzip -o $(ARCHIVE)/$(DRIVER_SRC) -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
endif
ifeq ($(BOXTYPE), vuduo2)
	tar -xf $(ARCHIVE)/$(DRIVER_SRC) -C $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	$(MAKE) platform_util
	$(MAKE) vmlinuz_initrd
endif
	$(TOUCH)

#
# vuduo2
#
#ifeq ($(BOXTYPE), vuduo2)
#
# platform util
#
#UTIL_VER = 15.1
#UTIL_DATE = $(DRIVER_DATE)
#UTIL_REV = r0
#UTIL_SRC = platform-util-vuduo2-$(UTIL_VER)-$(UTIL_DATE).$(UTIL_REV).tar.gz

#$(ARCHIVE)/$(UTIL_SRC):
#	$(WGET) http://archive.vuplus.com/download/build_support/vuplus/$(UTIL_SRC)

#$(D)/platform_util: $(D)/bootstrap $(ARCHIVE)/$(UTIL_SRC)
#	$(START_BUILD)
#	$(UNTAR)/$(UTIL_SRC)
#	install -m 0755 $(BUILD_TMP)/platform-util-vuduo2/* $(TARGET_DIR)/usr/bin
#	$(REMOVE)/platform-util-$(KERNEL_TYPE)
#	$(TOUCH)

#
# vmlinuz initrd
#
#INITRD_DATE = 20130220
#INITRD_SRC = vmlinuz-initrd_vuduo2_$(INITRD_DATE).tar.gz

#$(ARCHIVE)/$(INITRD_SRC):
#	$(WGET) http://archive.vuplus.com/download/kernel/$(INITRD_SRC)

#$(D)/vmlinuz_initrd: $(D)/bootstrap $(ARCHIVE)/$(INITRD_SRC)
#	$(START_BUILD)
#	install -d $(TARGET_DIR)/boot
#	tar -xf $(ARCHIVE)/$(INITRD_SRC) -C $(TARGET_DIR)/boot
#	mv $(TARGET_DIR)/boot/vmlinuz-initrd-7425b0 $(TARGET_DIR)/boot/initrd_cfe_auto.bin
#	$(TOUCH)
#endif


