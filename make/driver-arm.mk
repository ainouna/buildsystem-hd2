#
# driver
#
# hd51
ifeq ($(BOXTYPE), hd51)
DRIVER_VER = 4.10.12
DRIVER_DATE = 20180424
DRIVER_SRC = $(BOXTYPE)-drivers-$(DRIVER_VER)-$(DRIVER_DATE).zip

$(ARCHIVE)/$(DRIVER_SRC):
	$(WGET) http://source.mynonpublic.com/gfutures/$(DRIVER_SRC)
endif

# hd60
ifeq ($(BOXTYPE), hd60)
DRIVER_VER = 4.4.35
DRIVER_DATE = 20200731
DRIVER_SRC = $(BOXTYPE)-drivers-$(DRIVER_VER)-$(DRIVER_DATE).zip

EXTRA_PLAYERLIB_DATE = 20180912
EXTRA_PLAYERLIB_SRC = $(BOXTYPE)-libs-$(EXTRA_PLAYERLIB_DATE).zip

EXTRA_MALILIB_DATE = 20180912
EXTRA_MALILIB_SRC = $(BOXTYPE)-mali-$(EXTRA_MALILIB_DATE).zip

EXTRA_MALI_MODULE_VER = DX910-SW-99002-r7p0-00rel0
EXTRA_MALI_MODULE_SRC = $(EXTRA_MALI_MODULE_VER).tgz
EXTRA_MALI_MODULE_PATCH = 0001-hi3798mv200-support.patch

$(ARCHIVE)/$(DRIVER_SRC):
	$(WGET) http://source.mynonpublic.com/gfutures/$(DRIVER_SRC)

$(ARCHIVE)/$(EXTRA_PLAYERLIB_SRC):
	$(WGET) http://source.mynonpublic.com/gfutures/$(EXTRA_PLAYERLIB_SRC)

$(ARCHIVE)/$(EXTRA_MALILIB_SRC):
	$(WGET) http://source.mynonpublic.com/gfutures//$(EXTRA_MALILIB_SRC)

$(ARCHIVE)/$(EXTRA_MALI_MODULE_SRC):
	$(WGET) https://developer.arm.com/-/media/Files/downloads/mali-drivers/kernel/mali-utgard-gpu/$(EXTRA_MALI_MODULE_SRC);name=driver
endif

# vusolo4k
ifeq ($(BOXTYPE), vusolo4k)
DRIVER_VER = 3.14.28
DRIVER_DATE = 20180702
DRIVER_REV = r0
DRIVER_SRC = vuplus-dvb-proxy-$(BOXTYPE)-$(DRIVER_VER)-$(DRIVER_DATE).$(DRIVER_REV).tar.gz

$(ARCHIVE)/$(DRIVER_SRC):
	$(WGET) http://archive.vuplus.com/download/build_support/vuplus/$(DRIVER_SRC)
endif

# osmio4k | osmio4kplus | osmini4k
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), osmio4k osmio4kplus osmini4k))
DRIVER_VER = 5.9.0
DRIVER_DATE = 20201013
DRIVER_REV =
DRIVER_SRC = $(BOXTYPE)-drivers-$(DRIVER_VER)-$(DRIVER_DATE).zip

LIBGLES_VER = 2.0
LIBGLES_DIR = edision-libv3d-$(LIBGLES_VER)
LIBGLES_SRC = edision-libv3d-$(LIBGLES_VER).tar.xz

$(ARCHIVE)/$(DRIVER_SRC):
	$(WGET) http://source.mynonpublic.com/edision/$(DRIVER_SRC)

$(ARCHIVE)/$(LIBGLES_SRC):
	$(WGET) http://source.mynonpublic.com/edision/$(LIBGLES_SRC)
endif

# bre3ze4k
ifeq ($(BOXTYPE), bre2ze4k)
DRIVER_VER = 4.10.12
DRIVER_DATE = 20191120
DRIVER_SRC = bre2ze4k-drivers-$(DRIVER_VER)-$(DRIVER_DATE).zip

LIBGLES_DATE = 20191101
LIBGLES_SRC = bre2ze4k-v3ddriver-$(LIBGLES_DATE).zip

LIBGLES_HEADERS = hd-v3ddriver-headers.tar.gz

$(ARCHIVE)/$(DRIVER_SRC):
	$(DOWNLOAD) http://source.mynonpublic.com/gfutures/$(DRIVER_SRC)

$(ARCHIVE)/$(LIBGLES_SRC):
	$(DOWNLOAD) http://downloads.mutant-digital.net/v3ddriver/$(LIBGLES_SRC)

$(ARCHIVE)/$(LIBGLES_HEADERS):
	$(DOWNLOAD) http://downloads.mutant-digital.net/v3ddriver/$(LIBGLES_HEADERS)
endif

driver-clean:
	rm -f $(D)/driver $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra/*

driver: $(D)/driver
$(D)/driver: $(ARCHIVE)/$(DRIVER_SRC) $(D)/bootstrap $(D)/kernel
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), osmio4k osmio4kplus))
	$(START_BUILD)
	install -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	unzip -o $(ARCHIVE)/$(DRIVER_SRC) -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	for i in brcmstb-$(BOXTYPE) brcmstb-decoder ci si2183 avl6862 avl6261; do \
		echo $$i >> $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/modules.default; \
	done
	$(MAKE) install-v3ddriver
	$(MAKE) wlan-qcom
	$(TOUCH)
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), osmini4k))
	$(START_BUILD)
	install -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	unzip -o $(ARCHIVE)/$(DRIVER_SRC) -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	for i in brcmstb-$(BOXTYPE) ci si2183 avl6862 avl6261; do \
		echo $$i >> $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/modules.default; \
	done
	$(MAKE) install-v3ddriver
	$(MAKE) wlan-qcom
	$(TOUCH)
endif
ifeq ($(BOXTYPE), hd51)
	$(START_BUILD)
	install -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	unzip -o $(ARCHIVE)/$(DRIVER_SRC) -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	$(TOUCH)
endif
ifeq ($(BOXTYPE), hd60)
	$(START_BUILD)
	install -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	unzip -o $(ARCHIVE)/$(DRIVER_SRC) -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	install -d $(TARGET_DIR)/bin
	mv $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra/turnoff_power $(TARGET_DIR)/bin
	$(MAKE) install-extra-libs
	$(MAKE) mali-gpu-modul
	$(TOUCH)

$(D)/install-extra-libs: $(ARCHIVE)/$(EXTRA_PLAYERLIB_SRC) $(ARCHIVE)/$(EXTRA_MALILIB_SRC) $(D)/zlib $(D)/libpng $(D)/freetype $(D)/libcurl $(D)/libxml2 $(D)/libjpeg_turbo2
	install -d $(TARGET_DIR)/usr/lib
	unzip -o $(PATCHES)/libgles-mali-utgard-headers.zip -d $(TARGET_DIR)/usr/include
	unzip -o $(ARCHIVE)/$(EXTRA_PLAYERLIB_SRC) -d $(TARGET_DIR)/usr/lib
	unzip -o $(ARCHIVE)/$(EXTRA_MALILIB_SRC) -d $(TARGET_DIR)/usr/lib
	ln -sf libMali.so $(TARGET_DIR)/usr/lib/libmali.so
	ln -sf libMali.so $(TARGET_DIR)/usr/lib/libEGL.so
	ln -sf libMali.so $(TARGET_DIR)/usr/lib/libGLESv1_CM.so
	ln -sf libMali.so $(TARGET_DIR)/usr/lib/libGLESv2.so

$(D)/mali-gpu-modul: $(ARCHIVE)/$(EXTRA_MALI_MODULE_SRC) $(D)/bootstrap $(D)/kernel
	$(START_BUILD)
	$(REMOVE)/$(EXTRA_MALI_MODULE_VER)
	$(UNTAR)/$(EXTRA_MALI_MODULE_SRC)
	$(CHDIR)/$(EXTRA_MALI_MODULE_VER); \
		$(call apply_patches,$(EXTRA_MALI_MODULE_PATCH)); \
		$(MAKE) -C $(KERNEL_DIR) ARCH=arm CROSS_COMPILE=$(TARGET)- \
		M=$(BUILD_TMP)/$(EXTRA_MALI_MODULE_VER)/driver/src/devicedrv/mali \
		EXTRA_CFLAGS="-DCONFIG_MALI_SHARED_INTERRUPTS=y \
		-DCONFIG_MALI400=m \
		-DCONFIG_MALI450=y \
		-DCONFIG_MALI_DVFS=y \
		-DCONFIG_GPU_AVS_ENABLE=y" \
		CONFIG_MALI_SHARED_INTERRUPTS=y \
		CONFIG_MALI400=m \
		CONFIG_MALI450=y \
		CONFIG_MALI_DVFS=y \
		CONFIG_GPU_AVS_ENABLE=y ; \
		$(MAKE) -C $(KERNEL_DIR) ARCH=arm CROSS_COMPILE=$(TARGET)- \
		M=$(BUILD_TMP)/$(EXTRA_MALI_MODULE_VER)/driver/src/devicedrv/mali \
		EXTRA_CFLAGS="-DCONFIG_MALI_SHARED_INTERRUPTS=y \
		-DCONFIG_MALI400=m \
		-DCONFIG_MALI450=y \
		-DCONFIG_MALI_DVFS=y \
		-DCONFIG_GPU_AVS_ENABLE=y" \
		CONFIG_MALI_SHARED_INTERRUPTS=y \
		CONFIG_MALI400=m \
		CONFIG_MALI450=y \
		CONFIG_MALI_DVFS=y \
		CONFIG_GPU_AVS_ENABLE=y \
		DEPMOD=$(DEPMOD) INSTALL_MOD_PATH=$(TARGET_DIR) modules_install
	$(REMOVE)/$(EXTRA_MALI_MODULE_VER)
	$(TOUCH)
endif

ifeq ($(BOXTYPE), vusolo4k)
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
UTIL_VER = 17.1
UTIL_DATE = 20180702
UTIL_REV = r0
UTIL_SRC = platform-util-$(BOXTYPE)-$(UTIL_VER)-$(UTIL_DATE).$(UTIL_REV).tar.gz

$(ARCHIVE)/$(UTIL_SRC):
	$(WGET) http://archive.vuplus.com/download/build_support/vuplus/$(UTIL_SRC)

$(D)/platform_util: $(D)/bootstrap $(ARCHIVE)/$(UTIL_SRC)
	$(START_BUILD)
	$(UNTAR)/$(UTIL_SRC)
	install -m 0755 $(BUILD_TMP)/platform-util-$(BOXTYPE)/* $(TARGET_DIR)/usr/bin
	$(REMOVE)/platform-util-$(BOXTYPE)
	$(TOUCH)

#
# libgles
#
GLES_VER = 17.1
GLES_DATE = 20180702
GLES_REV = r0
GLES_SRC = libgles-$(BOXTYPE)-$(GLES_VER)-$(GLES_DATE).$(GLES_REV).tar.gz

$(ARCHIVE)/$(GLES_SRC):
	$(WGET) http://archive.vuplus.com/download/build_support/vuplus/$(GLES_SRC)

$(D)/libgles: $(D)/bootstrap $(ARCHIVE)/$(GLES_SRC)
	$(START_BUILD)
	$(UNTAR)/$(GLES_SRC)
	install -m 0755 $(BUILD_TMP)/libgles-$(BOXTYPE)/lib/* $(TARGET_DIR)/usr/lib
	ln -sf libv3ddriver.so $(TARGET_DIR)/usr/lib/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_DIR)/usr/lib/libGLESv2.so
	cp -a $(BUILD_TMP)/libgles-$(BOXTYPE)/include/* $(TARGET_DIR)/usr/include
	$(REMOVE)/libgles-$(BOXTYPE)
	$(TOUCH)

#
# vmlinuz initrd
#
INITRD_DATE = 20170209
INITRD_SRC = vmlinuz-initrd_$(BOXTYPE)_$(INITRD_DATE).tar.gz

$(ARCHIVE)/$(INITRD_SRC):
	$(WGET) http://archive.vuplus.com/download/kernel/$(INITRD_SRC)

$(D)/vmlinuz_initrd: $(D)/bootstrap $(ARCHIVE)/$(INITRD_SRC)
	$(START_BUILD)
	tar -xf $(ARCHIVE)/$(INITRD_SRC) -C $(TARGET_DIR)/boot
	install -d $(TARGET_DIR)/boot
	$(TOUCH)
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), osmio4k osmio4kplus osmini4k))
$(D)/install-v3ddriver: $(ARCHIVE)/$(LIBGLES_SRC)
	install -d $(TARGET_LIB_DIR)
	$(REMOVE)/$(LIBGLES_DIR)
	$(UNTAR)/$(LIBGLES_SRC)
	cp -a $(BUILD_TMP)/$(LIBGLES_DIR)/* $(TARGET_DIR)/usr/
	ln -sf libv3ddriver.so.$(LIBGLES_VER) $(TARGET_LIB_DIR)/libEGL.so
	ln -sf libv3ddriver.so.$(LIBGLES_VER) $(TARGET_LIB_DIR)/libGLESv2.so
	$(REMOVE)/$(LIBGLES_DIR)

#
# wlan-qcom osmio4k | osmio4kplus | osmini4
#
WLAN_QCOM_VER    = 4.5.25.46
WLAN_QCOM_DIR    = qcacld-2.0-$(WLAN_QCOM_VER)
WLAN_QCOM_SOURCE = qcacld-2.0-$(WLAN_QCOM_VER).tar.gz
WLAN_QCOM_URL    = https://www.codeaurora.org/cgit/external/wlan/qcacld-2.0/snapshot

$(ARCHIVE)/$(WLAN_QCOM_SOURCE):
	$(WGET) $(WLAN_QCOM_URL)/$(WLAN_QCOM_SOURCE)

WLAN_QCOM_PATCH  = \
	qcacld-2.0-support.patch

$(D)/wlan-qcom: $(D)/bootstrap $(D)/kernel $(D)/wlan-qcom-firmware $(ARCHIVE)/$(WLAN_QCOM_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(WLAN_QCOM_DIR)
	$(UNTAR)/$(WLAN_QCOM_SOURCE)
	$(CHDIR)/$(WLAN_QCOM_DIR); \
		$(call apply_patches, $(WLAN_QCOM_PATCH)); \
		$(MAKE) KERNEL_SRC=$(KERNEL_DIR) ARCH=arm CROSS_COMPILE=$(TARGET)- CROSS_COMPILE_COMPAT=$(TARGET)- all; \
	install -m 644 wlan.ko $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	$(REMOVE)/$(WLAN_QCOM_DIR)
	$(TOUCH)

#
# wlan-qcom-firmware
#
WLAN_QCOM_FIRMWARE_VER    = qca6174
WLAN_QCOM_FIRMWARE_DIR    = firmware-$(WLAN_QCOM_FIRMWARE_VER)
WLAN_QCOM_FIRMWARE_SOURCE = firmware-$(WLAN_QCOM_FIRMWARE_VER).zip
WLAN_QCOM_FIRMWARE_URL    = http://source.mynonpublic.com/edision

$(ARCHIVE)/$(WLAN_QCOM_FIRMWARE_SOURCE):
	$(WGET) $(WLAN_QCOM_FIRMWARE_URL)/$(WLAN_QCOM_FIRMWARE_SOURCE)

$(D)/wlan-qcom-firmware: $(D)/bootstrap $(ARCHIVE)/$(WLAN_QCOM_FIRMWARE_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(WLAN_QCOM_FIRMWARE_DIR)
	unzip -o $(ARCHIVE)/$(WLAN_QCOM_FIRMWARE_SOURCE) -d $(BUILD_TMP)/$(WLAN_QCOM_FIRMWARE_DIR)
	$(CHDIR)/$(WLAN_QCOM_FIRMWARE_DIR); \
		install -d $(TARGET_DIR)/lib/firmware/ath10k/QCA6174/hw3.0; \
		install -m 644 board.bin $(TARGET_DIR)/lib/firmware/ath10k/QCA6174/hw3.0/board.bin; \
		install -m 644 firmware-4.bin $(TARGET_DIR)/lib/firmware/ath10k/QCA6174/hw3.0/firmware-4.bin; \
		install -d $(TARGET_DIR)/lib/firmware/wlan; \
		install -m 644 bdwlan30.bin $(TARGET_DIR)/lib/firmware/bdwlan30.bin; \
		install -m 644 otp30.bin $(TARGET_DIR)/lib/firmware/otp30.bin; \
		install -m 644 qwlan30.bin $(TARGET_DIR)/lib/firmware/qwlan30.bin; \
		install -m 644 utf30.bin $(TARGET_DIR)/lib/firmware/utf30.bin; \
		install -m 644 wlan/cfg.dat $(TARGET_DIR)/lib/firmware/wlan/cfg.dat; \
		install -m 644 wlan/qcom_cfg.ini $(TARGET_DIR)/lib/firmware/wlan/qcom_cfg.ini; \
		install -m 644 btfw32.tlv $(TARGET_DIR)/lib/firmware/btfw32.tlv
	$(REMOVE)/$(WLAN_QCOM_FIRMWARE_DIR)
	$(TOUCH)
endif
ifeq ($(BOXTYPE), bre2ze4k)
	$(START_BUILD)
	install -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	unzip -o $(ARCHIVE)/$(DRIVER_SRC) -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	ls $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra | sed s/.ko//g > $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/modules.default
	$(MAKE) install-v3ddriver
	$(MAKE) install-v3ddriver-header
	$(TOUCH)

$(D)/install-v3ddriver: $(ARCHIVE)/$(LIBGLES_SRC)
	install -d $(TARGET_LIB_DIR)
	unzip -o $(ARCHIVE)/$(LIBGLES_SRC) -d $(TARGET_LIB_DIR)
	#patchelf --set-soname libv3ddriver.so $(TARGET_LIB_DIR)/libv3ddriver.so
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libEGL.so.1.4
	ln -sf libEGL.so.1.4 $(TARGET_LIB_DIR)/libEGL.so.1
	ln -sf libEGL.so.1 $(TARGET_LIB_DIR)/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libGLESv1_CM.so.1.1
	ln -sf libGLESv1_CM.so.1.1 $(TARGET_LIB_DIR)/libGLESv1_CM.so.1
	ln -sf libGLESv1_CM.so.1 $(TARGET_LIB_DIR)/libGLESv1_CM.so
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libGLESv2.so.2.0
	ln -sf libGLESv2.so.2.0 $(TARGET_LIB_DIR)/libGLESv2.so.2
	ln -sf libGLESv2.so.2 $(TARGET_LIB_DIR)/libGLESv2.so
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libgbm.so.1
	ln -sf libgbm.so.1 $(TARGET_LIB_DIR)/libgbm.so

$(D)/install-v3ddriver-header: $(ARCHIVE)/$(LIBGLES_HEADERS)
	install -d $(TARGET_INCLUDE_DIR)
	tar -xf $(ARCHIVE)/$(LIBGLES_HEADERS) -C $(TARGET_INCLUDE_DIR)
endif

