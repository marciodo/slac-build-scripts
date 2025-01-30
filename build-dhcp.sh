#!/usr/bin/env bash
# vim: ts=4 sw=4 et
set -e
VER="$1"
ARCH="$2"

TOP="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

function usage {
    echo "USAGE: $0 <version> <arch>"
    echo "Ex:"
    echo " $0 4.4.2 rhel9-x86_64"
    exit 1
}

if [ -z "$VER" ]; then
    usage
fi
if [ -z "$ARCH" ]; then
    usage
fi

mkdir -p $EPICS_PACKAGE_TOP/dhcp/$VER
cd $EPICS_PACKAGE_TOP/dhcp/$VER

mkdir -p "build/$ARCH"
cd "build/$ARCH"

if [[ $ARCH = *"buildroot"* ]]; then
    echo "Building for buildroot"
    . $EPICS_PACKAGE_TOP/build-scripts/toolchains/$ARCH.bash
    export PATH="${TOOLCHAIN_PATH}/bin:$PATH"
    ../../dhcp-$VER/configure --prefix="$PWD/../../$ARCH" --host $TARGET_SYSTEM --with-randomdev=no
else
    ../../dhcp-$VER/configure --prefix="$PWD/../../$ARCH" --with-randomdev=no
fi

make && make install

