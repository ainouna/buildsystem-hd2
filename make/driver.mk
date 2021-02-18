#
# driver-clean
#
driver-clean:
ifeq ($(BOXARCH), sh4)
	$(MAKE) -C $(DRIVER_DIR) ARCH=sh KERNEL_LOCATION=$(KERNEL_DIR) distclean
else
	$(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra/*
endif
	rm -f $(D)/driver


