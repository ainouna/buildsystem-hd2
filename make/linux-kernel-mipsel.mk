# vuduo
ifeq ($(BOXTYPE), vuduo)
KERNEL_VER             = 3.9.6
KERNEL_TYPE            = vuduo
KERNEL_SRC_VER         = 3.9.6
KERNEL_SRC             = stblinux-${KERNEL_SRC_VER}.tar.bz2
KERNEL_URL             = http://archive.vuplus.com/download/kernel
KERNEL_CONFIG          = vuduo_defconfig
KERNEL_DIR             = $(BUILD_TMP)/linux
KERNEL_PATCHES_MIPSEL  = $(VUDUO_PATCHES)
endif

# gb800se
ifeq ($(BOXTYPE), gb800se)
KERNEL_VER             = 3.9.6
KERNEL_DATE            = 20140904
KERNEL_TYPE            = gb800se
KERNEL_SRC             = gigablue-linux-$(KERNEL_VER)-$(KERNEL_DATE).tgz
KERNEL_URL             = http://archiv.openmips.com
KERNEL_CONFIG          = gb800se_defconfig
KERNEL_DIR             = $(BUILD_TMP)/linux-$(KERNEL_VER)
KERNEL_PATCHES_MIPSEL  = $(GB800SE_PATCHES)
endif

DEPMOD = $(HOST_DIR)/bin/depmod

# kernel patches
# gb800se
GB800SE_PATCHES = \
		mipsel/gb800se/nor-maps-gb800solo.patch \
    		mipsel/gb800se/add-dmx-source-timecode.patch \
    		mipsel/gb800se/af9015-output-full-range-SNR.patch \
    		mipsel/gb800se/af9033-output-full-range-SNR.patch \
    		mipsel/gb800se/as102-adjust-signal-strength-report.patch \
    		mipsel/gb800se/as102-scale-MER-to-full-range.patch \
    		mipsel/gb800se/cinergy_s2_usb_r2.patch \
    		mipsel/gb800se/cxd2820r-output-full-range-SNR.patch \
    		mipsel/gb800se/dvb-usb-dib0700-disable-sleep.patch \
    		mipsel/gb800se/dvb_usb_disable_rc_polling.patch \
    		mipsel/gb800se/it913x-switch-off-PID-filter-by-default.patch \
    		mipsel/gb800se/tda18271-advertise-supported-delsys.patch \
    		mipsel/gb800se/fix-dvb-siano-sms-order.patch \
    		mipsel/gb800se/mxl5007t-add-no_probe-and-no_reset-parameters.patch \
#    		mipsel/gb800se/nfs-max-rwsize-8k.patch \
    		mipsel/gb800se/0001-rt2800usb-add-support-for-rt55xx.patch \
    		mipsel/gb800se/linux-sata_bcm.patch \
    		mipsel/gb800se/brcmnand.patch \
    		mipsel/gb800se/fix_fuse_for_linux_mips_3-9.patch \
    		mipsel/gb800se/rt2800usb_fix_warn_tx_status_timeout_to_dbg.patch \
    		mipsel/gb800se/linux-3.9-gcc-4.9.3-build-error-fixed.patch \
    		mipsel/gb800se/kernel-add-support-for-gcc-5.patch \
    		mipsel/gb800se/rtl8712-fix-warnings.patch \
    		mipsel/gb800se/rtl8187se-fix-warnings.patch \
    		mipsel/gb800se/0001-Support-TBS-USB-drivers-3.9.patch \
    		mipsel/gb800se/0001-STV-Add-PLS-support.patch \
    		mipsel/gb800se/0001-STV-Add-SNR-Signal-report-parameters.patch \
    		mipsel/gb800se/0001-stv090x-optimized-TS-sync-control.patch \
    		mipsel/gb800se/blindscan2.patch

# vuduo
VUDUO_PATCHES = \
		mipsel/vuduo/add-dmx-source-timecode.patch \
		mipsel/vuduo/af9015-output-full-range-SNR.patch \
		mipsel/vuduo/af9033-output-full-range-SNR.patch \
		mipsel/vuduo/as102-adjust-signal-strength-report.patch \
		mipsel/vuduo/as102-scale-MER-to-full-range.patch \
		mipsel/vuduo/cinergy_s2_usb_r2.patch \
		mipsel/vuduo/cxd2820r-output-full-range-SNR.patch \
		mipsel/vuduo/dvb-usb-dib0700-disable-sleep.patch \
		mipsel/vuduo/dvb_usb_disable_rc_polling.patch \
		mipsel/vuduo/it913x-switch-off-PID-filter-by-default.patch \
		mipsel/vuduo/tda18271-advertise-supported-delsys.patch \
		mipsel/vuduo/fix-dvb-siano-sms-order.patch \
		mipsel/vuduo/mxl5007t-add-no_probe-and-no_reset-parameters.patch \
		mipsel/vuduo/nfs-max-rwsize-8k.patch \
		mipsel/vuduo/0001-rt2800usb-add-support-for-rt55xx.patch \
		mipsel/vuduo/linux-sata_bcm.patch \
		mipsel/vuduo/fix_fuse_for_linux_mips_3-9.patch \
		mipsel/vuduo/rt2800usb_fix_warn_tx_status_timeout_to_dbg.patch \
		mipsel/vuduo/linux-3.9-gcc-4.9.3-build-error-fixed.patch \
		mipsel/vuduo/kernel-add-support-for-gcc5.patch \
		mipsel/vuduo/kernel-add-support-for-gcc6.patch \
		mipsel/vuduo/kernel-add-support-for-gcc7.patch \
		mipsel/vuduo/kernel-add-support-for-gcc8.patch \
		mipsel/vuduo/kernel-add-support-for-gcc9.patch \
		mipsel/vuduo/gcc9_backport.patch \
		mipsel/vuduo/rtl8712-fix-warnings.patch \
		mipsel/vuduo/rtl8187se-fix-warnings.patch \
		mipsel/vuduo/0001-Support-TBS-USB-drivers-3.9.patch \
		mipsel/vuduo/0001-STV-Add-PLS-support.patch \
		mipsel/vuduo/0001-STV-Add-SNR-Signal-report-parameters.patch \
		mipsel/vuduo/0001-stv090x-optimized-TS-sync-control.patch \
		mipsel/vuduo/blindscan2.patch \
		mipsel/vuduo/genksyms_fix_typeof_handling.patch \
		mipsel/vuduo/0002-log2-give-up-on-gcc-constant-optimizations.patch \
		mipsel/vuduo/0003-cp1emu-do-not-use-bools-for-arithmetic.patch \
		mipsel/vuduo/test.patch \
		mipsel/vuduo/01-10-si2157-Silicon-Labs-Si2157-silicon-tuner-driver.patch \
		mipsel/vuduo/02-10-si2168-Silicon-Labs-Si2168-DVB-T-T2-C-demod-driver.patch \
		mipsel/vuduo/CONFIG_DVB_SP2.patch \
		mipsel/vuduo/dvbsky-t330.patch
#		mipsel/vuduo/fixed_mtd.patch

KERNEL_PATCHES = $(KERNEL_PATCHES_MIPSEL)

$(ARCHIVE)/$(KERNEL_SRC):
ifeq ($(BOXTYPE), vuduo)
	$(WGET) $(KERNEL_URL)/$(KERNEL_SRC)
endif

$(D)/kernel.do_prepare: $(ARCHIVE)/$(KERNEL_SRC) $(PATCHES)/mipsel/$(KERNEL_CONFIG)
	$(START_BUILD)
ifeq ($(BOXTYPE), vuduo)
	rm -rf $(KERNEL_DIR)
	$(UNTAR)/$(KERNEL_SRC)
endif
ifeq ($(BOXTYPE), gb800se)
	$(UNTARGZ)/$(KERNEL_SRC)
endif
	set -e; cd $(KERNEL_DIR); \
		for i in $(KERNEL_PATCHES); do \
			echo -e "==> $(TERM_RED)Applying Patch:$(TERM_NORMAL) $$i"; \
			$(PATCH)/$$i; \
		done
	install -m 644 $(PATCHES)/mipsel/$(KERNEL_CONFIG) $(KERNEL_DIR)/.config
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
		$(MAKE) -C $(KERNEL_DIR) ARCH=mips CROSS_COMPILE=$(TARGET)- vmlinux modules
		$(MAKE) -C $(KERNEL_DIR) ARCH=mips CROSS_COMPILE=$(TARGET)- DEPMOD=$(DEPMOD) INSTALL_MOD_PATH=$(TARGET_DIR) modules_install
	@touch $@

KERNEL = $(D)/kernel
$(D)/kernel: $(D)/bootstrap $(D)/kernel.do_compile
	gzip -9c < "$(KERNEL_DIR)/vmlinux" > "$(KERNEL_DIR)/kernel_cfe_auto.bin"
	install -m 644 $(KERNEL_DIR)/kernel_cfe_auto.bin $(TARGET_DIR)/boot/
	ln -s $(TARGET_DIR)/boot/kernel_cfe_auto.bin $(TARGET_DIR)/boot/vmlinux
	rm $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/build || true
	rm $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/source || true
	$(TOUCH)

kernel-distclean:
	rm -f $(D)/kernel
	rm -f $(D)/kernel.do_compile
	rm -f $(D)/kernel.do_prepare

kernel-clean:
	-$(MAKE) -C $(KERNEL_DIR) clean
	rm -f $(D)/kernel
	rm -f $(D)/kernel.do_compile

#
# Helper
#
kernel.menuconfig kernel.xconfig: \
kernel.%: $(D)/kernel
	$(MAKE) -C $(KERNEL_DIR) ARCH=mips CROSS_COMPILE=$(TARGET)- $*
	@echo ""
	@echo "You have to edit $(PATCHES)/armbox/$(KERNEL_CONFIG) m a n u a l l y to make changes permanent !!!"
	@echo ""
	diff $(KERNEL_DIR)/.config.old $(KERNEL_DIR)/.config
	@echo ""


