#
# Include this Makefile in your project to pull in the Nerves versions
# of all of the build tools.
#
# NOTE: If you source nerves-env.sh, then including this script is not
# necessary. Basically, the rule is to do one or the other. Sourcing
# nerves-env.sh has the advantage that the environment is set properly
# on the commandline should you need to run commands manually.
#
NERVES_VERSION:=$(strip $(shell cat VERSION))

NERVES_SYSTEM:=$(abspath $(dir $(lastword $(MAKEFILE_LIST))))
NERVES_TOOLCHAIN=$(NERVES_SYSTEM)/host
NERVES_SDK_IMAGES=$(NERVES_SYSTEM)/images
NERVES_SDK_SYSROOT=$(NERVES_SYSTEM)/staging

# Keep NERVES_ROOT defined for the transition period
NERVES_ROOT=$(NERVES_SYSTEM)

# Check that the base buildroot image has been built
#ifeq ("$(wildcard $(NERVES_SDK_IMAGES)/rootfs.tar)","")
#	$(error Remember to build nerves)
#endif

CROSSCOMPILE=$(subst -gcc,,$(firstword $(wildcard $(NERVES_TOOLCHAIN)/usr/bin/*gcc)))

CC=$(CROSSCOMPILE)-gcc
CXX=$(CROSSCOMPILE)-g++
CFLAGS="-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -pipe -Os"
CXXFLAGS="-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -pipe -Os"
LDFLAGS=""
STRIP=$(CROSSCOMPILE)-strip

PKG_CONFIG=$(NERVES_TOOLCHAIN)/usr/bin/pkg-config
PKG_CONFIG_SYSROOT_DIR=/
PKG_CONFIG_LIBDIR=$(NERVES_TOOLCHAIN)/usr/lib/pkgconfig
PERLLIB=$(NERVES_TOOLCHAIN)/usr/lib/perl

# Paths to utilities
NERVES_PATH="$(NERVES_TOOLCHAIN)/bin:$(NERVES_TOOLCHAIN)/sbin:$(NERVES_TOOLCHAIN)/usr/bin:$(NERVES_TOOLCHAIN)/usr/sbin:$(PATH)"
NERVES_LD_LIBRARY_PATH="$(NERVES_TOOLCHAIN)/usr/lib:$(LD_LIBRARY_PATH)"

# Combined environment
NERVES_HOST_MAKE_ENV=PATH=$(NERVES_PATH) \
		     LD_LIBRARY_PATH=$(NERVES_LD_LIBRARY_PATH) \
		     PKG_CONFIG=$(PKG_CONFIG) \
		     PKG_CONFIG_SYSROOT_DIR=$(PKG_CONFIG_SYSROOT_DIR) \
		     PKG_CONFIG_LIBDIR=$(PKG_CONFIG_LIBDIR) \
		     NERVES_SYSTEM=$(NERVES_SYSTEM) \
		     NERVES_ROOT=$(NERVES_SYSTEM) \
		     NERVES_TOOLCHAIN=$(NERVES_TOOLCHAIN) \
		     NERVES_SDK_IMAGES=$(NERVES_SDK_IMAGES) \
		     NERVES_SDK_SYSROOT=$(NERVES_SDK_SYSROOT) \
		     CROSSCOMPILE=$(CROSSCOMPILE)

NERVES_ALL_VARS=CC=$(CC) \
		CXX=$(CXX) \
		CFLAGS=$(CFLAGS) \
		CXXFLAGS=$(CXXFLAGS) \
		LDFLAGS=$(LDFLAGS) \
