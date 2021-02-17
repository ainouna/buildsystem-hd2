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

CUBEREVO_MINI_PATCHES_24 = $(COMMON_PATCHES_24) \
		linux-sh4-cuberevo_mini_setup_stm24_$(KERNEL_LABEL).patch \
		linux-sh4-i2c-st40-pio_stm24_$(KERNEL_LABEL).patch \
		linux-sh4-cuberevo_rtl8201_stm24_$(KERNEL_LABEL).patch

KERNEL_PATCHES_24  = $(CUBEREVO_MINI_PATCHES_24)

#
# driver
#
DRIVER_PLATFORM   = CUBEREVO_MINI=cuberevo_mini

#
# release
#
release-cuberevo_mini:
	install -m 0755 $(SKEL_ROOT)/etc/init.d/halt_cuberevo $(RELEASE_DIR)/etc/init.d/halt
	install -m 0777 $(SKEL_ROOT)/etc/init.d/reboot_cuberevo $(RELEASE_DIR)/etc/init.d/reboot
	cp $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra/frontcontroller/ipbox/micom.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7109.elf $(RELEASE_DIR)/lib/firmware/video.elf
	cp $(SKEL_ROOT)/boot/audio_7100.elf $(RELEASE_DIR)/lib/firmware/audio.elf
	cp $(SKEL_ROOT)/lib/firmware/dvb-fe-cx24116.fw $(RELEASE_DIR)/lib/firmware/
	cp $(SKEL_ROOT)/lib/firmware/dvb-fe-stv6306.fw $(RELEASE_DIR)/lib/firmware/
	cp $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra/frontends/multituner/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/kernel/drivers/media/dvb/frontends/dvb-pll.ko $(RELEASE_DIR)/lib/modules/


#
# flashimage
#
flash-image-cuberevo_mini:
	cd $(FLASH_DIR)/nor_flash && $(SUDOCMD) ./make_flash.sh $(MAINTAINER) cuberevo_mini




