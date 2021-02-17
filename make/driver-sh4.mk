#
# driver-clean
#
driver-clean:
	$(MAKE) -C $(DRIVER_DIR) ARCH=sh KERNEL_LOCATION=$(KERNEL_DIR) distclean
	rm -f $(D)/driver




