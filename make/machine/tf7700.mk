BOXARCH = sh4
OPTIMIZATIONS ?= size
WLAN ?= 
MEDIAFW ?= buildinplayer
INTERFACE ?=lua
CICAM = ci-cam
SCART = scart
LCD = vfd
FKEYS =

#
# kernel
#
KERNEL_STM ?= p0217

TF7700_PATCHES_24 = $(COMMON_PATCHES_24) \
		linux-sh4-tf7700_setup_stm24_$(KERNEL_LABEL).patch \
		linux-usbwait123_stm24.patch \
		linux-sh4-stmmac_stm24_$(KERNEL_LABEL).patch \
		linux-sh4-i2c-st40-pio_stm24_$(KERNEL_LABEL).patch \
		$(if $(P0209),linux-sh4-sata-v06_stm24_$(KERNEL_LABEL).patch)

KERNEL_PATCHES_24  = $(TF7700_PATCHES_24)

#
# TF7700 installer
#
TFINSTALLER_DIR := $(HOSTAPPS_DIR)/tfinstaller

tfinstaller: $(D)/bootstrap $(TFINSTALLER_DIR)/u-boot.ftfd $(D)/kernel
	$(START_BUILD)
	$(MAKE) $(MAKE_OPTS) -C $(TFINSTALLER_DIR) HOST_DIR=$(HOST_DIR) BASE_DIR=$(BASE_DIR) KERNEL_DIR=$(KERNEL_DIR)
	$(TOUCH)

$(TFINSTALLER_DIR)/u-boot.ftfd: $(D)/uboot $(TFINSTALLER_DIR)/tfpacker
	$(START_BUILD)
	$(TFINSTALLER_DIR)/tfpacker $(BUILD_TMP)/u-boot-$(UBOOT_VER)/u-boot.bin $(TFINSTALLER_DIR)/u-boot.ftfd
	$(TFINSTALLER_DIR)/tfpacker -t $(BUILD_TMP)/u-boot-$(UBOOT_VER)/u-boot.bin $(TFINSTALLER_DIR)/Enigma_Installer.tfd
	$(REMOVE)/u-boot-$(UBOOT_VER)
	$(TOUCH)

$(TFINSTALLER_DIR)/tfpacker:
	$(START_BUILD)
	$(MAKE) -C $(TFINSTALLER_DIR) tfpacker
	$(TOUCH)

$(D)/tfkernel:
	$(START_BUILD)
	cd $(KERNEL_DIR); \
		$(MAKE) $(if $(TF7700),TF7700=y) ARCH=sh CROSS_COMPILE=$(TARGET)- $(KERNELNAME)
	$(TOUCH)

#
# u-boot
#
UBOOT_VER = 1.3.1
UBOOT_PATCH  =  u-boot-$(UBOOT_VER).patch
ifeq ($(BOXTYPE), tf7700)
UBOOT_PATCH += u-boot-$(UBOOT_VER)-tf7700.patch
endif

$(ARCHIVE)/u-boot-$(UBOOT_VER).tar.bz2:
	$(WGET) ftp://ftp.denx.de/pub/u-boot/u-boot-$(UBOOT_VER).tar.bz2

$(D)/uboot: bootstrap $(ARCHIVE)/u-boot-$(UBOOT_VER).tar.bz2
	$(START_BUILD)
	$(REMOVE)/u-boot-$(UBOOT_VER)
	$(UNTAR)/u-boot-$(UBOOT_VER).tar.bz2
	set -e; cd $(BUILD_TMP)/u-boot-$(UBOOT_VER); \
		$(call apply_patches,$(UBOOT_PATCH)); \
		$(MAKE) $(BOXTYPE)_config; \
		$(MAKE)
	$(TOUCH)


#
# driver
#
DRIVER_PLATFORM   = TF7700=tf7700

#
# release
#
release-tf7700:
	install -m 0755 $(SKEL_ROOT)/etc/init.d/halt_tf7700 $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra/frontcontroller/tffp/tffp.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7109.elf $(RELEASE_DIR)/lib/firmware/video.elf
	cp $(SKEL_ROOT)/boot/audio_7100.elf $(RELEASE_DIR)/lib/firmware/audio.elf
	cp $(SKEL_ROOT)/lib/firmware/dvb-fe-cx24116.fw $(RELEASE_DIR)/lib/firmware/
	cp -f $(SKEL_ROOT)/etc/fstab_tf7700 $(RELEASE_DIR)/etc/fstab
	$(MAKE) tfinstaller


#
# flashimage
#
flash-image-tf7700:
	cd $(FLASH_DIR)/tf7700 && $(SUDOCMD) ./tf7700.sh $(MAINTAINER)


