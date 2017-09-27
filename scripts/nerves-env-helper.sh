#!/bin/bash

# Helper script to setup the Nerves environment. This shouldn't be called
# directly. See $NERVES_SYSTEM/nerves-env.sh.

# NERVES_SYSTEM is the new name for NERVES_ROOT. Define both in this period
# of transition.
NERVES_SYSTEM=$1
NERVES_ROOT=$1

pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1:$PATH"
    fi
}

ldlibrarypathadd() {
    if [ -d "$1" ] && [[ ":$LD_LIBRARY_PATH:" != *":$1:"* ]]; then
        LD_LIBRARY_PATH="$1:$LD_LIBRARY_PATH"
    fi
}

if [ -e $NERVES_SYSTEM/host ]; then
    # This is a Linux Buildroot build, so use tools as
    # provided by Buildroot
    NERVES_TOOLCHAIN=$NERVES_SYSTEM/host
    ALL_CROSSCOMPILE=`ls $NERVES_TOOLCHAIN/usr/bin/*gcc | sed -e s/-gcc//`

    # For Buildroot builds, use the Buildroot provided versions of pkg-config
    # and perl.
    export PKG_CONFIG=$NERVES_TOOLCHAIN/usr/bin/pkg-config
    export PKG_CONFIG_SYSROOT_DIR=/
    export PKG_CONFIG_LIBDIR=$NERVES_TOOLCHAIN/usr/lib/pkgconfig
    export PERLLIB=$NERVES_TOOLCHAIN/usr/lib/perl

    pathadd $NERVES_TOOLCHAIN/usr/bin
    pathadd $NERVES_TOOLCHAIN/usr/sbin
    pathadd $NERVES_TOOLCHAIN/bin
    ldlibrarypathadd $NERVES_TOOLCHAIN/usr/lib
else
    # The user is using a prebuilt toolchain and system. Usually NERVES_TOOLCHAIN will be defined,
    # but guess it just in case it isn't.
    if [ -z $NERVES_TOOLCHAIN ]; then
        NERVES_TOOLCHAIN=$NERVES_SYSTEM/../nerves-toolchain
    fi
    ALL_CROSSCOMPILE=`ls $NERVES_TOOLCHAIN/bin/*gcc | sed -e s/-gcc//`

    pathadd $NERVES_TOOLCHAIN/bin
fi

# Verify that a crosscompiler was found.
if [ "$ALL_CROSSCOMPILE" = "" ]; then
    echo "ERROR: Can't find cross-compiler."
    echo "    Is this the path to the toolchain? $NERVES_TOOLCHAIN"
    echo
    echo "    You may also set the NERVES_TOOLCHAIN environment variable before"
    echo "    calling this script. Be sure that \$NERVES_TOOLCHAIN/bin/ contains"
    echo "    the right cross-compiler, though."
    return 1
fi

NERVES_SDK_IMAGES=$NERVES_SYSTEM/images
NERVES_SDK_SYSROOT=$NERVES_SYSTEM/staging

# Check that the base buildroot image has been built
if [ ! -d "$NERVES_SDK_IMAGES" ]; then
    echo "ERROR: It looks like the system hasn't been built!"
    echo "    Expected to find the $NERVES_SDK_IMAGES directory, but didn't."
    return 1
fi

# Past the checks, so export variables
export NERVES_SYSTEM
export NERVES_ROOT
export NERVES_TOOLCHAIN
export NERVES_SDK_IMAGES
export NERVES_SDK_SYSROOT

# Rebar environment variables
#PLATFORM_DIR=$NERVES_ROOT/sdk/$NERVES_PLATFORM # Update when this is determined

# We usually just have one crosscompiler, but the buildroot toolchain symlinks
# to the crosscompiler, so two entries show up. The logic below picks the first
# crosscompiler by default or the one with buildroot in its name.
CROSSCOMPILE=`echo $ALL_CROSSCOMPILE | head -n 1`
for i in $ALL_CROSSCOMPILE; do
    case `basename $i` in
        *buildroot* )
            CROSSCOMPILE=$i
            ;;
        * )
            ;;
    esac
done

# Export environment variables used by Elixir, Erlang, C/C++ and other tools
# so that they use Nerves toolchain parameters and not the host's.
#
# This list is built up partially by adding environment variables from project
# as issues are identified since there's not a fixed convention for how these
# are used. The Rebar project source code for compiling C ports was very helpful
# initially.
export CROSSCOMPILE
export CC=$CROSSCOMPILE-gcc
export CXX=$CROSSCOMPILE-g++
export CFLAGS="-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -pipe -Os -I$NERVES_SDK_SYSROOT/usr/include"
export CXXFLAGS="-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -pipe -Os -I$NERVES_SDK_SYSROOT/usr/include"
export LDFLAGS="--sysroot=$NERVES_SDK_SYSROOT"
export STRIP=$CROSSCOMPILE-strip

return 0
