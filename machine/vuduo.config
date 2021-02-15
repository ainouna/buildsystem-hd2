BOXARCH = mips
OPTIMIZATIONS ?= size
WLAN ?= 
MEDIAFW ?= gstreamer
INTERFACE ?=lua-python
CICAM = ci-cam
SCART = scart
LCD = vfd
FKEYS =

#
# kernel
#
KERNEL_VER             = 3.9.6
KERNEL_SRC             = stblinux-${KERNEL_VER}.tar.bz2
KERNEL_URL             = http://archive.vuplus.com/download/kernel
KERNEL_CONFIG          = vuduo_defconfig
KERNEL_DIR             = $(BUILD_TMP)/linux
KERNELNAME             = vmlinux
CUSTOM_KERNEL_VER      = $(KERNEL_VER)

KERNEL_PATCHES_MIPSEL  = \
		mips/vuduo/add-dmx-source-timecode.patch \
		mips/vuduo/af9015-output-full-range-SNR.patch \
		mips/vuduo/af9033-output-full-range-SNR.patch \
		mips/vuduo/as102-adjust-signal-strength-report.patch \
		mips/vuduo/as102-scale-MER-to-full-range.patch \
		mips/vuduo/cinergy_s2_usb_r2.patch \
		mips/vuduo/cxd2820r-output-full-range-SNR.patch \
		mips/vuduo/dvb-usb-dib0700-disable-sleep.patch \
		mips/vuduo/dvb_usb_disable_rc_polling.patch \
		mips/vuduo/it913x-switch-off-PID-filter-by-default.patch \
		mips/vuduo/tda18271-advertise-supported-delsys.patch \
		mips/vuduo/fix-dvb-siano-sms-order.patch \
		mips/vuduo/mxl5007t-add-no_probe-and-no_reset-parameters.patch \
		mips/vuduo/nfs-max-rwsize-8k.patch \
		mips/vuduo/0001-rt2800usb-add-support-for-rt55xx.patch \
		mips/vuduo/linux-sata_bcm.patch \
		mips/vuduo/fix_fuse_for_linux_mips_3-9.patch \
		mips/vuduo/rt2800usb_fix_warn_tx_status_timeout_to_dbg.patch \
		mips/vuduo/linux-3.9-gcc-4.9.3-build-error-fixed.patch \
		mips/vuduo/kernel-add-support-for-gcc5.patch \
		mips/vuduo/kernel-add-support-for-gcc6.patch \
		mips/vuduo/kernel-add-support-for-gcc7.patch \
		mips/vuduo/kernel-add-support-for-gcc8.patch \
		mips/vuduo/kernel-add-support-for-gcc9.patch \
		mips/vuduo/gcc9_backport.patch \
		mips/vuduo/rtl8712-fix-warnings.patch \
		mips/vuduo/rtl8187se-fix-warnings.patch \
		mips/vuduo/0001-Support-TBS-USB-drivers-3.9.patch \
		mips/vuduo/0001-STV-Add-PLS-support.patch \
		mips/vuduo/0001-STV-Add-SNR-Signal-report-parameters.patch \
		mips/vuduo/0001-stv090x-optimized-TS-sync-control.patch \
		mips/vuduo/blindscan2.patch \
		mips/vuduo/genksyms_fix_typeof_handling.patch \
		mips/vuduo/0002-log2-give-up-on-gcc-constant-optimizations.patch \
		mips/vuduo/0003-cp1emu-do-not-use-bools-for-arithmetic.patch \
		mips/vuduo/test.patch \
		mips/vuduo/01-10-si2157-Silicon-Labs-Si2157-silicon-tuner-driver.patch \
		mips/vuduo/02-10-si2168-Silicon-Labs-Si2168-DVB-T-T2-C-demod-driver.patch \
		mips/vuduo/CONFIG_DVB_SP2.patch \
		mips/vuduo/dvbsky-t330.patch

#
# driver
#
DRIVER_VER = 3.9.6
DRIVER_DATE = 20151124
DRIVER_SRC = vuplus-dvb-modules-bm750-$(DRIVER_VER)-$(DRIVER_DATE).tar.gz

$(ARCHIVE)/$(DRIVER_SRC):
	$(WGET) http://archive.vuplus.com/download/drivers/$(DRIVER_SRC)

#$(D)/driver: $(ARCHIVE)/$(DRIVER_SRC) $(D)/bootstrap $(D)/kernel
#	$(START_BUILD)
#	install -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
#	tar -xf $(ARCHIVE)/$(DRIVER_SRC) -C $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
#	$(TOUCH)

#
# release
#
release-vuduo:
	install -m 0755 $(SKEL_ROOT)/etc/init.d/halt_vuduo $(RELEASE_DIR)/etc/init.d/halt
	cp -f $(SKEL_ROOT)/etc/fstab_vuduo $(RELEASE_DIR)/etc/fstab
	cp $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra/*.ko $(RELEASE_DIR)/lib/modules/

#
# flashimage
#
VUDUO_PREFIX = vuplus/duo

flash-image-vuduo:
	# Create final USB-image
	mkdir -p $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)
	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
	# splash
	cp $(SKEL_ROOT)/boot/splash.bin $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)
	echo "This file forces a reboot after the update." > $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/reboot.update;
	# kernel
	gzip -9c < "$(TARGET_DIR)/boot/vmlinux" > "$(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/kernel_cfe_auto.bin"
	# rootfs
	mkfs.ubifs -r $(RELEASE_DIR) -o $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/root_cfe_auto.ubi -m 2048 -e 126976 -c 4096 -F
	echo '[ubifs]' > $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'mode=ubi' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'image=$(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/root_cfe_auto.ubi' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'vol_id=0' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'vol_type=dynamic' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'vol_name=rootfs' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'vol_flags=autoresize' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	ubinize -o $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/root_cfe_auto.jffs2 -m 2048 -p 128KiB $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	rm -f $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/root_cfe_auto.ubi
	rm -f $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo $(BOXTYPE)_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/imageversion
	cd $(IMAGE_BUILD_DIR)/ && \
	zip -r $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(VUDUO_PREFIX)*
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)



