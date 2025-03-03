#!/usr/bin/env bash
# vim: ts=4 sw=4 et
set -e
VER="$1"
ARCH="$2"

TOP="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

function usage {
    echo "USAGE: $0 <version> <arch>"
    echo "Ex:"
    echo " $0 2.3.1 rhel9-x86_64"
    exit 1
}

if [ -z "$VER" ]; then
    usage
fi
if [ -z "$ARCH" ]; then
    usage
fi

mkdir -p $EPICS_PACKAGE_TOP/cexp/$VER
cd $EPICS_PACKAGE_TOP/cexp/$VER

mkdir -p "build/$ARCH"
cd "build/$ARCH"

# Generate configure if it doesnt exist
if [ ! -f ../../src/configure ]; then
    pushd ../../src
    autoreconf -ifv
    popd
fi

if [[ $ARCH = *"rtems"* ]]; then
    echo "Building for RTEMS"
    . $EPICS_PACKAGE_TOP/build-scripts/toolchains/$ARCH.bash
    ../../src/configure --prefix="$PWD/../../$ARCH" --enable-rtemsbsp="${RTEMS_BSPS}" --exec-prefix="${EPICS_PACKAGE_TOP}/alglib/$VER/RTEMS-\${rtems_bsp}" --with-rtems-top="${RTEMS_TOP}"
elif [[ $ARCH = *"buildroot"* ]]; then
    echo "Building for buildroot"
    . $EPICS_PACKAGE_TOP/build-scripts/toolchains/$ARCH.bash
    export PATH="${TOOLCHAIN_PATH}/bin:$PATH"
    ../../src/configure --prefix="$PWD/../../$ARCH" --host $TARGET_SYSTEM
else
    ../../src/configure --prefix="$PWD/../../$ARCH"
fi

# Hack to work around dependency issue with jumptab.c...
make || make jumptab.c
make install

