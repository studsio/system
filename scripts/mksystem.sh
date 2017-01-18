#!/bin/bash

#
# This script creates a tarball with everything needed to build
# an application image on another system. It is useful to allow
# the parts that require Linux to be built separately from the
# parts that can be built on any system.
# It is intended to be called from Buildroot's Makefiles so that
# the environment is set up properly.
#
# Inputs:
#   $1 = the archive name (if not passed, we'll make up a name)
#   BASE_DIR = the build directory (aka, the future $NERVES_SYSTEM directory)
#   PWD = the buildroot directory
#
# Outputs:
#   Archive tarball
#

set -e

# Print message and exit with error code
fatal() { echo "ERR: $1"; exit 1; }

SYSTEM_NAME=$1
BR2_EXTERNAL=$2

# Sanity checks
[ -z $SYSTEM_NAME ] && fatal "Please specify an system name"
[ -z $BASE_DIR    ] && fatal "BASE_DIR undefined? Script should be called from Buildroot"

# Prepare working dir
SHORT_NAME=$(echo "$SYSTEM_NAME" | cut -d '-' -f 3)
WORK_DIR=$BASE_DIR/tmp-system
rm -fr $WORK_DIR
mkdir -p $WORK_DIR/$SHORT_NAME

# Read version
VERSION=$(cat $BR2_EXTERNAL-$SHORT_NAME/VERSION)

# Write out system.props (TODO on JRE...)
echo "name=$SHORT_NAME
version=$VERSION
jre=linux-armv6-vfp-hflt" > $WORK_DIR/$SHORT_NAME/system.props

# Copy common nerves shell scripts over
#cp $BR2_EXTERNAL/nerves-env.sh $WORK_DIR/$SHORT_NAME
#cp $BR2_EXTERNAL/nerves.mk $WORK_DIR/$SHORT_NAME
cp -R $BR2_EXTERNAL/scripts $WORK_DIR/$SHORT_NAME

# Copy the built configuration over
#cp $BASE_DIR/.config $WORK_DIR/$SHORT_NAME

# Copy the staging and images directories over
mkdir -p $WORK_DIR/$SHORT_NAME/images $WORK_DIR/$SHORT_NAME/staging
cp -R $BASE_DIR/images/* $WORK_DIR/$SHORT_NAME/images
#cp -R $BASE_DIR/staging/* $WORK_DIR/$SHORT_NAME/staging

# Clean up extra files that were copied over and aren't needed
rm -f $WORK_DIR/$SHORT_NAME/images/*.fw
rm -f $WORK_DIR/$SHORT_NAME/images/$SYSTEM_NAME.img

# Tar up archive
ARCHIVE=${SYSTEM_NAME}-${VERSION}.tar.gz
tar czf $BASE_DIR/$ARCHIVE -C $WORK_DIR $SHORT_NAME

# Move to system-xxx/releases
REL_DIR=$BR2_EXTERNAL-$SHORT_NAME/releases
mkdir -p $REL_DIR
mv $BASE_DIR/$ARCHIVE $REL_DIR/

rm -fr $WORK_DIR
