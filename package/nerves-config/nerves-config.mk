#############################################################
#
# nerves-config
#
#############################################################

# Remember to bump the version when anything changes in this directory.
NERVES_CONFIG_SOURCE =
NERVES_CONFIG_VERSION = 0.5

NERVES_CONFIG_DEPENDENCIES = host-fwup openssl

NERVES_CONFIG_PACKAGE_DIR = $(BR2_EXTERNAL_NERVES_PATH)/package/nerves-config

NERVES_CONFIG_EXTRA_APPS += stdlib
NERVES_CONFIG_ALL_APPS = $(subst $(space),$(comma),$(call qstrip,$(BR2_PACKAGE_NERVES_CONFIG_APPS) $(NERVES_CONFIG_EXTRA_APPS)))

# This is tricky. We want the squashfs created by Buildroot to have everything
# except for the OTP release. The squashfs tools can only append to filesystems,
# so we'll want to append OTP releases frequently. If it were possible to modify
# a squashfs after the fact, then we could skip this part, but this isn't
# possible on non-Linux platforms (i.e. no fakeroot).
ROOTFS_SQUASHFS_ARGS += -e srv

$(eval $(generic-package))
