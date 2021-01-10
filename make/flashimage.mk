#
# flashimage
#

flashimage: release
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), fortis_hdbox octagon1008 ufs910 ufs922 ipbox55 ipbox99 ipbox9900 cuberevo cuberevo_mini cuberevo_mini2 cuberevo_250hd cuberevo_2000hd cuberevo_3000hd))
	cd $(BASE_DIR)/flash/nor_flash && $(SUDOCMD) ./make_flash.sh $(MAINTAINER)
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), spark spark7162))
	cd $(BASE_DIR)/flash/$(BOXTYPE) && $(SUDOCMD) ./$(BOXTYPE).sh $(MAINTAINER)
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), atevio7500))
	cd $(BASE_DIR)/flash/$(BOXTYPE) && $(SUDOCMD) ./$(BOXTYPE).sh $(MAINTAINER)
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), ufs912))
	cd $(BASE_DIR)/flash/$(BOXTYPE) && $(SUDOCMD) ./$(BOXTYPE).sh $(MAINTAINER)
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), ufs913))
	cd $(BASE_DIR)/flash/$(BOXTYPE) && $(SUDOCMD) ./$(BOXTYPE).sh $(MAINTAINER)
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), ufc960))
	cd $(BASE_DIR)/flash/$(BOXTYPE) && $(SUDOCMD) ./$(BOXTYPE).sh $(MAINTAINER)
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), tf7700))
	cd $(BASE_DIR)/flash/$(BOXTYPE) && $(SUDOCMD) ./$(BOXTYPE).sh $(MAINTAINER)
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), hd51))
	$(MAKE) flash-image-hd51-multi-disk flash-image-hd51-multi-rootfs
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), hd60))
	$(MAKE) flash-image-hd60-multi-disk
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), vusolo4k))
	$(MAKE) flash-image-vusolo4k-multi-disk flash-image-vusolo4k-multi-rootfs
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), hd51))
	$(MAKE) flash-image-hd51-multi-rootfs
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), vusolo4k))
	$(MAKE) flash-image-vusolo4k-multi-rootfs
endif
ifeq ($(BOXTYPE), vuduo)
	$(MAKE) flash-image-vuduo
endif
ifeq ($(BOXTYPE), gb800se)
	$(MAKE) flash-image-gb800se
endif
ifeq ($(BOXTYPE), osnino)
	$(MAKE) flash-image-osnino
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), osmio4k))
	$(MAKE) flash-image-osmio4k-multi-disk flash-image-osmio4k-multi-rootfs
endif
	$(TUXBOX_CUSTOMIZE)

online-image: release
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), hd51))
	$(MAKE) flash-image-hd51-online
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), vusolo4k))
	$(MAKE) flash-image-vusolo4k-online
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), osmio4k))
	$(MAKE) flash-image-osmio4k-online
endif
	$(TUXBOX_CUSTOMIZE)

flash-clean:
ifeq ($(BOXARCH), sh4)
	cd $(BASE_DIR)/flash/nor_flash && $(SUDOCMD) rm -rf ./tmp ./out
	cd $(BASE_DIR)/flash/spark7162 && $(SUDOCMD) rm -rf ./tmp ./out
	cd $(BASE_DIR)/flash/atevio7500 && $(SUDOCMD) rm -rf ./tmp ./out
	cd $(BASE_DIR)/flash/ufs912 && $(SUDOCMD) rm -rf ./tmp ./out
	cd $(BASE_DIR)/flash/ufs913 && $(SUDOCMD) rm -rf ./tmp ./out
	cd $(BASE_DIR)/flash/ufc960 && $(SUDOCMD) rm -rf ./tmp ./out
	cd $(BASE_DIR)/flash/tf7700 && $(SUDOCMD) rm -rf ./tmp ./out
	echo ""
endif

# general
IMAGE_BUILD_DIR = $(BUILD_TMP)/image-build

#
# hd51
#
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), hd51))
HD51_IMAGE_NAME = disk
HD51_BOOT_IMAGE = boot.img
HD51_IMAGE_LINK = $(HD51_IMAGE_NAME).ext4
HD51_IMAGE_ROOTFS_SIZE = 294912
HD51_BOXMODE = 12
HD51_BOXMODE_MEM = brcm_cma=520M@248M brcm_cma=200M@768M

# emmc image
EMMC_IMAGE_SIZE = 3817472
EMMC_IMAGE = $(IMAGE_BUILD_DIR)/$(HD51_IMAGE_NAME).img

# partition sizes
BLOCK_SIZE = 512
BLOCK_SECTOR = 2
IMAGE_ROOTFS_ALIGNMENT = 1024
BOOT_PARTITION_SIZE = 3072
KERNEL_PARTITION_OFFSET = $(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \+ $(BOOT_PARTITION_SIZE))
KERNEL_PARTITION_SIZE = 8192
ROOTFS_PARTITION_OFFSET = $(shell expr $(KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))

# partition sizes multi
# without swap data partition 819200
ROOTFS_PARTITION_SIZE_MULTI = 768000
# 51200 * 4
SWAP_DATA_PARTITION_SIZE = 204800

SECOND_KERNEL_PARTITION_OFFSET = $(shell expr $(ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
SECOND_ROOTFS_PARTITION_OFFSET = $(shell expr $(SECOND_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))

THIRD_KERNEL_PARTITION_OFFSET = $(shell expr $(SECOND_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
THIRD_ROOTFS_PARTITION_OFFSET = $(shell expr $(THIRD_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))

FOURTH_KERNEL_PARTITION_OFFSET = $(shell expr $(THIRD_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
FOURTH_ROOTFS_PARTITION_OFFSET = $(shell expr $(FOURTH_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))

SWAP_DATA_PARTITION_OFFSET = $(shell expr $(FOURTH_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))

SWAP_PARTITION_OFFSET = $(shell expr $(SWAP_DATA_PARTITION_OFFSET) \+ $(SWAP_DATA_PARTITION_SIZE))

flash-image-hd51-multi-disk: $(D)/host_resize2fs
	rm -rf $(IMAGE_BUILD_DIR)
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
	mkdir -p $(BASE_DIR)/flash/$(BOXTYPE)
	# Create a sparse image block
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(HD51_IMAGE_LINK) seek=$(shell expr $(HD51_IMAGE_ROOTFS_SIZE) \* $(BLOCK_SECTOR)) count=0 bs=$(BLOCK_SIZE)
	$(HOST_DIR)/bin/mkfs.ext4 -F $(IMAGE_BUILD_DIR)/$(HD51_IMAGE_LINK) -d $(RELEASE_DIR)
	# Error codes 0-3 indicate successfull operation of fsck (no errors or errors corrected)
	$(HOST_DIR)/bin/fsck.ext4 -pvfD $(IMAGE_BUILD_DIR)/$(HD51_IMAGE_LINK) || [ $? -le 3 ]
	dd if=/dev/zero of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) count=0 seek=$(shell expr $(EMMC_IMAGE_SIZE) \* $(BLOCK_SECTOR))
	parted -s $(EMMC_IMAGE) mklabel gpt
	parted -s $(EMMC_IMAGE) unit KiB mkpart boot fat16 $(IMAGE_ROOTFS_ALIGNMENT) $(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \+ $(BOOT_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel1 $(KERNEL_PARTITION_OFFSET) $(shell expr $(KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs1 ext4 $(ROOTFS_PARTITION_OFFSET) $(shell expr $(ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel2 $(SECOND_KERNEL_PARTITION_OFFSET) $(shell expr $(SECOND_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs2 ext4 $(SECOND_ROOTFS_PARTITION_OFFSET) $(shell expr $(SECOND_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel3 $(THIRD_KERNEL_PARTITION_OFFSET) $(shell expr $(THIRD_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs3 ext4 $(THIRD_ROOTFS_PARTITION_OFFSET) $(shell expr $(THIRD_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel4 $(FOURTH_KERNEL_PARTITION_OFFSET) $(shell expr $(FOURTH_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs4 ext4 $(FOURTH_ROOTFS_PARTITION_OFFSET) $(shell expr $(FOURTH_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
	parted -s $(EMMC_IMAGE) unit KiB mkpart swapdata ext4 $(SWAP_DATA_PARTITION_OFFSET) $(shell expr $(SWAP_DATA_PARTITION_OFFSET) \+ $(SWAP_DATA_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart swap linux-swap $(SWAP_PARTITION_OFFSET) $(shell expr $(EMMC_IMAGE_SIZE) \- 1024)
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(HD51_BOOT_IMAGE) bs=$(BLOCK_SIZE) count=$(shell expr $(BOOT_PARTITION_SIZE) \* $(BLOCK_SECTOR))
	mkfs.msdos -S 512 $(IMAGE_BUILD_DIR)/$(HD51_BOOT_IMAGE)
	echo "boot emmcflash0.kernel1 '$(HD51_BOXMODE_MEM) root=/dev/mmcblk0p3 rw rootwait $(BOXTYPE)_4.boxmode=$(HD51_BOXMODE)'" > $(IMAGE_BUILD_DIR)/STARTUP
	echo "boot emmcflash0.kernel1 '$(HD51_BOXMODE_MEM) root=/dev/mmcblk0p3 rw rootwait $(BOXTYPE)_4.boxmode=$(HD51_BOXMODE)'" > $(IMAGE_BUILD_DIR)/STARTUP_1
	echo "boot emmcflash0.kernel2 '$(HD51_BOXMODE_MEM) root=/dev/mmcblk0p5 rw rootwait $(BOXTYPE)_4.boxmode=$(HD51_BOXMODE)'" > $(IMAGE_BUILD_DIR)/STARTUP_2
	echo "boot emmcflash0.kernel3 '$(HD51_BOXMODE_MEM) root=/dev/mmcblk0p7 rw rootwait $(BOXTYPE)_4.boxmode=$(HD51_BOXMODE)'" > $(IMAGE_BUILD_DIR)/STARTUP_3
	echo "boot emmcflash0.kernel4 '$(HD51_BOXMODE_MEM) root=/dev/mmcblk0p9 rw rootwait $(BOXTYPE)_4.boxmode=$(HD51_BOXMODE)'" > $(IMAGE_BUILD_DIR)/STARTUP_4
	mcopy -i $(IMAGE_BUILD_DIR)/$(HD51_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(HD51_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_1 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(HD51_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_2 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(HD51_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_3 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(HD51_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_4 ::
	dd conv=notrunc if=$(IMAGE_BUILD_DIR)/$(HD51_BOOT_IMAGE) of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) seek=$(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \* $(BLOCK_SECTOR))
	dd conv=notrunc if=$(RELEASE_DIR)/boot/zImage.dtb of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) seek=$(shell expr $(KERNEL_PARTITION_OFFSET) \* $(BLOCK_SECTOR))
	$(HOST_DIR)/bin/resize2fs $(IMAGE_BUILD_DIR)/$(HD51_IMAGE_LINK) $(ROOTFS_PARTITION_SIZE_MULTI)k
	# Truncate on purpose
	dd if=$(IMAGE_BUILD_DIR)/$(HD51_IMAGE_LINK) of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) seek=$(shell expr $(ROOTFS_PARTITION_OFFSET) \* $(BLOCK_SECTOR)) count=$(shell expr $(HD51_IMAGE_ROOTFS_SIZE) \* $(BLOCK_SECTOR))
	mv $(IMAGE_BUILD_DIR)/disk.img $(BASE_DIR)/flash/$(BOXTYPE)/
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-hd51-multi-rootfs:
	# Create final USB-image
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
	mkdir -p $(BASE_DIR)/flash/$(BOXTYPE)
	cp $(RELEASE_DIR)/boot/zImage.dtb $(IMAGE_BUILD_DIR)/$(BOXTYPE)/kernel.bin
	cd $(RELEASE_DIR); \
	tar -cvf $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar --exclude=zImage* . > /dev/null 2>&1; \
	bzip2 $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar
	echo $(BOXTYPE)_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/imageversion
	cd $(IMAGE_BUILD_DIR) && \
	zip -r $(BASE_DIR)/flash/$(BOXTYPE)/$(BOXTYPE)_multi_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(BOXTYPE)/rootfs.tar.bz2 $(BOXTYPE)/kernel.bin $(BOXTYPE)/disk.img $(BOXTYPE)/imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-hd51-online:
	# Create final USB-image
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
	mkdir -p $(BASE_DIR)/flash/$(BOXTYPE)
	cp $(RELEASE_DIR)/boot/zImage.dtb $(IMAGE_BUILD_DIR)/$(BOXTYPE)/kernel.bin
	cd $(RELEASE_DIR); \
	tar -cvf $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar --exclude=zImage* . > /dev/null 2>&1; \
	bzip2 $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar
	echo $(BOXTYPE)_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/imageversion
	cd $(IMAGE_BUILD_DIR)/$(BOXTYPE) && \
	tar -cvzf $(BASE_DIR)/flash/$(BOXTYPE)/$(BOXTYPE)_multi_usb_$(shell date '+%d.%m.%Y-%H.%M').tgz rootfs.tar.bz2 kernel.bin imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)
endif

#
# hd60
#
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), hd60))
HD60_IMAGE_NAME = disk
HD60_BOOT_IMAGE = bootoptions.img
HD60_IMAGE_LINK = $(HD60_IMAGE_NAME).ext4

HD60_BOOTOPTIONS_PARTITION_SIZE = 4096
HD60_IMAGE_ROOTFS_SIZE = 1048576

HD60_SRCDATE = 20180912
HD60_BOOTARGS_SRC = $(BOXTYPE)-bootargs-$(HD60_SRCDATE).zip
HD60_PARTITONS_SRC = $(BOXTYPE)-partitions-$(HD60_SRCDATE).zip

BLOCK_SIZE = 512
BLOCK_SECTOR = 2

$(ARCHIVE)/$(HD60_BOOTARGS_SRC):
	$(WGET) http://source.mynonpublic.com/gfutures/$(HD60_BOOTARGS_SRC)

$(ARCHIVE)/$(HD60_PARTITONS_SRC):
	$(WGET) http://source.mynonpublic.com/gfutures/$(HD60_PARTITONS_SRC)

flash-image-hd60-multi-disk: $(ARCHIVE)/$(HD60_BOOTARGS_SRC) $(ARCHIVE)/$(HD60_PARTITONS_SRC)
	# Create image
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
	mkdir -p $(BASE_DIR)/flash/$(BOXTYPE)
	unzip -o $(ARCHIVE)/$(HD60_BOOTARGS_SRC) -d $(IMAGE_BUILD_DIR)
	unzip -o $(ARCHIVE)/$(HD60_PARTITONS_SRC) -d $(IMAGE_BUILD_DIR)
	echo $(BOXTYPE)_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/imageversion
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(HD60_IMAGE_LINK) seek=$(shell expr $(HD60_IMAGE_ROOTFS_SIZE) \* $(BLOCK_SECTOR)) count=0 bs=$(BLOCK_SIZE)
	$(HOST_DIR)/bin/mkfs.ext4 -F $(IMAGE_BUILD_DIR)/$(HD60_IMAGE_LINK) -d $(RELEASE_DIR)
	# Error codes 0-3 indicate successfull operation of fsck (no errors or errors corrected)
	$(HOST_DIR)/bin/fsck.ext4 -pvfD $(IMAGE_BUILD_DIR)/$(HD60_IMAGE_LINK) || [ $? -le 3 ]
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(HD60_BOOT_IMAGE) bs=1024 count=$(HD60_BOOTOPTIONS_PARTITION_SIZE)
	mkfs.msdos -S 512 $(IMAGE_BUILD_DIR)/$(HD60_BOOT_IMAGE)
	echo "bootcmd=mmc read 0 0x1000000 0x53D000 0x8000; bootm 0x1000000 bootargs=console=ttyAMA0,115200 root=/dev/mmcblk0p21 rootfstype=ext4" > $(IMAGE_BUILD_DIR)/STARTUP
	echo "bootcmd=mmc read 0 0x3F000000 0x70000 0x4000; bootm 0x3F000000; mmc read 0 0x1FFBFC0 0x52000 0xC800; bootargs=androidboot.selinux=enforcing androidboot.serialno=0123456789 console=ttyAMA0,115200" > $(IMAGE_BUILD_DIR)/STARTUP_RED
	echo "bootcmd=mmc read 0 0x1000000 0x53D000 0x8000; bootm 0x1000000 bootargs=console=ttyAMA0,115200 root=/dev/mmcblk0p21 rootfstype=ext4" > $(IMAGE_BUILD_DIR)/STARTUP_GREEN
	echo "bootcmd=mmc read 0 0x1000000 0x53D000 0x8000; bootm 0x1000000 bootargs=console=ttyAMA0,115200 root=/dev/mmcblk0p21 rootfstype=ext4" > $(IMAGE_BUILD_DIR)/STARTUP_YELLOW
	echo "bootcmd=mmc read 0 0x1000000 0x53D000 0x8000; bootm 0x1000000 bootargs=console=ttyAMA0,115200 root=/dev/mmcblk0p21 rootfstype=ext4" > $(IMAGE_BUILD_DIR)/STARTUP_BLUE
	mcopy -i $(IMAGE_BUILD_DIR)/$(HD60_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(HD60_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_RED ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(HD60_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_GREEN ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(HD60_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_YELLOW ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(HD60_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_BLUE ::
	cp $(IMAGE_BUILD_DIR)/$(HD60_BOOT_IMAGE) $(IMAGE_BUILD_DIR)/$(BOXTYPE)/$(HD60_BOOT_IMAGE)
	ext2simg -zv $(IMAGE_BUILD_DIR)/$(HD60_IMAGE_LINK) $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.fastboot.gz
	mv $(IMAGE_BUILD_DIR)/bootargs-8gb.bin $(IMAGE_BUILD_DIR)/bootargs.bin
	mv $(IMAGE_BUILD_DIR)/$(BOXTYPE)/bootargs-8gb.bin $(IMAGE_BUILD_DIR)/$(BOXTYPE)/bootargs.bin
	cp $(RELEASE_DIR)/boot/uImage $(IMAGE_BUILD_DIR)/$(BOXTYPE)/uImage
	cd $(IMAGE_BUILD_DIR) && \
	zip -r $(BASE_DIR)/flash/$(BOXTYPE)/$(BOXTYPE)_multi_usb_$(shell date '+%d.%m.%Y-%H.%M').zip *
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)
endif

#
# vusolo4k
#
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), vusolo4k))
VUSOLO4K_IMAGE_NAME = disk
VUSOLO4K_BOOT_IMAGE = boot.img
VUSOLO4K_IMAGE_LINK = $(VUSOLO4K_IMAGE_NAME).ext4
VUSOLO4K_IMAGE_ROOTFS_SIZE = 294912
VUSOLO4K_PREFIX = vuplus/solo4k

# emmc image
EMMC_IMAGE_SIZE = 3817472
EMMC_IMAGE = $(IMAGE_BUILD_DIR)/$(VUSOLO4K_IMAGE_NAME).img

# partition sizes
BLOCK_SIZE = 512
BLOCK_SECTOR = 2
IMAGE_ROOTFS_ALIGNMENT = 1024
BOOT_PARTITION_SIZE = 3072
KERNEL_PARTITION_OFFSET = $(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \+ $(BOOT_PARTITION_SIZE))
KERNEL_PARTITION_SIZE = 8192
ROOTFS_PARTITION_OFFSET = $(shell expr $(KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))

# partition sizes multi
# without swap data partition 819200
ROOTFS_PARTITION_SIZE_MULTI = 768000
# 51200 * 4
SWAP_DATA_PARTITION_SIZE = 204800

SECOND_KERNEL_PARTITION_OFFSET = $(shell expr $(ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
SECOND_ROOTFS_PARTITION_OFFSET = $(shell expr $(SECOND_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))

THIRD_KERNEL_PARTITION_OFFSET = $(shell expr $(SECOND_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
THIRD_ROOTFS_PARTITION_OFFSET = $(shell expr $(THIRD_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))

FOURTH_KERNEL_PARTITION_OFFSET = $(shell expr $(THIRD_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
FOURTH_ROOTFS_PARTITION_OFFSET = $(shell expr $(FOURTH_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))

SWAP_DATA_PARTITION_OFFSET = $(shell expr $(FOURTH_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))

SWAP_PARTITION_OFFSET = $(shell expr $(SWAP_DATA_PARTITION_OFFSET) \+ $(SWAP_DATA_PARTITION_SIZE))

flash-image-vusolo4k-multi-disk: $(D)/host_resize2fs
	rm -rf $(IMAGE_BUILD_DIR)
	mkdir -p $(IMAGE_BUILD_DIR)/$(VUSOLO4K_PREFIX)
	mkdir -p $(BASE_DIR)/flash/$(BOXTYPE)
	# Create a sparse image block
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(VUSOLO4K_IMAGE_LINK) seek=$(shell expr $(VUSOLO4K_IMAGE_ROOTFS_SIZE) \* $(BLOCK_SECTOR)) count=0 bs=$(BLOCK_SIZE)
	$(HOST_DIR)/bin/mkfs.ext4 -F $(IMAGE_BUILD_DIR)/$(VUSOLO4K_IMAGE_LINK) -d $(RELEASE_DIR)
	# Error codes 0-3 indicate successfull operation of fsck (no errors or errors corrected)
	$(HOST_DIR)/bin/fsck.ext4 -pvfD $(IMAGE_BUILD_DIR)/$(VUSOLO4K_IMAGE_LINK) || [ $? -le 3 ]
	dd if=/dev/zero of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) count=0 seek=$(shell expr $(EMMC_IMAGE_SIZE) \* $(BLOCK_SECTOR))
	parted -s $(EMMC_IMAGE) mklabel gpt
	parted -s $(EMMC_IMAGE) unit KiB mkpart boot fat16 $(IMAGE_ROOTFS_ALIGNMENT) $(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \+ $(BOOT_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel1 $(KERNEL_PARTITION_OFFSET) $(shell expr $(KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs1 ext4 $(ROOTFS_PARTITION_OFFSET) $(shell expr $(ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel2 $(SECOND_KERNEL_PARTITION_OFFSET) $(shell expr $(SECOND_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs2 ext4 $(SECOND_ROOTFS_PARTITION_OFFSET) $(shell expr $(SECOND_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel3 $(THIRD_KERNEL_PARTITION_OFFSET) $(shell expr $(THIRD_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs3 ext4 $(THIRD_ROOTFS_PARTITION_OFFSET) $(shell expr $(THIRD_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel4 $(FOURTH_KERNEL_PARTITION_OFFSET) $(shell expr $(FOURTH_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs4 ext4 $(FOURTH_ROOTFS_PARTITION_OFFSET) $(shell expr $(FOURTH_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
	parted -s $(EMMC_IMAGE) unit KiB mkpart swapdata ext4 $(SWAP_DATA_PARTITION_OFFSET) $(shell expr $(SWAP_DATA_PARTITION_OFFSET) \+ $(SWAP_DATA_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart swap linux-swap $(SWAP_PARTITION_OFFSET) $(shell expr $(EMMC_IMAGE_SIZE) \- 1024)
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(VUSOLO4K_BOOT_IMAGE) bs=$(BLOCK_SIZE) count=$(shell expr $(BOOT_PARTITION_SIZE) \* $(BLOCK_SECTOR))
	mkfs.msdos -S 512 $(IMAGE_BUILD_DIR)/$(VUSOLO4K_BOOT_IMAGE)
	dd conv=notrunc if=$(IMAGE_BUILD_DIR)/$(VUSOLO4K_BOOT_IMAGE) of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) seek=$(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \* $(BLOCK_SECTOR))
	#dd conv=notrunc if=$(RELEASE_DIR)/boot/zImage.dtb of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) seek=$(shell expr $(KERNEL_PARTITION_OFFSET) \* $(BLOCK_SECTOR))
	$(HOST_DIR)/bin/resize2fs $(IMAGE_BUILD_DIR)/$(VUSOLO4K_IMAGE_LINK) $(ROOTFS_PARTITION_SIZE_MULTI)k
	# Truncate on purpose
	dd if=$(IMAGE_BUILD_DIR)/$(VUSOLO4K_IMAGE_LINK) of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) seek=$(shell expr $(ROOTFS_PARTITION_OFFSET) \* $(BLOCK_SECTOR)) count=$(shell expr $(VUSOLO4K_IMAGE_ROOTFS_SIZE) \* $(BLOCK_SECTOR))
	mv $(IMAGE_BUILD_DIR)/disk.img $(BASE_DIR)/flash/$(BOXTYPE)/
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-vusolo4k-multi-rootfs:
	# Create final USB-image
	mkdir -p $(IMAGE_BUILD_DIR)/$(VUSOLO4K_PREFIX)
	mkdir -p $(BASE_DIR)/flash/$(BOXTYPE)
	cp $(RELEASE_DIR)/boot/vmlinuz-initrd-7366c0 $(IMAGE_BUILD_DIR)/$(VUSOLO4K_PREFIX)/initrd_auto.bin
	cp $(RELEASE_DIR)/boot/zImage $(IMAGE_BUILD_DIR)/$(VUSOLO4K_PREFIX)/kernel_auto.bin
	cd $(RELEASE_DIR); \
	tar -cvf $(IMAGE_BUILD_DIR)/$(VUSOLO4K_PREFIX)/rootfs.tar --exclude=zImage* --exclude=vmlinuz-initrd* . > /dev/null 2>&1; \
	bzip2 $(IMAGE_BUILD_DIR)/$(VUSOLO4K_PREFIX)/rootfs.tar
	echo This file forces a reboot after the update. > $(IMAGE_BUILD_DIR)/$(VUSOLO4K_PREFIX)/reboot.update
	echo $(BOXTYPE)_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(VUSOLO4K_PREFIX)/imageversion
	cd $(IMAGE_BUILD_DIR) && \
	zip -r $(BASE_DIR)/flash/$(BOXTYPE)/$(BOXTYPE)_multi_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(VUSOLO4K_PREFIX)/rootfs.tar.bz2 $(VUSOLO4K_PREFIX)/initrd_auto.bin $(VUSOLO4K_PREFIX)/kernel_auto.bin $(VUSOLO4K_PREFIX)/reboot.update $(VUSOLO4K_PREFIX)/imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-vusolo4k-online:
	# Create final USB-image
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
	mkdir -p $(BASE_DIR)/flash/$(BOXTYPE)
	cp $(RELEASE_DIR)/boot/vmlinuz-initrd-7366c0 $(IMAGE_BUILD_DIR)/$(BOXTYPE)/initrd_auto.bin
	cp $(RELEASE_DIR)/boot/zImage $(IMAGE_BUILD_DIR)/$(BOXTYPE)/kernel_auto.bin
	cd $(RELEASE_DIR); \
	tar -cvf $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar --exclude=zImage* --exclude=vmlinuz-initrd* . > /dev/null 2>&1; \
	bzip2 $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar
	echo This file forces a reboot after the update. > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/reboot.update
	echo $(BOXTYPE)_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/imageversion
	cd $(IMAGE_BUILD_DIR)/$(BOXTYPE) && \
	tar -cvzf $(BASE_DIR)/flash/$(BOXTYPE)/$(BOXTYPE)_multi_usb_$(shell date '+%d.%m.%Y-%H.%M').tgz rootfs.tar.bz2 initrd_auto.bin kernel_auto.bin reboot.update imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)
endif

#
# vuduo
#
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), vuduo))
VUDUO_PREFIX = vuplus/duo

flash-image-vuduo:
	# Create final USB-image
	mkdir -p $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)
	mkdir -p $(BASE_DIR)/flash/$(BOXTYPE)
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
	zip -r $(BASE_DIR)/flash/$(BOXTYPE)/$(BOXTYPE)_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(VUDUO_PREFIX)*
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)
endif

#
# gb800se
#
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), gb800se))
GB800SE_PREFIX = gigablue/se

flash-image-gb800se:
	# Create final USB-image
	mkdir -p $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)
	mkdir -p $(BASE_DIR)/flash/$(BOXTYPE)
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
	zip -r $(BASE_DIR)/flash/$(BOXTYPE)/$(BOXTYPE)_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(GB800SE_PREFIX)*
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)
endif

#
# osnino
#
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), osnino))
OSNINO_PREFIX = edision/osnino

flash-image-osnino:
	# Create final USB-image
	mkdir -p $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)
	mkdir -p $(BASE_DIR)/flash/$(BOXTYPE)
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
	rm -f $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/root.ubi
	rm -f $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/ubinize.cfg
	echo $(BOXTYPE)_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/imageversion
	cd $(IMAGE_BUILD_DIR)/ && \
	zip -r $(BASE_DIR)/flash/$(BOXTYPE)/$(BOXTYPE)_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(OSNINO_PREFIX)*
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)
endif

#
# osmio4k
#
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), osmio4k))
FLASH_BUILD_TMP = $(BUILD_TMP)/image-build
IMAGE_BUILD_DIR = $(BUILD_TMP)/image-build

IMAGE_NAME = emmc
IMAGE_LINK = $(IMAGE_NAME).ext4

# emmc image
EMMC_IMAGE = $(IMAGE_BUILD_DIR)/$(IMAGE_NAME).img
EMMC_IMAGE_SIZE = 7634944

# partition offsets/sizes
IMAGE_ROOTFS_ALIGNMENT = 1024
BOOT_PARTITION_SIZE    = 3072
KERNEL_PARTITION_SIZE  = 8192
ROOTFS_PARTITION_SIZE  = 1767424

KERNEL1_PARTITION_OFFSET = $(shell expr $(IMAGE_ROOTFS_ALIGNMENT)   + $(BOOT_PARTITION_SIZE))
ROOTFS1_PARTITION_OFFSET = $(shell expr $(KERNEL1_PARTITION_OFFSET) + $(KERNEL_PARTITION_SIZE))

KERNEL2_PARTITION_OFFSET = $(shell expr $(ROOTFS1_PARTITION_OFFSET) + $(ROOTFS_PARTITION_SIZE))
ROOTFS2_PARTITION_OFFSET = $(shell expr $(KERNEL2_PARTITION_OFFSET) + $(KERNEL_PARTITION_SIZE))

KERNEL3_PARTITION_OFFSET = $(shell expr $(ROOTFS2_PARTITION_OFFSET) + $(ROOTFS_PARTITION_SIZE))
ROOTFS3_PARTITION_OFFSET = $(shell expr $(KERNEL3_PARTITION_OFFSET) + $(KERNEL_PARTITION_SIZE))

KERNEL4_PARTITION_OFFSET = $(shell expr $(ROOTFS3_PARTITION_OFFSET) + $(ROOTFS_PARTITION_SIZE))
ROOTFS4_PARTITION_OFFSET = $(shell expr $(KERNEL4_PARTITION_OFFSET) + $(KERNEL_PARTITION_SIZE))

SWAP_PARTITION_OFFSET = $(shell expr $(ROOTFS4_PARTITION_OFFSET) + $(ROOTFS_PARTITION_SIZE))

flash-image-osmio4k-multi-disk:
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
	# Create a sparse image block
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(IMAGE_LINK) seek=$(shell expr $(EMMC_IMAGE_SIZE) \* 1024) count=0 bs=1
	$(HOST_DIR)/bin/mkfs.ext4 -F -m0 $(IMAGE_BUILD_DIR)/$(IMAGE_LINK) -d $(RELEASE_DIR)
	# Error codes 0-3 indicate successfull operation of fsck (no errors or errors corrected)
	$(HOST_DIR)/bin/fsck.ext4 -pfD $(IMAGE_BUILD_DIR)/$(IMAGE_LINK) || [ $? -le 3 ]
	dd if=/dev/zero of=$(EMMC_IMAGE) bs=1 count=0 seek=$(shell expr $(EMMC_IMAGE_SIZE) \* 1024)
	parted -s $(EMMC_IMAGE) mklabel gpt
	parted -s $(EMMC_IMAGE) unit KiB mkpart boot fat16 $(IMAGE_ROOTFS_ALIGNMENT) $(shell expr $(IMAGE_ROOTFS_ALIGNMENT) + $(BOOT_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) set 1 boot on
	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel1 $(KERNEL1_PARTITION_OFFSET) $(shell expr $(KERNEL1_PARTITION_OFFSET) + $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs1 ext4 $(ROOTFS1_PARTITION_OFFSET) $(shell expr $(ROOTFS1_PARTITION_OFFSET) + $(ROOTFS_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel2 $(KERNEL2_PARTITION_OFFSET) $(shell expr $(KERNEL2_PARTITION_OFFSET) + $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs2 ext4 $(ROOTFS2_PARTITION_OFFSET) $(shell expr $(ROOTFS2_PARTITION_OFFSET) + $(ROOTFS_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel3 $(KERNEL3_PARTITION_OFFSET) $(shell expr $(KERNEL3_PARTITION_OFFSET) + $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs3 ext4 $(ROOTFS3_PARTITION_OFFSET) $(shell expr $(ROOTFS3_PARTITION_OFFSET) + $(ROOTFS_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel4 $(KERNEL4_PARTITION_OFFSET) $(shell expr $(KERNEL4_PARTITION_OFFSET) + $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs4 ext4 $(ROOTFS4_PARTITION_OFFSET) $(shell expr $(ROOTFS4_PARTITION_OFFSET) + $(ROOTFS_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart swap linux-swap $(SWAP_PARTITION_OFFSET) 100%
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/boot.img bs=1024 count=$(BOOT_PARTITION_SIZE)
	mkfs.msdos -n boot -S 512 $(IMAGE_BUILD_DIR)/boot.img
	echo "setenv STARTUP \"boot emmcflash0.kernel1 'root=/dev/mmcblk1p3 rootfstype=ext4 rw rootwait'\"" > $(IMAGE_BUILD_DIR)/STARTUP
	echo "setenv STARTUP \"boot emmcflash0.kernel1 'root=/dev/mmcblk1p3 rootfstype=ext4 rw rootwait'\"" > $(IMAGE_BUILD_DIR)/STARTUP_1
	echo "setenv STARTUP \"boot emmcflash0.kernel2 'root=/dev/mmcblk1p5 rootfstype=ext4 rw rootwait'\"" > $(IMAGE_BUILD_DIR)/STARTUP_2
	echo "setenv STARTUP \"boot emmcflash0.kernel3 'root=/dev/mmcblk1p7 rootfstype=ext4 rw rootwait'\"" > $(IMAGE_BUILD_DIR)/STARTUP_3
	echo "setenv STARTUP \"boot emmcflash0.kernel4 'root=/dev/mmcblk1p9 rootfstype=ext4 rw rootwait'\"" > $(IMAGE_BUILD_DIR)/STARTUP_4
	mcopy -i $(IMAGE_BUILD_DIR)/boot.img -v $(IMAGE_BUILD_DIR)/STARTUP ::
	mcopy -i $(IMAGE_BUILD_DIR)/boot.img -v $(IMAGE_BUILD_DIR)/STARTUP_1 ::
	mcopy -i $(IMAGE_BUILD_DIR)/boot.img -v $(IMAGE_BUILD_DIR)/STARTUP_2 ::
	mcopy -i $(IMAGE_BUILD_DIR)/boot.img -v $(IMAGE_BUILD_DIR)/STARTUP_3 ::
	mcopy -i $(IMAGE_BUILD_DIR)/boot.img -v $(IMAGE_BUILD_DIR)/STARTUP_4 ::
	parted -s $(EMMC_IMAGE) unit KiB print
	dd conv=notrunc if=$(IMAGE_BUILD_DIR)/boot.img of=$(EMMC_IMAGE) seek=1 bs=$(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \* 1024)
	dd conv=notrunc if=$(TARGET_DIR)/boot/zImage of=$(EMMC_IMAGE) seek=1 bs=$(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \* 1024 + $(BOOT_PARTITION_SIZE) \* 1024)
	$(HOST_DIR)/bin/resize2fs $(IMAGE_BUILD_DIR)/$(IMAGE_LINK) $(ROOTFS_PARTITION_SIZE)k
	# Truncate on purpose
	dd if=$(IMAGE_BUILD_DIR)/$(IMAGE_LINK) of=$(EMMC_IMAGE) seek=1 bs=$(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \* 1024 + $(BOOT_PARTITION_SIZE) \* 1024 + $(KERNEL_PARTITION_SIZE) \* 1024)
	mv $(EMMC_IMAGE) $(IMAGE_BUILD_DIR)/$(BOXTYPE)/

flash-image-osmio4k-multi-rootfs:
	# Create final USB-image
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
	mkdir -p $(BASE_DIR)/flash/$(BOXTYPE)
	cp $(TARGET_DIR)/boot/zImage $(IMAGE_BUILD_DIR)/$(BOXTYPE)/kernel.bin
	cd $(RELEASE_DIR) && \
	tar -cvf $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar . >/dev/null 2>&1; \
	bzip2 $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar
	echo $(BOXTYPE)_DDT_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/imageversion
	echo "rename this file to 'force' to force an update without confirmation" > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/noforce; \
	cd $(IMAGE_BUILD_DIR) && \
	zip -r $(BASE_DIR)/flash/$(BOXTYPE)/$(BOXTYPE)_multi_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(BOXTYPE)/rootfs.tar.bz2 $(BOXTYPE)/kernel.bin $(BOXTYPE)/$(IMAGE_NAME).img $(BOXTYPE)/imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-osmio4k-online:
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
	cp $(TARGET_DIR)/boot/zImage $(IMAGE_BUILD_DIR)/$(BOXTYPE)/kernel.bin
	cd $(RELEASE_DIR) && \
	tar -cvf $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar . >/dev/null 2>&1; \
	bzip2 $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar
	echo $(BOXTYPE)_DDT_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/imageversion
	echo "rename this file to 'force' to force an update without confirmation" > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/noforce; \
	cd $(IMAGE_BUILD_DIR)/$(BOXTYPE) && \
	tar -cvzf $(BASE_DIR)/flash/$(BOXTYPE)/$(BOXTYPE)_multi_usb_$(shell date '+%d.%m.%Y-%H.%M').tgz rootfs.tar.bz2 kernel.bin imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)
endif


