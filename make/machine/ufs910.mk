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
KERNEL_PATCHES_24  = $(UFS910_PATCHES_24)

#
# driver
#
DRIVER_PLATFORM   += UFS910=ufs910

#
# release
#


#
# flashimage
#


