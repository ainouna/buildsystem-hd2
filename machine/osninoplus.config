BOXARCH = mips
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
KERNEL_VER             = 4.8.17
KERNEL_SRC             = linux-edision-$(KERNEL_VER).tar.xz
KERNEL_URL             = http://source.mynonpublic.com/edision
KERNEL_CONFIG          = $(BOXTYPE)_defconfig
KERNEL_DIR             = $(BUILD_TMP)/linux-$(KERNEL_VER)
KERNELNAME             = vmlinux
CUSTOM_KERNEL_VER      = $(KERNEL_VER)

KERNEL_PATCHES_MIPSEL  = \
		mips/osnino/0001-Support-TBS-USB-drivers-for-4.6-kernel.patch \
		mips/osnino/0001-TBS-fixes-for-4.6-kernel.patch \
		mips/osnino/0001-STV-Add-PLS-support.patch \
		mips/osnino/0001-STV-Add-SNR-Signal-report-parameters.patch \
		mips/osnino/blindscan2.patch \
		mips/osnino/0001-stv090x-optimized-TS-sync-control.patch \
		mips/osnino/0002-log2-give-up-on-gcc-constant-optimizations.patch \
		mips/osnino/0003-cp1emu-do-not-use-bools-for-arithmetic.patch \
		mips/osnino/move-default-dialect-to-SMB3.patch

#
# driver
#
DRIVER_VER = 4.8.17
DRIVER_DATE = 20201104
DRIVER_SRC = $(BOXTYPE)-drivers-$(DRIVER_VER)-$(DRIVER_DATE).zip

$(ARCHIVE)/$(DRIVER_SRC):
	$(WGET) http://source.mynonpublic.com/edision/$(DRIVER_SRC)

#
# release
#
release-osninoplus:
	install -m 0755 $(SKEL_ROOT)/etc/init.d/halt_$(BOXTYPE) $(RELEASE_DIR)/etc/init.d/halt
	cp -f $(SKEL_ROOT)/etc/fstab_$(BOXTYPE) $(RELEASE_DIR)/etc/fstab
	cp $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra/*.ko $(RELEASE_DIR)/lib/modules/

#
# flashimage
#
OSNINO_PREFIX = edision/osninoplus

flash-image-osninoplus:
	# Create final USB-image
	mkdir -p $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)
	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
	# splash
	cp $(SKEL_ROOT)/boot/splash.bin $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)
	echo "rename this file to 'force' to force an update without confirmation" > $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/noforce;
	# kernel
	gzip -9c < "$(TARGET_DIR)/boot/vmlinux" > "$(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/kernel.bin"
	# rootfs
	mkfs.ubifs -r $(RELEASE_DIR) -o $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/rootfs.ubi -m 2048 -e 126976 -c 4096 -F
	echo '[ubifs]' > $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/ubinize.cfg
	echo 'mode=ubi' >> $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/ubinize.cfg
	echo 'image=$(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/rootfs.ubi' >> $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/ubinize.cfg
	echo 'vol_id=0' >> $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/ubinize.cfg
	echo 'vol_type=dynamic' >> $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/ubinize.cfg
	echo 'vol_name=rootfs' >> $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/ubinize.cfg
	echo 'vol_flags=autoresize' >> $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/ubinize.cfg
	ubinize -o $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/rootfs.bin -m 2048 -p 128KiB $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	rm -f $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/rootfs.ubi
	rm -f $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/ubinize.cfg
	echo $(BOXTYPE)_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/imageversion
	cd $(IMAGE_BUILD_DIR)/ && \
	zip -r $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(OSNINO_PREFIX)*
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

