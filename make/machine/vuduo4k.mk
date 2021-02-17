BOXARCH = arm
OPTIMIZATIONS ?= size
WLAN ?= 
MEDIAFW ?= gstreamer
INTERFACE ?=lua-python
CICAM = ci-cam
SCART = scart
LCD = 4-digits
FKEYS =

#
# kernel
#
KERNEL_VER             = 4.1.45-1.17
KERNEL_SRC_VER         = 4.1-1.17
KERNEL_SRC             = stblinux-${KERNEL_SRC_VER}.tar.bz2
KERNEL_URL             = http://archive.vuplus.com/download/kernel
KERNEL_CONFIG          = $(BOXTYPE)_defconfig
KERNEL_DIR             = $(BUILD_TMP)/linux
KERNELNAME             = zImage
CUSTOM_KERNEL_VER      = $(KERNEL_SRC_VER)

KERNEL_PATCHES_ARM = \
		arm/vuduo4k/4_1_linux_dvb_adapter.patch \
		arm/vuduo4k/4_1_linux_dvb-core.patch \
		arm/vuduo4k/4_1_linux_4_1_45_dvbs2x.patch \
		arm/vuduo4k/4_1_dmx_source_dvr.patch \
		arm/vuduo4k/4_1_bcmsysport_4_1_45.patch \
		arm/vuduo4k/4_1_linux_usb_hub.patch \
		arm/vuduo4k/4_1_0001-regmap-add-regmap_write_bits.patch \
		arm/vuduo4k/4_1_0002-af9035-fix-device-order-in-ID-list.patch \
		arm/vuduo4k/4_1_0003-Add-support-for-dvb-usb-stick-Hauppauge-WinTV-soloHD.patch \
		arm/vuduo4k/4_1_0004-af9035-add-USB-ID-07ca-0337-AVerMedia-HD-Volar-A867.patch \
		arm/vuduo4k/4_1_0005-Add-support-for-EVOLVEO-XtraTV-stick.patch \
		arm/vuduo4k/4_1_0006-dib8000-Add-support-for-Mygica-Geniatech-S2870.patch \
		arm/vuduo4k/4_1_0007-dib0700-add-USB-ID-for-another-STK8096-PVR-ref-desig.patch \
		arm/vuduo4k/4_1_0008-add-Hama-Hybrid-DVB-T-Stick-support.patch \
		arm/vuduo4k/4_1_0009-Add-Terratec-H7-Revision-4-to-DVBSky-driver.patch \
		arm/vuduo4k/4_1_0010-media-Added-support-for-the-TerraTec-T1-DVB-T-USB-tu.patch \
		arm/vuduo4k/4_1_0011-media-tda18250-support-for-new-silicon-tuner.patch \
		arm/vuduo4k/4_1_0012-media-dib0700-add-support-for-Xbox-One-Digital-TV-Tu.patch \
		arm/vuduo4k/4_1_0013-mn88472-Fix-possible-leak-in-mn88472_init.patch \
		arm/vuduo4k/4_1_0014-staging-media-Remove-unneeded-parentheses.patch \
		arm/vuduo4k/4_1_0015-staging-media-mn88472-simplify-NULL-tests.patch \
		arm/vuduo4k/4_1_0016-mn88472-fix-typo.patch \
		arm/vuduo4k/4_1_0017-mn88472-finalize-driver.patch \
		arm/vuduo4k/4_1_0001-dvb-usb-fix-a867.patch \
		arm/vuduo4k/4_1_kernel-add-support-for-gcc6.patch \
		arm/vuduo4k/4_1_kernel-add-support-for-gcc7.patch \
		arm/vuduo4k/4_1_kernel-add-support-for-gcc8.patch \
		arm/vuduo4k/4_1_kernel-add-support-for-gcc9.patch \
		arm/vuduo4k/4_1_kernel-add-support-for-gcc10.patch \
		arm/vuduo4k/4_1_0001-Support-TBS-USB-drivers-for-4.1-kernel.patch \
		arm/vuduo4k/4_1_0001-TBS-fixes-for-4.1-kernel.patch \
		arm/vuduo4k/4_1_0001-STV-Add-PLS-support.patch \
		arm/vuduo4k/4_1_0001-STV-Add-SNR-Signal-report-parameters.patch \
		arm/vuduo4k/4_1_blindscan2.patch \
		arm/vuduo4k/4_1_0001-stv090x-optimized-TS-sync-control.patch \
		arm/vuduo4k/4_1_0002-log2-give-up-on-gcc-constant-optimizations.patch \
		arm/vuduo4k/4_1_0003-uaccess-dont-mark-register-as-const.patch

KERNEL_PATCHES = $(KERNEL_PATCHES_ARM)

$(ARCHIVE)/$(KERNEL_SRC):
	$(WGET) $(KERNEL_URL)/$(KERNEL_SRC)

$(D)/kernel.do_prepare: $(ARCHIVE)/$(KERNEL_SRC) $(PATCHES)/$(BOXARCH)/$(KERNEL_CONFIG)
	$(START_BUILD)
	rm -rf $(KERNEL_DIR)
	$(UNTAR)/$(KERNEL_SRC)
	set -e; cd $(KERNEL_DIR); \
		for i in $(KERNEL_PATCHES); do \
			echo -e "==> $(TERM_RED)Applying Patch:$(TERM_NORMAL) $$i"; \
			$(PATCH)/$$i; \
		done
	install -m 644 $(PATCHES)/$(BOXARCH)/$(KERNEL_CONFIG) $(KERNEL_DIR)/.config
ifeq ($(OPTIMIZATIONS), $(filter $(OPTIMIZATIONS), kerneldebug debug))
	@echo "Using kernel debug"
	@grep -v "CONFIG_PRINTK" "$(KERNEL_DIR)/.config" > $(KERNEL_DIR)/.config.tmp
	cp $(KERNEL_DIR)/.config.tmp $(KERNEL_DIR)/.config
	@echo "CONFIG_PRINTK=y" >> $(KERNEL_DIR)/.config
	@echo "CONFIG_PRINTK_TIME=y" >> $(KERNEL_DIR)/.config
endif
	@touch $@

$(D)/kernel.do_compile: $(D)/kernel.do_prepare
	set -e; cd $(KERNEL_DIR); \
		$(MAKE) -C $(KERNEL_DIR) ARCH=arm oldconfig
		$(MAKE) -C $(KERNEL_DIR) ARCH=arm CROSS_COMPILE=$(TARGET)- zImage modules
		$(MAKE) -C $(KERNEL_DIR) ARCH=arm CROSS_COMPILE=$(TARGET)- DEPMOD=$(DEPMOD) INSTALL_MOD_PATH=$(TARGET_DIR) modules_install
	@touch $@

KERNEL = $(D)/kernel
$(D)/kernel: $(D)/bootstrap $(D)/kernel.do_compile
	install -m 644 $(KERNEL_DIR)/arch/arm/boot/zImage $(TARGET_DIR)/boot/vmlinux
	install -m 644 $(KERNEL_DIR)/vmlinux $(TARGET_DIR)/boot/vmlinux-arm-$(KERNEL_VER)
	install -m 644 $(KERNEL_DIR)/System.map $(TARGET_DIR)/boot/System.map-arm-$(KERNEL_VER)
	cp $(KERNEL_DIR)/arch/arm/boot/zImage $(TARGET_DIR)/boot/
	rm $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/build || true
	rm $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/source || true
	$(TOUCH)

#
# driver
#
DRIVER_VER = 4.1.45
DRIVER_DATE = 20191218
#DRIVER_DATE = 20190212
DRIVER_REV = r0
DRIVER_SRC = vuplus-dvb-proxy-vuduo4k-$(DRIVER_VER)-$(DRIVER_DATE).$(DRIVER_REV).tar.gz

$(ARCHIVE)/$(DRIVER_SRC):
	$(WGET) http://archive.vuplus.com/download/build_support/vuplus/$(DRIVER_SRC)

driver: $(D)/driver
$(D)/driver: $(ARCHIVE)/$(DRIVER_SRC) $(D)/bootstrap $(D)/kernel
	$(START_BUILD)
	install -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	tar -xf $(ARCHIVE)/$(DRIVER_SRC) -C $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	$(MAKE) platform_util
	$(MAKE) libgles
	$(MAKE) vmlinuz_initrd
	$(TOUCH)

#
# platform util
#
UTIL_VER = 18.1
UTIL_DATE = $(DRIVER_DATE)
UTIL_REV = r0
UTIL_SRC = platform-util-vuduo4k-$(UTIL_VER)-$(UTIL_DATE).$(UTIL_REV).tar.gz

$(ARCHIVE)/$(UTIL_SRC):
	$(WGET) http://archive.vuplus.com/download/build_support/vuplus/$(UTIL_SRC)

$(D)/platform_util: $(D)/bootstrap $(ARCHIVE)/$(UTIL_SRC)
	$(START_BUILD)
	$(UNTAR)/$(UTIL_SRC)
	install -m 0755 $(BUILD_TMP)/platform-util-vuduo4k/* $(TARGET_DIR)/usr/bin
	$(REMOVE)/platform-util-vuduo4k
	$(TOUCH)

#
# libgles
#
GLES_VER = 18.1
GLES_DATE = $(DRIVER_DATE)
GLES_REV = r0
GLES_SRC = libgles-vuduo4k-$(GLES_VER)-$(GLES_DATE).$(GLES_REV).tar.gz

$(ARCHIVE)/$(GLES_SRC):
	$(WGET) http://archive.vuplus.com/download/build_support/vuplus/$(GLES_SRC)

$(D)/libgles: $(D)/bootstrap $(ARCHIVE)/$(GLES_SRC)
	$(START_BUILD)
	$(UNTAR)/$(GLES_SRC)
	install -m 0755 $(BUILD_TMP)/libgles-vuduo4k/lib/* $(TARGET_LIB_DIR)
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libGLESv2.so
	cp -a $(BUILD_TMP)/libgles-vuduo4k/include/* $(TARGET_INCLUDE_DIR)
	$(REMOVE)/libgles-vuduo4k
	$(TOUCH)

#
# vmlinuz initrd
#
INITRD_DATE = 20181030
INITRD_SRC = vmlinuz-initrd_vuduo4k_$(INITRD_DATE).tar.gz

$(ARCHIVE)/$(INITRD_SRC):
	$(WGET) http://archive.vuplus.com/download/kernel/$(INITRD_SRC)

$(D)/vmlinuz_initrd: $(D)/bootstrap $(ARCHIVE)/$(INITRD_SRC)
	$(START_BUILD)
	tar -xf $(ARCHIVE)/$(INITRD_SRC) -C $(TARGET_DIR)/boot
	install -d $(TARGET_DIR)/boot
	$(TOUCH)

#
# release
#
release-vuduo4k:
	install -m 0755 $(SKEL_ROOT)/etc/init.d/halt_vuduo4k $(RELEASE_DIR)/etc/init.d/halt
	cp -f $(SKEL_ROOT)/usr/bin/bp3flash.sh $(RELEASE_DIR)/usr/bin
	cp -f $(SKEL_ROOT)/usr/bin/nvram $(RELEASE_DIR)/usr/bin
	cp -f $(SKEL_ROOT)/etc/fstab_vuduo4k $(RELEASE_DIR)/etc/fstab
	cp $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra/*.ko $(RELEASE_DIR)/lib/modules/
	rm -f $(RELEASE_DIR)/lib/modules/fpga_directc.ko
	cp $(TARGET_DIR)/boot/vmlinuz-initrd-7278b1 $(RELEASE_DIR)/boot/

#
# flashimage
#
VU_PREFIX = vuplus/duo4k

flash-image-vuduo4k-multi-rootfs:
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(VU_PREFIX)
	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
	cp $(TARGET_DIR)/boot/vmlinuz-initrd-7278b1 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/initrd_auto.bin
	cp $(TARGET_DIR)/boot/zImage $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel1_auto.bin
	cp $(TARGET_DIR)/boot/zImage $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel2_auto.bin
	cp $(TARGET_DIR)/boot/zImage $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel3_auto.bin
	cp $(TARGET_DIR)/boot/zImage $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel4_auto.bin
	cd $(RELEASE_DIR); \
	tar -cvf $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar --exclude=zImage* --exclude=vmlinuz-initrd* . > /dev/null 2>&1; \
	bzip2 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar
	mv $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar.bz2 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs1.tar.bz2
	cp $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs1.tar.bz2 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs2.tar.bz2
	cp $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs1.tar.bz2 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs3.tar.bz2
	cp $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs1.tar.bz2 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs4.tar.bz2
	echo This file forces a reboot after the update. > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/reboot.update
	echo This file forces creating partitions. > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/mkpart.update
	echo Dummy for update. > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel_auto.bin
	echo Dummy for update. > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar.bz2
	echo $(BOXTYPE)_DDT_multi_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/imageversion
	cd $(IMAGE_BUILD_DIR) && \
	zip -r $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_multi_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(VU_PREFIX)/rootfs*.tar.bz2 $(VU_PREFIX)/initrd_auto.bin $(VU_PREFIX)/kernel*_auto.bin $(VU_PREFIX)/*.update $(VU_PREFIX)/imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-vuduo4k-online:
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(VU_PREFIX)
	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
	cp $(TARGET_DIR)/boot/vmlinuz-initrd-7278b1 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/initrd_auto.bin
	cp $(TARGET_DIR)/boot/zImage $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel_auto.bin
	cd $(RELEASE_DIR); \
	tar -cvf $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar --exclude=zImage* --exclude=vmlinuz-initrd* . > /dev/null 2>&1; \
	bzip2 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar
	echo This file forces a reboot after the update. > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/reboot.update
	echo This file forces creating partitions. > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/mkpart.update
	echo $(BOXTYPE)_DDT_online_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/imageversion
	cd $(IMAGE_BUILD_DIR)/$(VU_PREFIX) && \
	tar -cvzf $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_online_$(shell date '+%d.%m.%Y-%H.%M').tgz rootfs.tar.bz2 initrd_auto.bin kernel_auto.bin *.update imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)




