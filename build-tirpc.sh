#!/usr/bin/env bash
# vim: ts=4 sw=4 et
set -e
VER="$1"
ARCH="$2"

TOP="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

function usage {
    echo "USAGE: $0 <version> <arch>"
    echo "Ex:"
    echo " $0 1.3.5 rhel9-x86_64"
    exit 1
}

if [ -z "$VER" ]; then
    usage
fi
if [ -z "$ARCH" ]; then
    usage
fi

mkdir -p $EPICS_PACKAGE_TOP/tirpc/$VER
cd $EPICS_PACKAGE_TOP/tirpc/$VER

# Download and extract if not already
if [ ! -d src ]; then
    wget https://downloads.sourceforge.net/libtirpc/libtirpc-$VER.tar.bz2
    tar -xf libtirpc-$VER.tar.bz2
    mv libtirpc-$VER src
fi

mkdir -p build/$ARCH
cd build/$ARCH

if [ -f "$TOP/toolchains/$ARCH.bash" ]; then
    source "$TOP/toolchains/$ARCH.bash"
fi

export CFLAGS=-fPIC
if [ ! -z "$TARGET_SYSTEM" ]; then
    ../../src/configure --prefix="$PWD/../../$ARCH" --disable-gssapi --host=$TARGET_SYSTEM
else
    ../../src/configure --prefix="$PWD/../../$ARCH" --disable-gssapi 
fi

make install -j$(nproc)

