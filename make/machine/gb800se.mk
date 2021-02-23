BOXARCH = mips
MEDIAFW ?= gstreamer
INTERFACE ?= lua
CICAM = ci-cam
SCART = scart
LCD = 4-digits
FKEYS = fkeys

#
# kernel
#
KERNEL_VER             = 3.9.6
KERNEL_DATE            = 20140904
KERNEL_SRC             = gigablue-linux-$(KERNEL_VER)-$(KERNEL_DATE).tgz
KERNEL_URL             = http://source.mynonpublic.com/gigablue/linux
KERNEL_CONFIG          = gb800se_defconfig
KERNEL_DIR             = $(BUILD_TMP)/linux-$(KERNEL_VER)
KERNELNAME             = vmlinux
CUSTOM_KERNEL_VER      = $(KERNEL_VER)

KERNEL_PATCHES_MIPSEL  = \
		mips/gb800se/nor-maps-gb800solo.patch \
       		mips/gb800se/add-dmx-source-timecode.patch \
    		mips/gb800se/af9015-output-full-range-SNR.patch \
    		mips/gb800se/af9033-output-full-range-SNR.patch \
    		mips/gb800se/as102-adjust-signal-strength-report.patch \
    		mips/gb800se/as102-scale-MER-to-full-range.patch \
    		mips/gb800se/cinergy_s2_usb_r2.patch \
    		mips/gb800se/cxd2820r-output-full-range-SNR.patch \
    		mips/gb800se/dvb-usb-dib0700-disable-sleep.patch \
    		mips/gb800se/dvb_usb_disable_rc_polling.patch \
    		mips/gb800se/it913x-switch-off-PID-filter-by-default.patch \
    		mips/gb800se/tda18271-advertise-supported-delsys.patch \
    		mips/gb800se/fix-dvb-siano-sms-order.patch \
    		mips/gb800se/mxl5007t-add-no_probe-and-no_reset-parameters.patch \
    		mips/gb800se/nfs-max-rwsize-8k.patch \
    		mips/gb800se/0001-rt2800usb-add-support-for-rt55xx.patch \
    		mips/gb800se/linux-sata_bcm.patch \
    		mips/gb800se/brcmnand.patch \
    		mips/gb800se/fix_fuse_for_linux_mips_3-9.patch \
    		mips/gb800se/rt2800usb_fix_warn_tx_status_timeout_to_dbg.patch \
		mips/gb800se/linux-3.9-gcc-4.9.3-build-error-fixed.patch \
    		mips/gb800se/rtl8712-fix-warnings.patch \
    		mips/gb800se/rtl8187se-fix-warnings.patch \
    		mips/gb800se/kernel-add-support-for-gcc-5.patch \
    		mips/gb800se/kernel-add-support-for-gcc6.patch \
    		mips/gb800se/kernel-add-support-for-gcc7.patch \
    		mips/gb800se/kernel-add-support-for-gcc8.patch \
    		mips/gb800se/kernel-add-support-for-gcc9.patch \
		mips/gb800se/0001-Support-TBS-USB-drivers-3.9.patch \
    		mips/gb800se/0001-STV-Add-PLS-support.patch \
    		mips/gb800se/0001-STV-Add-SNR-Signal-report-parameters.patch \
    		mips/gb800se/0001-stv090x-optimized-TS-sync-control.patch \
    		mips/gb800se/blindscan2.patch \
    		mips/gb800se/genksyms_fix_typeof_handling.patch \
    		mips/gb800se/0002-cp1emu-do-not-use-bools-for-arithmetic.patch \
    		mips/gb800se/0003-log2-give-up-on-gcc-constant-optimizations.patch

KERNEL_PATCHES = $(KERNEL_PATCHES_MIPSEL)

$(ARCHIVE)/$(KERNEL_SRC):
	$(WGET) $(KERNEL_URL)/$(KERNEL_SRC)

$(D)/kernel.do_prepare: $(ARCHIVE)/$(KERNEL_SRC) $(PATCHES)/$(BOXARCH)/$(KERNEL_CONFIG)
	$(START_BUILD)
	rm -rf $(KERNEL_DIR)
	$(UNTARGZ)/$(KERNEL_SRC)
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
		$(MAKE) -C $(KERNEL_DIR) ARCH=mips oldconfig
		$(MAKE) -C $(KERNEL_DIR) ARCH=mips CROSS_COMPILE=$(TARGET)- $(KERNELNAME) modules
		$(MAKE) -C $(KERNEL_DIR) ARCH=mips CROSS_COMPILE=$(TARGET)- DEPMOD=$(DEPMOD) INSTALL_MOD_PATH=$(TARGET_DIR) modules_install
	@touch $@

KERNEL = $(D)/kernel
$(D)/kernel: $(D)/bootstrap $(D)/kernel.do_compile
	install -m 644 $(KERNEL_DIR)/$(KERNELNAME) $(TARGET_DIR)/boot/
	install -m 644 $(KERNEL_DIR)/System.map $(TARGET_DIR)/boot/System.map-$(BOXARCH)-$(KERNEL_VER)
	rm $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/build || true
	rm $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/source || true
	$(TOUCH)

#
# driver
#
DRIVER_VER = 3.9.6
DRIVER_DATE = 20170803
DRIVER_SRC = gigablue-drivers-$(DRIVER_VER)-BCM7325-$(DRIVER_DATE).zip

$(ARCHIVE)/$(DRIVER_SRC):
	$(WGET) http://source.mynonpublic.com/gigablue/drivers/$(DRIVER_SRC)

driver: $(D)/driver
$(D)/driver: $(ARCHIVE)/$(DRIVER_SRC) $(D)/bootstrap $(D)/kernel
	$(START_BUILD)
	install -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	unzip -o $(ARCHIVE)/$(DRIVER_SRC) -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	$(TOUCH)

#
# release
#
release-gb800se:
	install -m 0755 $(SKEL_ROOT)/etc/init.d/halt_gb800se $(RELEASE_DIR)/etc/init.d/halt
	cp -f $(SKEL_ROOT)/etc/fstab_gb800se $(RELEASE_DIR)/etc/fstab
	cp $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra/*.ko $(RELEASE_DIR)/lib/modules/

#
# flashimage
#
GB800SE_PREFIX = gigablue/se

flash-image-gb800se:
	# Create final USB-image
	mkdir -p $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)
	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
	# splash
	cp $(SKEL_ROOT)/boot/splash.bin $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)
	echo "rename this file to 'force' to force an update without confirmation" > $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/noforce;
	# kernel
	gzip -c < "$(TARGET_DIR)/boot/vmlinux" > "$(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/kernel.bin"
	# rootfs
	mkfs.ubifs -r $(RELEASE_DIR) -o $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/rootfs.ubi -m 2048 -e 126976 -c 4096
	echo '[ubifs]' > $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/ubinize.cfg
	echo 'mode=ubi' >> $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/ubinize.cfg
	echo 'image=$(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/rootfs.ubi' >> $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/ubinize.cfg
	echo 'vol_id=0' >> $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/ubinize.cfg
	echo 'vol_type=dynamic' >> $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/ubinize.cfg
	echo 'vol_name=rootfs' >> $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/ubinize.cfg
	echo 'vol_flags=autoresize' >> $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/ubinize.cfg
	ubinize -o $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/rootfs.bin -m 2048 -p 128KiB $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/ubinize.cfg
	rm -f $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/rootfs.ubi
	rm -f $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/ubinize.cfg
	echo $(BOXTYPE)_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/imageversion
	cd $(IMAGE_BUILD_DIR)/ && \
	zip -r $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(GB800SE_PREFIX)*
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)


