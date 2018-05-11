#!/bin/sh

set -e

#
# Nerves common post-build hook
#

# Create /tmp/ symlinks; we do this here vs board/nerves-common/skeleton
# to make Vagrant happy when used on macOS
cd $TARGET_DIR/dev && ln -s ../tmp/log log
cd $TARGET_DIR/etc && ln -s ../tmp/resolv.conf resolv.conf

# scrub-targets
$BR2_EXTERNAL_NERVES_PATH/scripts/scrub-target.sh $1
