#!/bin/bash

set -e

#
# Post create filesystem hook
#
# Inputs:
#   $1  the images directory (where to put the .fw output)
#   $2  the path to fwup.conf
#   $3  the base name for the firmware
# $BR2_EXTERNAL_NERVES_PATH the path to the nerves_system_br directory
# $BASE_DIR     the path to the buildroot output directory
# $TARGET_DIR   the path to the target directory (normally $BASE_DIR/target)
# $BINARIES_DIR the path to the images directory (normally $BASE_DIR/images)


if [ $# -lt 2 ]; then
    echo "Usage: $0 <BR images directory> <Path to fwup.conf> [Base firmware name]"
    exit 1
fi

FWUP_CONFIG=$2
BASE_FW_NAME=$3

[ ! -f $FWUP_CONFIG ] && { echo "Error: $FWUP_CONFIG not found"; exit 1; }

if [ -z $BASE_FW_NAME ]; then
    # Read the system name from the .config, trim off the
    # the BR2_NERVES_SYSTEM_NAME= part, and dequote.
    BR2_NERVES_SYSTEM_NAME=$(grep BR2_NERVES_SYSTEM_NAME $BASE_DIR/.config)
    BASE_FW_NAME=${BR2_NERVES_SYSTEM_NAME#BR2_NERVES_SYSTEM_NAME=\"}
    BASE_FW_NAME=${BASE_FW_NAME%\"}
fi

# Copy the fwup config to the images directory so that
# it can be used to create images based on this one.
cp -f $FWUP_CONFIG $BINARIES_DIR

# Symlink the nerves scripts to the output directory so that it
# is self-contained.
cp -f $BR2_EXTERNAL_NERVES_PATH/nerves-env.sh $BASE_DIR    # Can't symlink due to readlink -f code
ln -sf $BR2_EXTERNAL_NERVES_PATH/nerves.mk $BASE_DIR
ln -sf $BR2_EXTERNAL_NERVES_PATH/scripts $BASE_DIR

# Use the rel2fw.sh tool to create the demo images
OLD_DIR=$(pwd)
(cd $BINARIES_DIR && \
 source $BASE_DIR/scripts/nerves-env-helper.sh $BASE_DIR && \
 $BASE_DIR/scripts/rel2fw.sh -f ${BASE_FW_NAME}.fw -o ${BASE_FW_NAME}.img $TARGET_DIR/srv/erlang) \
 || (cd $OLD_DIR; echo rel2fw.sh failed; exit 1)

