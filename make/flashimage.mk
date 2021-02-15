#
# flashimage
#

flashimage: release
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), fortis_hdbox octagon1008 ufs910 ufs922 ipbox55 ipbox99 ipbox9900 cuberevo cuberevo_mini cuberevo_mini2 cuberevo_250hd cuberevo_2000hd cuberevo_3000hd))
	cd $(FLASH_DIR)/nor_flash && $(SUDOCMD) ./make_flash.sh $(MAINTAINER) $(BOXTYPE)
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), spark spark7162))
	cd $(FLASH_DIR)/$(BOXTYPE) && $(SUDOCMD) ./$(BOXTYPE).sh $(MAINTAINER) $(BOXTYPE)
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), atevio7500))
	cd $(FLASH_DIR)/$(BOXTYPE) && $(SUDOCMD) ./$(BOXTYPE).sh $(MAINTAINER)
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), ufs912))
	cd $(FLASH_DIR)/$(BOXTYPE) && $(SUDOCMD) ./$(BOXTYPE).sh $(MAINTAINER)
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), ufs913))
	cd $(FLASH_DIR)/$(BOXTYPE) && $(SUDOCMD) ./$(BOXTYPE).sh $(MAINTAINER)
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), tf7700))
	cd $(FLASH_DIR)/$(BOXTYPE) && $(SUDOCMD) ./$(BOXTYPE).sh $(MAINTAINER)
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
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), vusolo4k))
	$(MAKE) flash-image-vusolo4k-multi-rootfs
endif
ifeq ($(BOXTYPE), vuduo)
	$(MAKE) flash-image-vuduo
endif
ifeq ($(BOXTYPE), gb800se)
	$(MAKE) flash-image-gb800se
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), osnino osninoplus osninopro))
	$(MAKE) flash-image-$(BOXTYPE)
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), osmio4k osmio4kplus osmini4k))
	$(MAKE) flash-image-$(BOXTYPE)-multi-disk flash-image-$(BOXTYPE)-multi-rootfs
endif
ifeq ($(BOXTYPE), bre2ze4k)
	$(MAKE) flash-image-bre2ze4k-multi-disk flash-image-bre2ze4k-multi-rootfs
endif
ifeq ($(BOXTYPE), h7)
	$(MAKE) flash-image-h7-multi-disk flash-image-h7-multi-rootfs
endif
ifeq ($(BOXTYPE), hd61)
	$(MAKE) flash-image-hd61-multi-disk flash-image-hd61-multi-rootfs
endif
ifeq ($(BOXTYPE), vuduo2)
	$(MAKE) flash-image-vuduo2
endif
ifeq ($(BOXTYPE), vuduo4k)
	$(MAKE) flash-image-vuduo4k-multi-rootfs
endif
ifeq ($(BOXTYPE), vuultimo4k)
	$(MAKE) flash-image-vuultimo4k-multi-rootfs
endif
ifeq ($(BOXTYPE), vuuno4k)
	$(MAKE) flash-image-vuuno4k-multi-rootfs
endif
ifeq ($(BOXTYPE), vuuno4kse)
	$(MAKE) flash-image-vuuno4kse-multi-rootfs
endif
ifeq ($(BOXTYPE), vuzero4k)
	$(MAKE) flash-image-vuzero4k-multi-rootfs
endif
	$(TUXBOX_CUSTOMIZE)

online-image: release
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), hd51))
	$(MAKE) flash-image-hd51-online
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), vusolo4k))
	$(MAKE) flash-image-vusolo4k-online
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), osmio4k osmio4kplus osmini4k))
	$(MAKE) flash-image-$(BOXTYPE)-online
endif
ifeq ($(BOXTYPE), bre2ze4k)
	$(MAKE) flash-image-bre2ze4k-online
endif
ifeq ($(BOXTYPE), h7)
	$(MAKE) flash-image-h7-online
endif
ifeq ($(BOXTYPE), hd61)
	$(MAKE) flash-image-hd61-online
endif
ifeq ($(BOXTYPE), vuduo4k)
	$(MAKE) flash-image-vuduo4k-online
endif
ifeq ($(BOXTYPE), vuultimo4k)
	$(MAKE) flash-image-vuultimo4k-online
endif
ifeq ($(BOXTYPE), vuuno4k)
	$(MAKE) flash-image-vuuno4k-online
endif
ifeq ($(BOXTYPE), vuuno4kse)
	$(MAKE) flash-image-vuuno4kse-online
endif
ifeq ($(BOXTYPE), vuzero4k)
	$(MAKE) flash-image-vuzero4k-online
endif
	$(TUXBOX_CUSTOMIZE)

flash-clean:
ifeq ($(BOXARCH), sh4)
	cd $(FLASH_DIR)/nor_flash && $(SUDOCMD) rm -rf ./tmp ./out
	cd $(FLASH_DIR)/spark7162 && $(SUDOCMD) rm -rf ./tmp ./out
	cd $(FLASH_DIR)/atevio7500 && $(SUDOCMD) rm -rf ./tmp ./out
	cd $(FLASH_DIR)/ufs912 && $(SUDOCMD) rm -rf ./tmp ./out
	cd $(FLASH_DIR)/ufs913 && $(SUDOCMD) rm -rf ./tmp ./out
	cd $(FLASH_DIR)/tf7700 && $(SUDOCMD) rm -rf ./tmp ./out
else
	cd $(FLASH_DIR)/$(BOXTYPE) && rm -rf *.*
endif

# general
#IMAGE_BUILD_DIR = $(BUILD_TMP)/image-build

#
# hd51
#
#ifeq ($(BOXTYPE), $(filter $(BOXTYPE), hd51))
#HD51_IMAGE_NAME = disk
#HD51_BOOT_IMAGE = boot.img
#HD51_IMAGE_LINK = $(HD51_IMAGE_NAME).ext4
#HD51_IMAGE_ROOTFS_SIZE = 294912
#HD51_BOXMODE = 12
#HD51_BOXMODE_MEM = brcm_cma=520M@248M brcm_cma=200M@768M

# emmc image
#EMMC_IMAGE_SIZE = 3817472
#EMMC_IMAGE = $(IMAGE_BUILD_DIR)/$(HD51_IMAGE_NAME).img

# partition sizes
#BLOCK_SIZE = 512
#BLOCK_SECTOR = 2
#IMAGE_ROOTFS_ALIGNMENT = 1024
#BOOT_PARTITION_SIZE = 3072
#KERNEL_PARTITION_OFFSET = $(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \+ $(BOOT_PARTITION_SIZE))
#KERNEL_PARTITION_SIZE = 8192
#ROOTFS_PARTITION_OFFSET = $(shell expr $(KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))

# partition sizes multi
# without swap data partition 819200
#ROOTFS_PARTITION_SIZE_MULTI = 768000
# 51200 * 4
#SWAP_DATA_PARTITION_SIZE = 204800

#SECOND_KERNEL_PARTITION_OFFSET = $(shell expr $(ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
#SECOND_ROOTFS_PARTITION_OFFSET = $(shell expr $(SECOND_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))

#THIRD_KERNEL_PARTITION_OFFSET = $(shell expr $(SECOND_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
#THIRD_ROOTFS_PARTITION_OFFSET = $(shell expr $(THIRD_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))

#FOURTH_KERNEL_PARTITION_OFFSET = $(shell expr $(THIRD_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
#FOURTH_ROOTFS_PARTITION_OFFSET = $(shell expr $(FOURTH_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))

#SWAP_DATA_PARTITION_OFFSET = $(shell expr $(FOURTH_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))

#SWAP_PARTITION_OFFSET = $(shell expr $(SWAP_DATA_PARTITION_OFFSET) \+ $(SWAP_DATA_PARTITION_SIZE))

#flash-image-hd51-multi-disk: $(D)/host_resize2fs
#	rm -rf $(IMAGE_BUILD_DIR)
#	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
#	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
	# Create a sparse image block
#	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(HD51_IMAGE_LINK) seek=$(shell expr $(HD51_IMAGE_ROOTFS_SIZE) \* $(BLOCK_SECTOR)) count=0 bs=$(BLOCK_SIZE)
#	$(HOST_DIR)/bin/mkfs.ext4 -F $(IMAGE_BUILD_DIR)/$(HD51_IMAGE_LINK) -d $(RELEASE_DIR)
	# Error codes 0-3 indicate successfull operation of fsck (no errors or errors corrected)
#	$(HOST_DIR)/bin/fsck.ext4 -pvfD $(IMAGE_BUILD_DIR)/$(HD51_IMAGE_LINK) || [ $? -le 3 ]
#	dd if=/dev/zero of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) count=0 seek=$(shell expr $(EMMC_IMAGE_SIZE) \* $(BLOCK_SECTOR))
#	parted -s $(EMMC_IMAGE) mklabel gpt
#	parted -s $(EMMC_IMAGE) unit KiB mkpart boot fat16 $(IMAGE_ROOTFS_ALIGNMENT) $(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \+ $(BOOT_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel1 $(KERNEL_PARTITION_OFFSET) $(shell expr $(KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs1 ext4 $(ROOTFS_PARTITION_OFFSET) $(shell expr $(ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel2 $(SECOND_KERNEL_PARTITION_OFFSET) $(shell expr $(SECOND_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs2 ext4 $(SECOND_ROOTFS_PARTITION_OFFSET) $(shell expr $(SECOND_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel3 $(THIRD_KERNEL_PARTITION_OFFSET) $(shell expr $(THIRD_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs3 ext4 $(THIRD_ROOTFS_PARTITION_OFFSET) $(shell expr $(THIRD_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel4 $(FOURTH_KERNEL_PARTITION_OFFSET) $(shell expr $(FOURTH_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs4 ext4 $(FOURTH_ROOTFS_PARTITION_OFFSET) $(shell expr $(FOURTH_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_MULTI))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart swapdata ext4 $(SWAP_DATA_PARTITION_OFFSET) $(shell expr $(SWAP_DATA_PARTITION_OFFSET) \+ $(SWAP_DATA_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart swap linux-swap $(SWAP_PARTITION_OFFSET) $(shell expr $(EMMC_IMAGE_SIZE) \- 1024)
#	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(HD51_BOOT_IMAGE) bs=$(BLOCK_SIZE) count=$(shell expr $(BOOT_PARTITION_SIZE) \* $(BLOCK_SECTOR))
#	mkfs.msdos -S 512 $(IMAGE_BUILD_DIR)/$(HD51_BOOT_IMAGE)
#	echo "boot emmcflash0.kernel1 '$(HD51_BOXMODE_MEM) root=/dev/mmcblk0p3 rw rootwait $(BOXTYPE)_4.boxmode=$(HD51_BOXMODE)'" > $(IMAGE_BUILD_DIR)/STARTUP
#	echo "boot emmcflash0.kernel1 '$(HD51_BOXMODE_MEM) root=/dev/mmcblk0p3 rw rootwait $(BOXTYPE)_4.boxmode=$(HD51_BOXMODE)'" > $(IMAGE_BUILD_DIR)/STARTUP_1
#	echo "boot emmcflash0.kernel2 '$(HD51_BOXMODE_MEM) root=/dev/mmcblk0p5 rw rootwait $(BOXTYPE)_4.boxmode=$(HD51_BOXMODE)'" > $(IMAGE_BUILD_DIR)/STARTUP_2
#	echo "boot emmcflash0.kernel3 '$(HD51_BOXMODE_MEM) root=/dev/mmcblk0p7 rw rootwait $(BOXTYPE)_4.boxmode=$(HD51_BOXMODE)'" > $(IMAGE_BUILD_DIR)/STARTUP_3
#	echo "boot emmcflash0.kernel4 '$(HD51_BOXMODE_MEM) root=/dev/mmcblk0p9 rw rootwait $(BOXTYPE)_4.boxmode=$(HD51_BOXMODE)'" > $(IMAGE_BUILD_DIR)/STARTUP_4
#	mcopy -i $(IMAGE_BUILD_DIR)/$(HD51_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP ::
#	mcopy -i $(IMAGE_BUILD_DIR)/$(HD51_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_1 ::
#	mcopy -i $(IMAGE_BUILD_DIR)/$(HD51_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_2 ::
#	mcopy -i $(IMAGE_BUILD_DIR)/$(HD51_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_3 ::
#	mcopy -i $(IMAGE_BUILD_DIR)/$(HD51_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_4 ::
#	dd conv=notrunc if=$(IMAGE_BUILD_DIR)/$(HD51_BOOT_IMAGE) of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) seek=$(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \* $(BLOCK_SECTOR))
#	dd conv=notrunc if=$(TARGET_DIR)/boot/zImage.dtb of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) seek=$(shell expr $(KERNEL_PARTITION_OFFSET) \* $(BLOCK_SECTOR))
#	$(HOST_DIR)/bin/resize2fs $(IMAGE_BUILD_DIR)/$(HD51_IMAGE_LINK) $(ROOTFS_PARTITION_SIZE_MULTI)k
	# Truncate on purpose
#	dd if=$(IMAGE_BUILD_DIR)/$(HD51_IMAGE_LINK) of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) seek=$(shell expr $(ROOTFS_PARTITION_OFFSET) \* $(BLOCK_SECTOR)) count=$(shell expr $(HD51_IMAGE_ROOTFS_SIZE) \* $(BLOCK_SECTOR))
#	mv $(IMAGE_BUILD_DIR)/disk.img $(IMAGE_BUILD_DIR)/$(BOXTYPE)/

#flash-image-hd51-multi-rootfs:
	# Create final USB-image
#	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
#	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
#	cp $(TARGET_DIR)/boot/zImage.dtb $(IMAGE_BUILD_DIR)/$(BOXTYPE)/kernel.bin
#	cd $(RELEASE_DIR); \
#	tar -cvf $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar --exclude=zImage* . > /dev/null 2>&1; \
#	bzip2 $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar
#	echo $(BOXTYPE)_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/imageversion
#	cd $(IMAGE_BUILD_DIR) && \
#	zip -r $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_multi_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(BOXTYPE)/rootfs.tar.bz2 $(BOXTYPE)/kernel.bin $(BOXTYPE)/disk.img $(BOXTYPE)/imageversion
	# cleanup
#	rm -rf $(IMAGE_BUILD_DIR)

#flash-image-hd51-online:
#	# Create final USB-image
#	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
#	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
#	cp $(TARGET_DIR)/boot/zImage.dtb $(IMAGE_BUILD_DIR)/$(BOXTYPE)/kernel.bin
#	cd $(RELEASE_DIR); \
#	tar -cvf $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar --exclude=zImage* . > /dev/null 2>&1; \
#	bzip2 $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar
#	echo $(BOXTYPE)_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/imageversion
#	cd $(IMAGE_BUILD_DIR)/$(BOXTYPE) && \
#	tar -cvzf $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_online_$(shell date '+%d.%m.%Y-%H.%M').tgz rootfs.tar.bz2 kernel.bin imageversion
	# cleanup
#	rm -rf $(IMAGE_BUILD_DIR)
#endif

#
# hd60
#
#ifeq ($(BOXTYPE), $(filter $(BOXTYPE), hd60))
#HD60_IMAGE_NAME = disk
#HD60_BOOT_IMAGE = bootoptions.img
#HD60_IMAGE_LINK = $(HD60_IMAGE_NAME).ext4

#HD60_BOOTOPTIONS_PARTITION_SIZE = 4096
#HD60_IMAGE_ROOTFS_SIZE = 1048576

#HD60_SRCDATE = 20180912
#HD60_BOOTARGS_SRC = $(BOXTYPE)-bootargs-$(HD60_SRCDATE).zip
#HD60_PARTITONS_SRC = $(BOXTYPE)-partitions-$(HD60_SRCDATE).zip

#BLOCK_SIZE = 512
#BLOCK_SECTOR = 2

#$(ARCHIVE)/$(HD60_BOOTARGS_SRC):
#	$(WGET) http://source.mynonpublic.com/gfutures/$(HD60_BOOTARGS_SRC)

#$(ARCHIVE)/$(HD60_PARTITONS_SRC):
#	$(WGET) http://source.mynonpublic.com/gfutures/$(HD60_PARTITONS_SRC)

#flash-image-hd60-multi-disk: $(ARCHIVE)/$(HD60_BOOTARGS_SRC) $(ARCHIVE)/$(HD60_PARTITONS_SRC)
	# Create image
#	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
#	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
#	unzip -o $(ARCHIVE)/$(HD60_BOOTARGS_SRC) -d $(IMAGE_BUILD_DIR)
#	unzip -o $(ARCHIVE)/$(HD60_PARTITONS_SRC) -d $(IMAGE_BUILD_DIR)
#	echo $(BOXTYPE)_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/imageversion
#	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(HD60_IMAGE_LINK) seek=$(shell expr $(HD60_IMAGE_ROOTFS_SIZE) \* $(BLOCK_SECTOR)) count=0 bs=$(BLOCK_SIZE)
#	$(HOST_DIR)/bin/mkfs.ext4 -F $(IMAGE_BUILD_DIR)/$(HD60_IMAGE_LINK) -d $(RELEASE_DIR)
	# Error codes 0-3 indicate successfull operation of fsck (no errors or errors corrected)
#	$(HOST_DIR)/bin/fsck.ext4 -pvfD $(IMAGE_BUILD_DIR)/$(HD60_IMAGE_LINK) || [ $? -le 3 ]
#	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(HD60_BOOT_IMAGE) bs=1024 count=$(HD60_BOOTOPTIONS_PARTITION_SIZE)
#	mkfs.msdos -S 512 $(IMAGE_BUILD_DIR)/$(HD60_BOOT_IMAGE)
#	echo "bootcmd=mmc read 0 0x1000000 0x53D000 0x8000; bootm 0x1000000 bootargs=console=ttyAMA0,115200 root=/dev/mmcblk0p21 rootfstype=ext4" > $(IMAGE_BUILD_DIR)/STARTUP
#	echo "bootcmd=mmc read 0 0x3F000000 0x70000 0x4000; bootm 0x3F000000; mmc read 0 0x1FFBFC0 0x52000 0xC800; bootargs=androidboot.selinux=enforcing androidboot.serialno=0123456789 console=ttyAMA0,115200" > $(IMAGE_BUILD_DIR)/STARTUP_RED
#	echo "bootcmd=mmc read 0 0x1000000 0x53D000 0x8000; bootm 0x1000000 bootargs=console=ttyAMA0,115200 root=/dev/mmcblk0p21 rootfstype=ext4" > $(IMAGE_BUILD_DIR)/STARTUP_GREEN
#	echo "bootcmd=mmc read 0 0x1000000 0x53D000 0x8000; bootm 0x1000000 bootargs=console=ttyAMA0,115200 root=/dev/mmcblk0p21 rootfstype=ext4" > $(IMAGE_BUILD_DIR)/STARTUP_YELLOW
#	echo "bootcmd=mmc read 0 0x1000000 0x53D000 0x8000; bootm 0x1000000 bootargs=console=ttyAMA0,115200 root=/dev/mmcblk0p21 rootfstype=ext4" > $(IMAGE_BUILD_DIR)/STARTUP_BLUE
#	mcopy -i $(IMAGE_BUILD_DIR)/$(HD60_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP ::
#	mcopy -i $(IMAGE_BUILD_DIR)/$(HD60_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_RED ::
#	mcopy -i $(IMAGE_BUILD_DIR)/$(HD60_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_GREEN ::
#	mcopy -i $(IMAGE_BUILD_DIR)/$(HD60_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_YELLOW ::
#	mcopy -i $(IMAGE_BUILD_DIR)/$(HD60_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_BLUE ::
#	cp $(IMAGE_BUILD_DIR)/$(HD60_BOOT_IMAGE) $(IMAGE_BUILD_DIR)/$(BOXTYPE)/$(HD60_BOOT_IMAGE)
#	ext2simg -zv $(IMAGE_BUILD_DIR)/$(HD60_IMAGE_LINK) $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.fastboot.gz
#	mv $(IMAGE_BUILD_DIR)/bootargs-8gb.bin $(IMAGE_BUILD_DIR)/bootargs.bin
#	mv $(IMAGE_BUILD_DIR)/$(BOXTYPE)/bootargs-8gb.bin $(IMAGE_BUILD_DIR)/$(BOXTYPE)/bootargs.bin
#	cp $(TARGET_DIR)/boot/uImage $(IMAGE_BUILD_DIR)/$(BOXTYPE)/uImage
#	cd $(IMAGE_BUILD_DIR) && \
#	zip -r $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_multi_usb_$(shell date '+%d.%m.%Y-%H.%M').zip *
	# cleanup
#	rm -rf $(IMAGE_BUILD_DIR)
#endif

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
	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
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
	#dd conv=notrunc if=$(TARGET_DIR)/boot/zImage.dtb of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) seek=$(shell expr $(KERNEL_PARTITION_OFFSET) \* $(BLOCK_SECTOR))
	$(HOST_DIR)/bin/resize2fs $(IMAGE_BUILD_DIR)/$(VUSOLO4K_IMAGE_LINK) $(ROOTFS_PARTITION_SIZE_MULTI)k
	# Truncate on purpose
	dd if=$(IMAGE_BUILD_DIR)/$(VUSOLO4K_IMAGE_LINK) of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) seek=$(shell expr $(ROOTFS_PARTITION_OFFSET) \* $(BLOCK_SECTOR)) count=$(shell expr $(VUSOLO4K_IMAGE_ROOTFS_SIZE) \* $(BLOCK_SECTOR))
	mv $(IMAGE_BUILD_DIR)/disk.img $(IMAGE_BUILD_DIR)/$(VUSOLO4K_PREFIX)/

flash-image-vusolo4k-multi-rootfs:
	# Create final USB-image
	mkdir -p $(IMAGE_BUILD_DIR)/$(VUSOLO4K_PREFIX)
	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
	cp $(TARGET_DIR)/boot/vmlinuz-initrd-7366c0 $(IMAGE_BUILD_DIR)/$(VUSOLO4K_PREFIX)/initrd_auto.bin
	cp $(TARGET_DIR)/boot/zImage $(IMAGE_BUILD_DIR)/$(VUSOLO4K_PREFIX)/kernel_auto.bin
	cd $(RELEASE_DIR); \
	tar -cvf $(IMAGE_BUILD_DIR)/$(VUSOLO4K_PREFIX)/rootfs.tar --exclude=zImage* --exclude=vmlinuz-initrd* . > /dev/null 2>&1; \
	bzip2 $(IMAGE_BUILD_DIR)/$(VUSOLO4K_PREFIX)/rootfs.tar
	echo This file forces a reboot after the update. > $(IMAGE_BUILD_DIR)/$(VUSOLO4K_PREFIX)/reboot.update
	echo $(BOXTYPE)_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(VUSOLO4K_PREFIX)/imageversion
	cd $(IMAGE_BUILD_DIR) && \
	zip -r $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_multi_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(VUSOLO4K_PREFIX)/rootfs.tar.bz2 $(VUSOLO4K_PREFIX)/initrd_auto.bin $(VUSOLO4K_PREFIX)/kernel_auto.bin $(VUSOLO4K_PREFIX)/reboot.update $(VUSOLO4K_PREFIX)/imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-vusolo4k-online:
	# Create final USB-image
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
	cp $(TARGET_DIR)/boot/vmlinuz-initrd-7366c0 $(IMAGE_BUILD_DIR)/$(BOXTYPE)/initrd_auto.bin
	cp $(TARGET_DIR)/boot/zImage $(IMAGE_BUILD_DIR)/$(BOXTYPE)/kernel_auto.bin
	cd $(RELEASE_DIR); \
	tar -cvf $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar --exclude=zImage* --exclude=vmlinuz-initrd* . > /dev/null 2>&1; \
	bzip2 $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar
	echo This file forces a reboot after the update. > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/reboot.update
	echo $(BOXTYPE)_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/imageversion
	cd $(IMAGE_BUILD_DIR)/$(BOXTYPE) && \
	tar -cvzf $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_online_$(shell date '+%d.%m.%Y-%H.%M').tgz rootfs.tar.bz2 initrd_auto.bin kernel_auto.bin reboot.update imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)
endif

#
# vuduo
#
#ifeq ($(BOXTYPE), $(filter $(BOXTYPE), vuduo))
#VUDUO_PREFIX = vuplus/duo

#flash-image-vuduo:
	# Create final USB-image
#	mkdir -p $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)
#	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
	# splash
#	cp $(SKEL_ROOT)/boot/splash.bin $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)
#	echo "This file forces a reboot after the update." > $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/reboot.update;
	# kernel
#	gzip -9c < "$(TARGET_DIR)/boot/vmlinux" > "$(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/kernel_cfe_auto.bin"
	# rootfs
#	mkfs.ubifs -r $(RELEASE_DIR) -o $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/root_cfe_auto.ubi -m 2048 -e 126976 -c 4096 -F
#	echo '[ubifs]' > $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
#	echo 'mode=ubi' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
#	echo 'image=$(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/root_cfe_auto.ubi' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
#	echo 'vol_id=0' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
#	echo 'vol_type=dynamic' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
#	echo 'vol_name=rootfs' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
#	echo 'vol_flags=autoresize' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
#	ubinize -o $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/root_cfe_auto.jffs2 -m 2048 -p 128KiB $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
#	rm -f $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/root_cfe_auto.ubi
#	rm -f $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
#	echo $(BOXTYPE)_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/imageversion
#	cd $(IMAGE_BUILD_DIR)/ && \
#	zip -r $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(VUDUO_PREFIX)*
	# cleanup
#	rm -rf $(IMAGE_BUILD_DIR)
#endif

#
# gb800se
#
#ifeq ($(BOXTYPE), $(filter $(BOXTYPE), gb800se))
#GB800SE_PREFIX = gigablue/se

#flash-image-gb800se:
#	# Create final USB-image
#	mkdir -p $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)
#	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
	# splash
#	cp $(SKEL_ROOT)/boot/splash.bin $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)
#	echo "rename this file to 'force' to force an update without confirmation" > $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/noforce;
	# kernel
#	gzip -c < "$(TARGET_DIR)/boot/vmlinux" > "$(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/kernel.bin"
	# rootfs
#	mkfs.ubifs -r $(RELEASE_DIR) -o $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/rootfs.ubi -m 2048 -e 126976 -c 4096
#	echo '[ubifs]' > $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/ubinize.cfg
#	echo 'mode=ubi' >> $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/ubinize.cfg
#	echo 'image=$(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/rootfs.ubi' >> $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/ubinize.cfg
#	echo 'vol_id=0' >> $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/ubinize.cfg
#	echo 'vol_type=dynamic' >> $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/ubinize.cfg
#	echo 'vol_name=rootfs' >> $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/ubinize.cfg
#	echo 'vol_flags=autoresize' >> $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/ubinize.cfg
#	ubinize -o $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/rootfs.bin -m 2048 -p 128KiB $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/ubinize.cfg
#	rm -f $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/rootfs.ubi
#	rm -f $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/ubinize.cfg
#	echo $(BOXTYPE)_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(GB800SE_PREFIX)/imageversion
#	cd $(IMAGE_BUILD_DIR)/ && \
#	zip -r $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(GB800SE_PREFIX)*
	# cleanup
#	rm -rf $(IMAGE_BUILD_DIR)
#endif

#
# osnino
#
#ifeq ($(BOXTYPE), $(filter $(BOXTYPE), osnino osninoplus osninopro))
#OSNINO_PREFIX = edision/$(BOXTYPE)

#flash-image-$(BOXTYPE):
#	# Create final USB-image
#	mkdir -p $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)
#	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
#	# splash
#	cp $(SKEL_ROOT)/boot/splash.bin $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)
#	echo "rename this file to 'force' to force an update without confirmation" > $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/noforce;
#	# kernel
#	gzip -9c < "$(TARGET_DIR)/boot/vmlinux" > "$(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/kernel.bin"
#	# rootfs
#	mkfs.ubifs -r $(RELEASE_DIR) -o $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/rootfs.ubi -m 2048 -e 126976 -c 4096 -F
#	echo '[ubifs]' > $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/ubinize.cfg
#	echo 'mode=ubi' >> $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/ubinize.cfg
#	echo 'image=$(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/rootfs.ubi' >> $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/ubinize.cfg
#	echo 'vol_id=0' >> $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/ubinize.cfg
#	echo 'vol_type=dynamic' >> $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/ubinize.cfg
#	echo 'vol_name=rootfs' >> $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/ubinize.cfg
#	echo 'vol_flags=autoresize' >> $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/ubinize.cfg
#	ubinize -o $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/rootfs.bin -m 2048 -p 128KiB $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
#	rm -f $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/rootfs.ubi
#	rm -f $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/ubinize.cfg
#	echo $(BOXTYPE)_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(OSNINO_PREFIX)/imageversion
#	cd $(IMAGE_BUILD_DIR)/ && \
#	zip -r $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(OSNINO_PREFIX)*
#	# cleanup
#	rm -rf $(IMAGE_BUILD_DIR)
#endif

#
# osmio4k | osmio4kplus | osmini4k
#
#ifeq ($(BOXTYPE), $(filter $(BOXTYPE), osmio4k osmio4kplus osmini4k))
#IMAGE_NAME = emmc
#IMAGE_LINK = $(IMAGE_NAME).ext4

# emmc image
#EMMC_IMAGE = $(IMAGE_BUILD_DIR)/$(IMAGE_NAME).img
#EMMC_IMAGE_SIZE = 7634944

# partition offsets/sizes
#IMAGE_ROOTFS_ALIGNMENT = 1024
#BOOT_PARTITION_SIZE    = 3072
#KERNEL_PARTITION_SIZE  = 8192
#ROOTFS_PARTITION_SIZE  = 1767424

#KERNEL1_PARTITION_OFFSET = $(shell expr $(IMAGE_ROOTFS_ALIGNMENT)   + $(BOOT_PARTITION_SIZE))
#ROOTFS1_PARTITION_OFFSET = $(shell expr $(KERNEL1_PARTITION_OFFSET) + $(KERNEL_PARTITION_SIZE))

#KERNEL2_PARTITION_OFFSET = $(shell expr $(ROOTFS1_PARTITION_OFFSET) + $(ROOTFS_PARTITION_SIZE))
#ROOTFS2_PARTITION_OFFSET = $(shell expr $(KERNEL2_PARTITION_OFFSET) + $(KERNEL_PARTITION_SIZE))

#KERNEL3_PARTITION_OFFSET = $(shell expr $(ROOTFS2_PARTITION_OFFSET) + $(ROOTFS_PARTITION_SIZE))
#ROOTFS3_PARTITION_OFFSET = $(shell expr $(KERNEL3_PARTITION_OFFSET) + $(KERNEL_PARTITION_SIZE))

#KERNEL4_PARTITION_OFFSET = $(shell expr $(ROOTFS3_PARTITION_OFFSET) + $(ROOTFS_PARTITION_SIZE))
#ROOTFS4_PARTITION_OFFSET = $(shell expr $(KERNEL4_PARTITION_OFFSET) + $(KERNEL_PARTITION_SIZE))

#SWAP_PARTITION_OFFSET = $(shell expr $(ROOTFS4_PARTITION_OFFSET) + $(ROOTFS_PARTITION_SIZE))

#flash-image-$(BOXTYPE)-multi-disk:
#	rm -rf $(IMAGE_BUILD_DIR) || true
#	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
	# Create a sparse image block
#	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(IMAGE_LINK) seek=$(shell expr $(EMMC_IMAGE_SIZE) \* 1024) count=0 bs=1
#	$(HOST_DIR)/bin/mkfs.ext4 -F -m0 $(IMAGE_BUILD_DIR)/$(IMAGE_LINK) -d $(RELEASE_DIR)
	# Error codes 0-3 indicate successfull operation of fsck (no errors or errors corrected)
#	$(HOST_DIR)/bin/fsck.ext4 -pfD $(IMAGE_BUILD_DIR)/$(IMAGE_LINK) || [ $? -le 3 ]
#	dd if=/dev/zero of=$(EMMC_IMAGE) bs=1 count=0 seek=$(shell expr $(EMMC_IMAGE_SIZE) \* 1024)
#	parted -s $(EMMC_IMAGE) mklabel gpt
#	parted -s $(EMMC_IMAGE) unit KiB mkpart boot fat16 $(IMAGE_ROOTFS_ALIGNMENT) $(shell expr $(IMAGE_ROOTFS_ALIGNMENT) + $(BOOT_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) set 1 boot on
#	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel1 $(KERNEL1_PARTITION_OFFSET) $(shell expr $(KERNEL1_PARTITION_OFFSET) + $(KERNEL_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs1 ext4 $(ROOTFS1_PARTITION_OFFSET) $(shell expr $(ROOTFS1_PARTITION_OFFSET) + $(ROOTFS_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel2 $(KERNEL2_PARTITION_OFFSET) $(shell expr $(KERNEL2_PARTITION_OFFSET) + $(KERNEL_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs2 ext4 $(ROOTFS2_PARTITION_OFFSET) $(shell expr $(ROOTFS2_PARTITION_OFFSET) + $(ROOTFS_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel3 $(KERNEL3_PARTITION_OFFSET) $(shell expr $(KERNEL3_PARTITION_OFFSET) + $(KERNEL_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs3 ext4 $(ROOTFS3_PARTITION_OFFSET) $(shell expr $(ROOTFS3_PARTITION_OFFSET) + $(ROOTFS_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel4 $(KERNEL4_PARTITION_OFFSET) $(shell expr $(KERNEL4_PARTITION_OFFSET) + $(KERNEL_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs4 ext4 $(ROOTFS4_PARTITION_OFFSET) $(shell expr $(ROOTFS4_PARTITION_OFFSET) + $(ROOTFS_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart swap linux-swap $(SWAP_PARTITION_OFFSET) 100%
#	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/boot.img bs=1024 count=$(BOOT_PARTITION_SIZE)
#	mkfs.msdos -n boot -S 512 $(IMAGE_BUILD_DIR)/boot.img
#	echo "setenv STARTUP \"boot emmcflash0.kernel1 'root=/dev/mmcblk1p3 rootfstype=ext4 rw rootwait'\"" > $(IMAGE_BUILD_DIR)/STARTUP
#	echo "setenv STARTUP \"boot emmcflash0.kernel1 'root=/dev/mmcblk1p3 rootfstype=ext4 rw rootwait'\"" > $(IMAGE_BUILD_DIR)/STARTUP_1
#	echo "setenv STARTUP \"boot emmcflash0.kernel2 'root=/dev/mmcblk1p5 rootfstype=ext4 rw rootwait'\"" > $(IMAGE_BUILD_DIR)/STARTUP_2
#	echo "setenv STARTUP \"boot emmcflash0.kernel3 'root=/dev/mmcblk1p7 rootfstype=ext4 rw rootwait'\"" > $(IMAGE_BUILD_DIR)/STARTUP_3
#	echo "setenv STARTUP \"boot emmcflash0.kernel4 'root=/dev/mmcblk1p9 rootfstype=ext4 rw rootwait'\"" > $(IMAGE_BUILD_DIR)/STARTUP_4
#	mcopy -i $(IMAGE_BUILD_DIR)/boot.img -v $(IMAGE_BUILD_DIR)/STARTUP ::
#	mcopy -i $(IMAGE_BUILD_DIR)/boot.img -v $(IMAGE_BUILD_DIR)/STARTUP_1 ::
#	mcopy -i $(IMAGE_BUILD_DIR)/boot.img -v $(IMAGE_BUILD_DIR)/STARTUP_2 ::
#	mcopy -i $(IMAGE_BUILD_DIR)/boot.img -v $(IMAGE_BUILD_DIR)/STARTUP_3 ::
#	mcopy -i $(IMAGE_BUILD_DIR)/boot.img -v $(IMAGE_BUILD_DIR)/STARTUP_4 ::
#	parted -s $(EMMC_IMAGE) unit KiB print
#	dd conv=notrunc if=$(IMAGE_BUILD_DIR)/boot.img of=$(EMMC_IMAGE) seek=1 bs=$(shell expr $#(IMAGE_ROOTFS_ALIGNMENT) \* 1024)
#	dd conv=notrunc if=$(TARGET_DIR)/boot/zImage of=$(EMMC_IMAGE) seek=1 bs=$(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \* 1024 + $(BOOT_PARTITION_SIZE) \* 1024)
#	$(HOST_DIR)/bin/resize2fs $(IMAGE_BUILD_DIR)/$(IMAGE_LINK) $(ROOTFS_PARTITION_SIZE)k
	# Truncate on purpose
#	dd if=$(IMAGE_BUILD_DIR)/$(IMAGE_LINK) of=$(EMMC_IMAGE) seek=1 bs=$(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \* 1024 + $(BOOT_PARTITION_SIZE) \* 1024 + $(KERNEL_PARTITION_SIZE) \* 1024)
#	mv $(EMMC_IMAGE) $(IMAGE_BUILD_DIR)/$(BOXTYPE)/

#flash-image-$(BOXTYPE)-multi-rootfs:
	# Create final USB-image
#	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
#	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
#	cp $(TARGET_DIR)/boot/zImage $(IMAGE_BUILD_DIR)/$(BOXTYPE)/kernel.bin
#	cd $(RELEASE_DIR) && \
#	tar -cvf $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar . >/dev/null 2>&1; \
#	bzip2 $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar
#	echo $(BOXTYPE)_DDT_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/imageversion
#	echo "rename this file to 'force' to force an update without confirmation" > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/noforce; \
#	cd $(IMAGE_BUILD_DIR) && \
#	zip -r $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_multi_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(BOXTYPE)/rootfs.tar.bz2 $(BOXTYPE)/kernel.bin $(BOXTYPE)/$(IMAGE_NAME).img $(BOXTYPE)/imageversion
	# cleanup
#	rm -rf $(IMAGE_BUILD_DIR)

#flash-image-$(BOXTYPE)-online:
#	# Create final USB-image
#	rm -rf $(IMAGE_BUILD_DIR) || true
#	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
#	cp $(TARGET_DIR)/boot/zImage $(IMAGE_BUILD_DIR)/$(BOXTYPE)/kernel.bin
#	cd $(RELEASE_DIR) && \
#	tar -cvf $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar . >/dev/null 2>&1; \
#	bzip2 $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar
#	echo $(BOXTYPE)_DDT_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/imageversion
#	echo "rename this file to 'force' to force an update without confirmation" > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/noforce; \
#	cd $(IMAGE_BUILD_DIR)/$(BOXTYPE) && \
#	tar -cvzf $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_online_$(shell date '+%d.%m.%Y-%H.%M').tgz rootfs.tar.bz2 kernel.bin imageversion
	# cleanup
#	rm -rf $(IMAGE_BUILD_DIR)
#endif

#
# bre2ze4k | h7
#
#ifeq ($(BOXTYPE), $(filter $(BOXTYPE), h7))
# general
#FLASH_IMAGE_NAME = disk
#FLASH_BOOT_IMAGE = boot.img
#FLASH_IMAGE_LINK = $(FLASH_IMAGE_NAME).ext4
#FLASH_IMAGE_ROOTFS_SIZE = 294912

# emmc image
#EMMC_IMAGE_SIZE = 3817472
#EMMC_IMAGE = $(IMAGE_BUILD_DIR)/$(FLASH_IMAGE_NAME).img

# partition sizes
#BLOCK_SIZE = 512
#BLOCK_SECTOR = 2
#IMAGE_ROOTFS_ALIGNMENT = 1024
#BOOT_PARTITION_SIZE = 3072
#KERNEL_PARTITION_SIZE = 8192
#SWAP_PARTITION_SIZE = 262144
# partition size single
# without storage partition 819200 each
# 51200 * 4
#STORAGE_PARTITION_SIZE = 204800
#ROOTFS_PARTITION_SINGLE_SIZE = 768000
# linuxrootfs1
#ROOTFS_PARTITION_MULTI_SIZE = 1048576
# linuxrootfs2-4
# MULTI_ROOTFS_PARTITION_SIZE = 2468864 - 204800 = 2264064
#ALL_KERNEL_SIZE = $(shell expr 4 \* $(KERNEL_PARTITION_SIZE))
#MULTI_ROOTFS_PARTITION_SIZE = $(shell expr $(EMMC_IMAGE_SIZE) \- $(BLOCK_SECTOR) \* $(IMAGE_ROOTFS_ALIGNMENT) \- $(BOOT_PARTITION_SIZE) \- $(ALL_KERNEL_SIZE) \- $(ROOTFS_PARTITION_MULTI_SIZE) \- $(SWAP_PARTITION_SIZE) \- $(STORAGE_PARTITION_SIZE))

#KERNEL_PARTITION_OFFSET = $(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \+ $(BOOT_PARTITION_SIZE))
#ROOTFS_PARTITION_OFFSET = $(shell expr $(KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))

#calc the offsets (single)
#SECOND_KERNEL_PARTITION_OFFSET = $(shell expr $(ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SINGLE_SIZE))
#SECOND_ROOTFS_PARTITION_OFFSET = $(shell expr $(SECOND_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
#THIRD_KERNEL_PARTITION_OFFSET = $(shell expr $(SECOND_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SINGLE_SIZE))
#THIRD_ROOTFS_PARTITION_OFFSET = $(shell expr $(THIRD_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
#FOURTH_KERNEL_PARTITION_OFFSET = $(shell expr $(THIRD_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SINGLE_SIZE))
#FOURTH_ROOTFS_PARTITION_OFFSET = $(shell expr $(FOURTH_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
#SWAP_PARTITION_OFFSET = $(shell expr $(FOURTH_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SINGLE_SIZE))
#STORAGE_PARTITION_OFFSET = $(shell expr $(SWAP_PARTITION_OFFSET) \+ $(SWAP_PARTITION_SIZE))

#calc the offsets (multi)
#SECOND_KERNEL_PARTITION_OFFSET_NL = $(shell expr $(ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_MULTI_SIZE))
#THIRD_KERNEL_PARTITION_OFFSET_NL = $(shell expr $(SECOND_KERNEL_PARTITION_OFFSET_NL) \+ $(KERNEL_PARTITION_SIZE))
#FOURTH_KERNEL_PARTITION_OFFSET_NL = $(shell expr $(THIRD_KERNEL_PARTITION_OFFSET_NL) \+ $(KERNEL_PARTITION_SIZE))
#SWAP_PARTITION_OFFSET_NL = $(shell expr $(FOURTH_KERNEL_PARTITION_OFFSET_NL) \+ $(KERNEL_PARTITION_SIZE))
#MULTI_ROOTFS_PARTITION_OFFSET = $(shell expr $(SWAP_PARTITION_OFFSET_NL) \+ $(SWAP_PARTITION_SIZE))
#STORAGE_PARTITION_OFFSET_NL = $(shell expr $(MULTI_ROOTFS_PARTITION_OFFSET) \+ $(MULTI_ROOTFS_PARTITION_SIZE))

#flash-image-$(BOXTYPE)-multi-disk: $(D)/host_resize2fs
#	rm -rf $(IMAGE_BUILD_DIR) || true
#	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
#	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
	# kernel
#	cp $(TARGET_DIR)/boot/zImage* $(IMAGE_BUILD_DIR)/
	# Create a sparse image block
#	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(FLASH_IMAGE_LINK) seek=$(shell expr $(FLASH_IMAGE_ROOTFS_SIZE) \* $(BLOCK_SECTOR)) count=0 bs=$(BLOCK_SIZE)
#	$(HOST_DIR)/bin/mkfs.ext4 -F $(IMAGE_BUILD_DIR)/$(FLASH_IMAGE_LINK) -d $(RELEASE_DIR)
	# move kernel files back to $(RELEASE_DIR)/boot
#	mv -f $(IMAGE_BUILD_DIR)/zImage* $(RELEASE_DIR)/boot/
	# Error codes 0-3 indicate successfull operation of fsck (no errors or errors corrected)
#	$(HOST_DIR)/bin/fsck.ext4 -pvfD $(IMAGE_BUILD_DIR)/$(FLASH_IMAGE_LINK) || [ $? -le 3 ]
#	dd if=/dev/zero of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) count=0 seek=$(shell expr $(EMMC_IMAGE_SIZE) \* $(BLOCK_SECTOR))
#	parted -s $(EMMC_IMAGE) mklabel gpt
#	parted -s $(EMMC_IMAGE) unit KiB mkpart boot fat16 $(IMAGE_ROOTFS_ALIGNMENT) $(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \+ $(BOOT_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel1 $(KERNEL_PARTITION_OFFSET) $(shell expr $(KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs1 ext4 $(ROOTFS_PARTITION_OFFSET) $(shell expr $(ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SINGLE_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel2 $(SECOND_KERNEL_PARTITION_OFFSET) $(shell expr $(SECOND_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs2 ext4 $(SECOND_ROOTFS_PARTITION_OFFSET) $(shell expr $(SECOND_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SINGLE_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel3 $(THIRD_KERNEL_PARTITION_OFFSET) $(shell expr $(THIRD_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs3 ext4 $(THIRD_ROOTFS_PARTITION_OFFSET) $(shell expr $(THIRD_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SINGLE_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel4 $(FOURTH_KERNEL_PARTITION_OFFSET) $(shell expr $(FOURTH_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs4 ext4 $(FOURTH_ROOTFS_PARTITION_OFFSET) $(shell expr $(FOURTH_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SINGLE_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart swap linux-swap $(SWAP_PARTITION_OFFSET) $(shell expr $(SWAP_PARTITION_OFFSET) \+ $(SWAP_PARTITION_SIZE))
#	parted -s $(EMMC_IMAGE) unit KiB mkpart storage ext4 $(STORAGE_PARTITION_OFFSET) 100%
#	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(FLASH_BOOT_IMAGE) bs=$(BLOCK_SIZE) count=$(shell expr $(BOOT_PARTITION_SIZE) \* $(BLOCK_SECTOR))
#	mkfs.msdos -S 512 $(IMAGE_BUILD_DIR)/$(FLASH_BOOT_IMAGE)
#	echo "boot emmcflash0.kernel1 'brcm_cma=440M@328M brcm_cma=192M@768M root=/dev/mmcblk0p3 rw rootwait $(BOXTYPE)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP
#	echo "boot emmcflash0.kernel1 'brcm_cma=440M@328M brcm_cma=192M@768M root=/dev/mmcblk0p3 rw rootwait $(BOXTYPE)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP_1
#	echo "boot emmcflash0.kernel2 'brcm_cma=440M@328M brcm_cma=192M@768M root=/dev/mmcblk0p5 rw rootwait $(BOXTYPE)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP_2
#	echo "boot emmcflash0.kernel3 'brcm_cma=440M@328M brcm_cma=192M@768M root=/dev/mmcblk0p7 rw rootwait $(BOXTYPE)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP_3
#	echo "boot emmcflash0.kernel4 'brcm_cma=440M@328M brcm_cma=192M@768M root=/dev/mmcblk0p9 rw rootwait $(BOXTYPE)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP_4
#	mcopy -i $(IMAGE_BUILD_DIR)/$(FLASH_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP ::
#	mcopy -i $(IMAGE_BUILD_DIR)/$(FLASH_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_1 ::
#	mcopy -i $(IMAGE_BUILD_DIR)/$(FLASH_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_2 ::
#	mcopy -i $(IMAGE_BUILD_DIR)/$(FLASH_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_3 ::
#	mcopy -i $(IMAGE_BUILD_DIR)/$(FLASH_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_4 ::
#	dd conv=notrunc if=$(IMAGE_BUILD_DIR)/$(FLASH_BOOT_IMAGE) of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) seek=$(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \* $(BLOCK_SECTOR))
#	dd conv=notrunc if=$(TARGET_DIR)/boot/zImage.dtb of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) seek=$(shell expr $(KERNEL_PARTITION_OFFSET) \* $(BLOCK_SECTOR))
#	$(HOST_DIR)/bin/resize2fs $(IMAGE_BUILD_DIR)/$(FLASH_IMAGE_LINK) $(ROOTFS_PARTITION_SINGLE_SIZE)k
	# Truncate on purpose
#	dd if=$(IMAGE_BUILD_DIR)/$(FLASH_IMAGE_LINK) of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) seek=$(shell expr $(ROOTFS_PARTITION_OFFSET) \* $(BLOCK_SECTOR)) count=$(shell expr $(FLASH_IMAGE_ROOTFS_SIZE) \* $(BLOCK_SECTOR))
#	mv $(IMAGE_BUILD_DIR)/disk.img $(IMAGE_BUILD_DIR)/$(BOXTYPE)/

#flash-image-$(BOXTYPE)-multi-rootfs:
#	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
#	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
#	cp $(TARGET_DIR)/boot/zImage.dtb $(IMAGE_BUILD_DIR)/$(BOXTYPE)/kernel.bin
#	cd $(RELEASE_DIR); \
#	tar -cvf $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar --exclude=zImage* . > /dev/null 2>&1; \
#	bzip2 $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar
#	echo $(BOXTYPE)_usb_$(shell date '+%d.%m.%Y-%H.%M') > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/imageversion
#	cd $(IMAGE_BUILD_DIR) && \
#	zip -r $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(BOXTYPE)/rootfs.tar.bz2 $(BOXTYPE)/kernel.bin $(BOXTYPE)/disk.img $(BOXTYPE)/imageversion
	# cleanup
#	rm -rf $(IMAGE_BUILD_DIR)

#flash-image-$(BOXTYPE)-online:
#	rm -rf $(IMAGE_BUILD_DIR) || true
#	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
#	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
#	cp $(TARGET_DIR)/boot/zImage.dtb $(IMAGE_BUILD_DIR)/$(BOXTYPE)/kernel.bin
#	cd $(RELEASE_DIR); \
#	tar -cvf $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar --exclude=zImage* . > /dev/null 2>&1; \
#	bzip2 $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar
#	echo $(BOXTYPE)_online_$(shell date '+%d.%m.%Y-%H.%M') > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/imageversion
#	cd $(IMAGE_BUILD_DIR)/$(BOXTYPE) && \
#	tar -cvzf $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_online_$(shell date '+%d.%m.%Y-%H.%M').tgz rootfs.tar.bz2 kernel.bin imageversion
	# cleanup
#	rm -rf $(IMAGE_BUILD_DIR)
#endif

#
# hd61
#
#ifeq ($(BOXTYPE), $(filter $(BOXTYPE), hd61))
# general
#FLASH_IMAGE_NAME = disk
#FLASH_BOOT_IMAGE = bootoptions.img
#FLASH_IMAGE_LINK = $(FLASH_IMAGE_NAME).ext4

#FLASH_BOOTOPTIONS_PARTITION_SIZE = 32768
#FLASH_IMAGE_ROOTFS_SIZE = 1024M

#FLASH_BOOTARGS_DATE = 20200504
#FLASH_BOOTARGS_SRC = hd61-bootargs-$(FLASH_BOOTARGS_DATE).zip
#FLASH_PARTITONS_DATE = 20200319
#FLASH_PARTITONS_SRC = hd61-partitions-$(FLASH_PARTITONS_DATE).zip
#FLASH_RECOVERY_DATE = 20200424
#FLASH_RECOVERY_SRC = hd61-recovery-$(FLASH_RECOVERY_DATE).zip

#$(ARCHIVE)/$(FLASH_BOOTARGS_SRC):
#	$(WGET) http://source.mynonpublic.com/gfutures/$(FLASH_BOOTARGS_SRC)

#$(ARCHIVE)/$(FLASH_PARTITONS_SRC):
#	$(WGET) http://source.mynonpublic.com/gfutures/$(FLASH_PARTITONS_SRC)

#$(ARCHIVE)/$(FLASH_RECOVERY_SRC):
#	$(WGET) http://downloads.mutant-digital.net/hd61/$(FLASH_RECOVERY_SRC)

#flash-image-hd61-multi-disk: $(ARCHIVE)/$(FLASH_BOOTARGS_SRC) $(ARCHIVE)/$(FLASH_PARTITONS_SRC) $(ARCHIVE)/$(FLASH_RECOVERY_SRC)
#	rm -rf $(IMAGE_BUILD_DIR) || true
#	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
#	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
#	unzip -o $(ARCHIVE)/$(FLASH_BOOTARGS_SRC) -d $(IMAGE_BUILD_DIR)
#	unzip -o $(ARCHIVE)/$(FLASH_PARTITONS_SRC) -d $(IMAGE_BUILD_DIR)
#	unzip -o $(ARCHIVE)/$(FLASH_RECOVERY_SRC) -d $(IMAGE_BUILD_DIR)
#	install -m 0755 $(IMAGE_BUILD_DIR)/bootargs-8gb.bin $(RELEASE_DIR)/usr/share/bootargs.bin
#	install -m 0755 $(IMAGE_BUILD_DIR)/fastboot.bin $(RELEASE_DIR)/usr/share/fastboot.bin
#	if [ -e $(RELEASE_DIR)/boot/logo.img ]; then \
#		cp -rf $(RELEASE_DIR)/boot/logo.img $(IMAGE_BUILD_DIR)/$(BOXTYPE); \
#	fi
#	echo "$(BOXTYPE)_$(shell date '+%d.%m.%Y-%H.%M')_RECOVERY" > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/recoveryversion
#	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(BOXTYPE)/$(FLASH_BOOT_IMAGE) bs=1024 count=$(FLASH_BOOTOPTIONS_PARTITION_SIZE)
#	mkfs.msdos -S 512 $(IMAGE_BUILD_DIR)/$(BOXTYPE)/$(FLASH_BOOT_IMAGE)
#	echo "bootcmd=setenv bootargs \$$(bootargs) \$$(bootargs_common); mmc read 0 0x1000000 0x3BD000 0x8000; bootm 0x1000000; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP
#	echo "bootargs=root=/dev/mmcblk0p23 rootsubdir=linuxrootfs1 rootfstype=ext4 kernel=/dev/mmcblk0p19" >> $(IMAGE_BUILD_DIR)/STARTUP
#	echo "bootcmd=setenv vfd_msg andr;setenv bootargs \$$(bootargs) \$$(bootargs_common); run bootcmd_android; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_ANDROID
#	echo "bootargs=androidboot.selinux=disable androidboot.serialno=0123456789" >> $(IMAGE_BUILD_DIR)/STARTUP_ANDROID
#	echo "bootcmd=setenv vfd_msg andr;setenv bootargs \$$(bootargs) \$$(bootargs_common); run bootcmd_android; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_ANDROID_DISABLE_LINUXSE
#	echo "bootargs=androidboot.selinux=disable androidboot.serialno=0123456789" >> $(IMAGE_BUILD_DIR)/STARTUP_ANDROID_DISABLE_LINUXSE
#	echo "bootcmd=setenv bootargs \$$(bootargs) \$$(bootargs_common); mmc read 0 0x1000000 0x3BD000 0x8000; bootm 0x1000000; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_LINUX_1
#	echo "bootargs=root=/dev/mmcblk0p23 rootsubdir=linuxrootfs1 rootfstype=ext4 kernel=/dev/mmcblk0p19" >> $(IMAGE_BUILD_DIR)/STARTUP_LINUX_1
#	echo "bootcmd=setenv bootargs \$$(bootargs) \$$(bootargs_common); mmc read 0 0x1000000 0x3C5000 0x8000; bootm 0x1000000; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_LINUX_2
#	echo "bootargs=root=/dev/mmcblk0p23 rootsubdir=linuxrootfs2 rootfstype=ext4 kernel=/dev/mmcblk0p20" >> $(IMAGE_BUILD_DIR)/STARTUP_LINUX_2
#	echo "bootcmd=setenv bootargs \$$(bootargs) \$$(bootargs_common); mmc read 0 0x1000000 0x3CD000 0x8000; bootm 0x1000000; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_LINUX_3
#	echo "bootargs=root=/dev/mmcblk0p23 rootsubdir=linuxrootfs3 rootfstype=ext4 kernel=/dev/mmcblk0p21" >> $(IMAGE_BUILD_DIR)/STARTUP_LINUX_3
#	echo "bootcmd=setenv bootargs \$$(bootargs) \$$(bootargs_common); mmc read 0 0x1000000 0x3D5000 0x8000; bootm 0x1000000; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_LINUX_4
#	echo "bootargs=root=/dev/mmcblk0p23 rootsubdir=linuxrootfs4 rootfstype=ext4 kernel=/dev/mmcblk0p22" >> $(IMAGE_BUILD_DIR)/STARTUP_LINUX_4
#	echo "bootcmd=setenv bootargs \$$(bootargs_common); mmc read 0 0x1000000 0x1000 0x9000; bootm 0x1000000" > $(IMAGE_BUILD_DIR)/STARTUP_RECOVERY
#	echo "bootcmd=setenv bootargs \$$(bootargs_common); mmc read 0 0x1000000 0x1000 0x9000; bootm 0x1000000" > $(IMAGE_BUILD_DIR)/STARTUP_ONCE
#	echo "imageurl https://raw.githubusercontent.com/oe-alliance/bootmenu/master/$(BOXTYPE)/images" > $(IMAGE_BUILD_DIR)/bootmenu.conf
#	echo "# " >> $(IMAGE_BUILD_DIR)/bootmenu.conf
#	echo "iface eth0" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
#	echo "dhcp yes" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
#	echo "# " >> $(IMAGE_BUILD_DIR)/bootmenu.conf
#	echo "# for static config leave out 'dhcp yes' and add the following settings:" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
#	echo "# " >> $(IMAGE_BUILD_DIR)/bootmenu.conf
#	echo "#ip 192.168.178.10" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
#	echo "#netmask 255.255.255.0" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
#	echo "#gateway 192.168.178.1" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
#	echo "#dns 192.168.178.1" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
#	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXTYPE)/$(FLASH_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP ::
#	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXTYPE)/$(FLASH_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_ANDROID ::
#	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXTYPE)/$(FLASH_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_ANDROID_DISABLE_LINUXSE ::
#	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXTYPE)/$(FLASH_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_LINUX_1 ::
#	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXTYPE)/$(FLASH_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_LINUX_2 ::
#	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXTYPE)/$(FLASH_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_LINUX_3 ::
#	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXTYPE)/$(FLASH_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_LINUX_4 ::
#	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXTYPE)/$(FLASH_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_RECOVERY ::
#	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXTYPE)/$(FLASH_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/bootmenu.conf ::
#	mv $(IMAGE_BUILD_DIR)/bootargs-8gb.bin $(IMAGE_BUILD_DIR)/bootargs.bin
#	mv $(IMAGE_BUILD_DIR)/$(BOXTYPE)/bootargs-8gb.bin $(IMAGE_BUILD_DIR)/$(BOXTYPE)/bootargs.bin
#	echo boot-recovery > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/misc-boot.img
#	cp $(TARGET_DIR)/boot/uImage $(IMAGE_BUILD_DIR)/$(BOXTYPE)/uImage
#	rm -rf $(IMAGE_BUILD_DIR)/STARTUP*
#	rm -rf $(IMAGE_BUILD_DIR)/*.txt
#	rm -rf $(IMAGE_BUILD_DIR)/$(BOXTYPE)/*.txt
#	rm -rf $(IMAGE_BUILD_DIR)/$(FLASH_IMAGE_LINK)
#	echo "To access the recovery image press immediately by power-up the frontpanel button or hold down a remote button key untill the display says boot" > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/recovery.txt
#	cd $(IMAGE_BUILD_DIR) && \
#	zip -r $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_multiroot_usb_$(shell date '+%d.%m.%Y-%H.%M')_recovery_emmc.zip *
	# cleanup
#	rm -rf $(IMAGE_BUILD_DIR)

#flash-image-hd61-multi-rootfs:
#	rm -rf $(IMAGE_BUILD_DIR) || true
#	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
#	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
#	cp $(TARGET_DIR)/boot/uImage $(IMAGE_BUILD_DIR)/$(BOXTYPE)/uImage
#	cd $(RELEASE_DIR); \
#	tar -cvf $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar --exclude=uImage* . > /dev/null 2>&1; \
#	bzip2 $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar
#	echo "$(BOXTYPE)_multiroot_usb_$(shell date '+%d.%m.%Y-%H.%M')" > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/imageversion
#	echo "$(BOXTYPE)_multiroot_usb_$(shell date '+%d.%m.%Y-%H.%M')_emmc.zip" > $(IMAGE_BUILD_DIR)/unforce_$(BOXTYPE).txt; \
#	echo "Rename the unforce_$(BOXTYPE).txt to force_$(BOXTYPE).txt and move it to the root of your usb-stick" > $(IMAGE_BUILD_DIR)/force_$(BOXTYPE)_READ.ME; \
#	echo "When you enter the recovery menu then it will force to install the image $$(cat $(IMAGE_BUILD_DIR)/$(BOXTYPE)/imageversion).zip in the image-slot1" >> $(IMAGE_BUILD_DIR)/force_$(BOXTYPE)_READ.ME; \
#	cd $(IMAGE_BUILD_DIR) && \
#	zip -r $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_multiroot_usb_$(shell date '+%d.%m.%Y-%H.%M')_mmc.zip unforce_$(BOXTYPE).txt force_$(BOXTYPE)_READ.ME $(BOXTYPE)/rootfs.tar.bz2 $(BOXTYPE)/uImage $(BOXTYPE)/imageversion
	# cleanup
#	rm -rf $(IMAGE_BUILD_DIR)

#flash-image-hd61-online:
#	rm -rf $(IMAGE_BUILD_DIR) || true
#	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXTYPE)
#	cp $(TARGET_DIR)/boot/uImage $(IMAGE_BUILD_DIR)/$(BOXTYPE)/uImage
#	cd $(RELEASE_DIR); \
#	tar -cvf $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar --exclude=uImage* . > /dev/null 2>&1; \
#	bzip2 $(IMAGE_BUILD_DIR)/$(BOXTYPE)/rootfs.tar
#	echo $(BOXTYPE)_online_$(shell date '+%d.%m.%Y-%H.%M') > $(IMAGE_BUILD_DIR)/$(BOXTYPE)/imageversion
#	cd $(IMAGE_BUILD_DIR)/$(BOXTYPE) && \
#	tar -cvzf $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_multiroot_online_$(shell date '+%d.%m.%Y-%H.%M').tgz rootfs.tar.bz2 uImage imageversion
	# cleanup
#	rm -rf $(IMAGE_BUILD_DIR)
#endif

#
# vuduo2
#
#ifeq ($(BOXTYPE), vuduo2)
#VUDUO_PREFIX = vuplus/duo2

#flash-image-vuduo2:
#	rm -rf $(IMAGE_BUILD_DIR) || true
#	mkdir -p $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)
#	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
#	touch $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/reboot.update
#	cp $(SKEL_ROOT)/boot/splash.bin $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/splash_cfe_auto.bin
	# kernel
#	gzip -9c < "$(TARGET_DIR)/boot/vmlinux" > "$(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/kernel_cfe_auto.bin"
#	cp $(TARGET_DIR)/boot/vmlinuz-initrd-7425b0 $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/initrd_cfe_auto.bin
#	mkfs.ubifs -r $(RELEASE_DIR) -o $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/root_cfe_auto.ubi -m 2048 -e 126976 -c 8192
#	echo '[ubifs]' > $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
#	echo 'mode=ubi' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
#	echo 'image=$(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/root_cfe_auto.ubi' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
#	echo 'vol_id=0' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
#	echo 'vol_type=dynamic' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
#	echo 'vol_name=rootfs' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
#	echo 'vol_flags=autoresize' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
#	ubinize -o $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/root_cfe_auto.jffs2 -m 2048 -p 128KiB $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
#	rm -f $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/root_cfe_auto.ubi
#	rm -f $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
#	echo $(BOXTYPE)_DDT_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/imageversion
#	cd $(IMAGE_BUILD_DIR)/ && \
#	zip -r $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(VUDUO_PREFIX)*
	# cleanup
#	rm -rf $(IMAGE_BUILD_DIR)
#endif

#
# vuduo4k
#
ifeq ($(BOXTYPE), vuduo4k)
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
endif

#
# vuultimo4k
#
ifeq ($(BOXTYPE), vuultimo4k)
VU_PREFIX = vuplus/ultimo4k

flash-image-vuultimo4k-multi-rootfs:
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(VU_PREFIX)
	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
	cp $(TARGET_DIR)/boot/vmlinuz-initrd-7445d0 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/initrd_auto.bin
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

flash-image-vuultimo4k-online:
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(VU_PREFIX)
	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
	cp $(TARGET_DIR)/boot/vmlinuz-initrd-7445d0 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/initrd_auto.bin
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
endif

#
# vuuno4k
ifeq ($(BOXTYPE), vuuno4k)
VU_PREFIX = vuplus/uno4k

flash-image-vuuno4k-multi-rootfs:
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(VU_PREFIX)
	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
	cp $(TARGET_DIR)/boot/vmlinuz-initrd-7439b0 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/initrd_auto.bin
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
	echo This file forces the update. > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/force.update
	echo Dummy for update. > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel_auto.bin
	echo Dummy for update. > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar.bz2
	echo $(BOXTYPE)_DDT_multi_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/imageversion
	cd $(IMAGE_BUILD_DIR) && \
	zip -r $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_multi_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(VU_PREFIX)/rootfs*.tar.bz2 $(VU_PREFIX)/initrd_auto.bin $(VU_PREFIX)/kernel*_auto.bin $(VU_PREFIX)/*.update $(VU_PREFIX)/imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-vuuno4k-online:
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(VU_PREFIX)
	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
	cp $(TARGET_DIR)/boot/vmlinuz-initrd-7439b0 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/initrd_auto.bin
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
endif

#
# vuuno4kse
#
ifeq ($(BOXTYPE), vuuno4kse)
VU_PREFIX = vuplus/uno4kse

flash-image-vuuno4kse-multi-rootfs:
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(VU_PREFIX)
	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
	cp $(TARGET_DIR)/boot/vmlinuz-initrd-7439b0 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/initrd_auto.bin
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
	echo Dummy for update. > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel_auto.bin
	echo Dummy for update. > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar.bz2
	echo $(BOXTYPE)_DDT_multi_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/imageversion
	cd $(IMAGE_BUILD_DIR) && \
	zip -r $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_multi_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(VU_PREFIX)/rootfs*.tar.bz2 $(VU_PREFIX)/initrd_auto.bin $(VU_PREFIX)/kernel*_auto.bin $(VU_PREFIX)/*.update $(VU_PREFIX)/imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-vuuno4kse-online:
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(VU_PREFIX)
	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
	cp $(TARGET_DIR)/boot/vmlinuz-initrd-7439b0 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/initrd_auto.bin
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
endif

#
# vuzero4k
#
ifeq ($(BOXTYPE), vuzero4k)
VU_PREFIX = vuplus/zero4k

flash-image-vuzero4k-multi-rootfs:
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(VU_PREFIX)
	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
	cp $(TARGET_DIR)/boot/vmlinuz-initrd-7260a0 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/initrd_auto.bin
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
	echo This file forces the update. > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/force.update
	echo Dummy for update. > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel_auto.bin
	echo Dummy for update. > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar.bz2
	echo $(BOXTYPE)_DDT_multi_usb_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/imageversion
	cd $(IMAGE_BUILD_DIR) && \
	zip -r $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_multi_usb_$(shell date '+%d.%m.%Y-%H.%M').zip $(VU_PREFIX)/rootfs*.tar.bz2 $(VU_PREFIX)/initrd_auto.bin $(VU_PREFIX)/kernel*_auto.bin $(VU_PREFIX)/*.update $(VU_PREFIX)/imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-vuzero4k-online:
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(VU_PREFIX)
	mkdir -p $(FLASH_DIR)/$(BOXTYPE)
	cp $(TARGET_DIR)/boot/vmlinuz-initrd-7260a0 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/initrd_auto.bin
	cp $(TARGET_DIR)/boot/zImage $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel_auto.bin
	cd $(RELEASE_DIR); \
	tar -cvf $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar --exclude=zImage* --exclude=vmlinuz-initrd* . > /dev/null 2>&1; \
	bzip2 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar
	echo This file forces the update. > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/force.update
	echo This file forces creating partitions. > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/mkpart.update
	echo $(BOXTYPE)_DDT_online_$(shell date '+%d%m%Y-%H%M%S') > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/imageversion
	cd $(IMAGE_BUILD_DIR)/$(VU_PREFIX) && \
	tar -cvzf $(FLASH_DIR)/$(BOXTYPE)/$(BOXTYPE)_online_$(shell date '+%d.%m.%Y-%H.%M').tgz rootfs.tar.bz2 initrd_auto.bin kernel_auto.bin *.update imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)
endif


