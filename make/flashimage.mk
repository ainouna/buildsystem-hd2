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


