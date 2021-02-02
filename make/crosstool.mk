# makefile to build crosstools
crosstool-renew:
	ccache -cCz
	make distclean
	rm -rf $(CROSS_DIR)
	make crosstool

$(TARGET_DIR)/lib/libc.so.6:
	if test -e $(CROSS_DIR)/$(TARGET)/sys-root/lib; then \
		cp -a $(CROSS_DIR)/$(TARGET)/sys-root/lib/*so* $(TARGET_DIR)/lib; \
	else \
		cp -a $(CROSS_DIR)/$(TARGET)/lib/*so* $(TARGET_DIR)/lib; \
	fi

#
# crosstool-ng
#
#CROSSTOOL_NG_VER = 872341e3
CROSSTOOL_NG_VER = 7bd6bb00
CROSSTOOL_NG_SOURCE = crosstool-ng-git-$(CROSSTOOL_NG_VER).tar.bz2
CROSSTOOL_NG_URL = https://github.com/crosstool-ng/crosstool-ng.git
ifeq ($(BOXARCH), arm)
#GCC_VER = linaro-6.3-2017.05
GCC_VER = 6.5.0
endif
ifeq ($(BOXARCH), mips)
#GCC_VER = 4.9.4
GCC_VER = 6.5.0
CUSTOM_KERNEL_VER = $(KERNEL_VER)
endif

ifeq ($(BOXARCH), arm)
ifeq ($(BOXTYPE), hd51)
CUSTOM_KERNEL_VER = $(KERNEL_VER)-arm
endif
ifeq ($(BOXTYPE), hd60)
CUSTOM_KERNEL_VER = $(KERNEL_VER)-$(KERNEL_DATE)-arm
endif
ifeq ($(BOXTYPE), vusolo4k)
CUSTOM_KERNEL_VER = $(KERNEL_SRC_VER)
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), osmio4k osmio4kplus osmini4k))
CUSTOM_KERNEL_VER = $(KERNEL_VER)
endif
ifeq ($(BOXTYPE), bre2ze4k)
CUSTOM_KERNEL_VER = $(KERNEL_VER)-arm
endif
ifeq ($(BOXTYPE), h7)
CUSTOM_KERNEL_VER = $(KERNEL_VER)-arm
endif
ifeq ($(BOXTYPE), hd61)
CUSTOM_KERNEL_VER = $(KERNEL_VER)-$(KERNEL_DATE)-arm
endif
ifeq ($(BOXTYPE), vuduo4k)
CUSTOM_KERNEL_VER = $(KERNEL_SRC_VER)
endif
ifeq ($(BOXTYPE), vuultimo4k)
CUSTOM_KERNEL_VER = $(KERNEL_SRC_VER)
endif
ifeq ($(BOXTYPE), vuuno4k)
CUSTOM_KERNEL_VER = $(KERNEL_SRC_VER)
endif
ifeq ($(BOXTYPE), vuuno4kse)
CUSTOM_KERNEL_VER = $(KERNEL_SRC_VER)
endif
ifeq ($(BOXTYPE), vuzero4k)
CUSTOM_KERNEL_VER = $(KERNEL_SRC_VER)
endif
endif

$(ARCHIVE)/$(CROSSTOOL_NG_SOURCE):
	$(SCRIPTS_DIR)/get-git-archive.sh $(CROSSTOOL_NG_URL) $(CROSSTOOL_NG_VER) $(notdir $@) $(ARCHIVE)

ifeq ($(wildcard $(CROSS_DIR)/build.log.bz2),)
CROSSTOOL = crosstool
crosstool:
	make MAKEFLAGS=--no-print-directory crosstool-ng
	if [ ! -e $(CROSSTOOL_NG_BACKUP) ]; then \
		make crosstool-backup; \
	fi;

crosstool-ng: $(D)/directories $(ARCHIVE)/$(KERNEL_SRC) $(ARCHIVE)/$(CROSSTOOL_NG_SOURCE) kernel.do_prepare
	make $(BUILD_TMP)
	if [ ! -e $(CROSS_DIR) ]; then \
		mkdir -p $(CROSS_DIR); \
	fi;
	$(REMOVE)/crosstool-ng-$(CROSSTOOL_NG_VER)
	$(UNTAR)/$(CROSSTOOL_NG_SOURCE)
	unset CONFIG_SITE LIBRARY_PATH LD_LIBRARY_PATH CPATH C_INCLUDE_PATH PKG_CONFIG_PATH CPLUS_INCLUDE_PATH INCLUDE; \
	$(CHDIR)/crosstool-ng-git-$(CROSSTOOL_NG_VER); \
		cp -a $(PATCHES)/ct-ng/crosstool-ng-$(CROSSTOOL_NG_VER)-$(BOXARCH)-gcc-$(GCC_VER).config .config; \
		NUM_CPUS=$$(expr `getconf _NPROCESSORS_ONLN` \* 2); \
		MEM_512M=$$(awk '/MemTotal/ {M=int($$2/1024/512); print M==0?1:M}' /proc/meminfo); \
		test $$NUM_CPUS -gt $$MEM_512M && NUM_CPUS=$$MEM_512M; \
		test $$NUM_CPUS = 0 && NUM_CPUS=1; \
		sed -i "s@^CT_PARALLEL_JOBS=.*@CT_PARALLEL_JOBS=$$NUM_CPUS@" .config; \
		\
		$(call apply_patches, $(CROSSTOOL_BOXTYPE_PATCH)); \
		\
		export CT_NG_ARCHIVE=$(ARCHIVE); \
		export CT_NG_BASE_DIR=$(CROSS_DIR); \
		export CT_NG_CUSTOM_KERNEL=$(KERNEL_DIR); \
		export CT_NG_CUSTOM_KERNEL_VER=$(CUSTOM_KERNEL_VER); \
		test -f ./configure || ./bootstrap && \
		./configure --enable-local; \
		MAKELEVEL=0 make; \
		chmod 0755 ct-ng; \
		./ct-ng oldconfig; \
		./ct-ng build
	chmod -R +w $(CROSS_DIR)
	test -e $(CROSS_DIR)/$(TARGET)/lib || ln -sf sys-root/lib $(CROSS_DIR)/$(TARGET)/
	rm -f $(CROSS_DIR)/$(TARGET)/sys-root/lib/libstdc++.so.6.0.20-gdb.py
	$(REMOVE)/crosstool-ng-git-$(CROSSTOOL_NG_VER)
endif

crosstool-backup:
	cd $(CROSS_DIR); \
	tar czvf $(ARCHIVE)/crosstool-ng-$(CROSSTOOL_NG_VER)-$(BOXARCH)-gcc-$(GCC_VER)-kernel-$(KERNEL_VER)-backup.tar.gz *

crosstool-restore: $(ARCHIVE)/crosstool-ng-$(CROSSTOOL_NG_VER)-$(BOXARCH)-gcc-$(GCC_VER)-kernel-$(KERNEL_VER)-backup.tar.gz
	rm -rf $(CROSS_DIR) ; \
	if [ ! -e $(CROSS_DIR) ]; then \
		mkdir -p $(CROSS_DIR); \
	fi;
	tar xzvf $(ARCHIVE)/crosstool-ng-$(CROSSTOOL_NG_VER)-$(BOXARCH)-gcc-$(GCC_VER)-kernel-$(KERNEL_VER)-backup.tar.gz -C $(CROSS_DIR)

crossmenuconfig: $(D)/directories $(ARCHIVE)/$(CROSSTOOL_NG_SOURCE)
	$(REMOVE)/crosstool-ng-git-$(CROSSTOOL_NG_VER)
	$(UNTAR)/$(CROSSTOOL_NG_SOURCE)
	set -e; unset CONFIG_SITE; cd $(BUILD_TMP)/crosstool-ng-git-$(CROSSTOOL_NG_VER); \
		cp -a $(PATCHES)/ct-ng/crosstool-ng-$(CROSSTOOL_NG_VER)-$(BOXARCH)-gcc-$(GCC_VER).config .config; \
		test -f ./configure || ./bootstrap && \
		./configure --enable-local; \
		MAKELEVEL=0 make; \
		chmod 0755 ct-ng; \
		./ct-ng menuconfig


