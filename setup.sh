#! /bin/bash
#
# History:
#   14 Jan 2017  Andy Frank  Creation
#
# Studs system setup script.
#
# Based on Nerves create-build.sh:
# https://github.com/nerves-project/nerves_system_br
#

BR_VER="2017.08"

# Print message and exit with error code
fatal() { echo "ERR: $1"; exit 1; }

# Sanity check running on valid host
HOST_OS=$(uname -s)
HOST_ARCH=$(uname -m)
[[ $HOST_OS   != "Linux"  ]] && fatal "Linux required"
[[ $HOST_ARCH != "x86_64" ]] && fatal "64-bit Linux required"

# "readlink -f" implementation for BSD
# This code was extracted from the Elixir shell scripts
readlink_f () {
  cd "$(dirname "$1")" > /dev/null
  filename="$(basename "$1")"
  if [[ -h "$filename" ]]; then
    readlink_f "$(readlink "$filename")"
  else
    echo "`pwd -P`/$filename"
  fi
}

# Validate system name supplied
SYSTEM_NAME=$1
if [[ -z $SYSTEM_NAME ]]; then
  echo "usage: $0 <system name>"
  exit 1
fi

# Determine base system path
STUDS_SYSTEM=$(dirname $(readlink_f "${BASH_SOURCE[0]}"))
[[ ! -e $STUDS_SYSTEM ]] && fatal "Failed to determine script directory!"

# Determine and validate defconfig paths
STUDS_DEFCONFIG=$(readlink_f "$STUDS_SYSTEM/../system-${SYSTEM_NAME}/nerves_defconfig")
STUDS_DEFCONFIG_DIR=$(dirname $STUDS_DEFCONFIG)
[[ ! -f $STUDS_DEFCONFIG ]] && fatal "'$STUDS_DEFCONFIG' not found"

# Default output build directory
BUILD_DIR=$STUDS_SYSTEM/../output-$SYSTEM_NAME
STUDS_BUILD_DIR=$(readlink_f $BUILD_DIR)

# Default Buildroot parent directory
STUDS_BR_BASE_DIR="$(dirname "$STUDS_SYSTEM")"

# If running under Vagrant we need to create the output outside of our
# shared folders so that Buildroot can properly create hard links
if [ -e /home/vagrant ]; then
  STUDS_BUILD_DIR=/home/vagrant/output-$SYSTEM_NAME
  STUDS_BR_BASE_DIR=/home/vagrant/
fi

# Make sure build dir exists
mkdir -p $STUDS_BUILD_DIR

# Clean up any old versions of Buildroot
rm -rf $STUDS_BR_BASE_DIR/buildroot*
# rm -rf $STUDS_BUILD_DIR  <--- ?

# Download and extract Buildroot
set -e
cd $STUDS_BR_BASE_DIR
echo "Downloading..."
wget -q --show-progress http://buildroot.uclibc.org/downloads/buildroot-$BR_VER.tar.bz2
echo "Extracting..."
tar xf buildroot-*.tar*
rm buildroot-*.tar*
mv buildroot-* buildroot

# Apply Studs-specific patches
echo "Patching..."
$STUDS_BR_BASE_DIR/buildroot/support/scripts/apply-patches.sh \
 $STUDS_BR_BASE_DIR/buildroot $STUDS_SYSTEM/patches

# Configure build directory
cd $STUDS_SYSTEM
make -C $STUDS_BR_BASE_DIR/buildroot BR2_EXTERNAL=$STUDS_SYSTEM O=$STUDS_BUILD_DIR \
    NERVES_DEFCONFIG_DIR=$STUDS_DEFCONFIG_DIR \
    BR2_DEFCONFIG=$STUDS_DEFCONFIG \
    DEFCONFIG=$STUDS_DEFCONFIG \
    defconfig

echo "*** READY ***"
exit 0