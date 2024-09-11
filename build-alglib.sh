#!/usr/bin/env bash
# vim: ts=4 sw=4 et
set -e
VER="$1"
ARCH="$2"

TOP="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

function usage {
    echo "USAGE: $0 <version> <arch>"
    echo "Ex:"
    echo " $0 3.14.0 rhel9-x86_64"
    exit 1
}

if [ -z "$VER" ]; then
    usage
fi
if [ -z "$ARCH" ]; then
    usage
fi

mkdir -p $EPICS_PACKAGE_TOP/alglib/$VER
cd $EPICS_PACKAGE_TOP/alglib/$VER

# Clone alglib-gnubld if not already
if [ ! -d alglib-gnubld ]; then
    git clone git@github.com:slac-epics/alglib-gnubld.git --recursive
    cd alglib-gnubld
    autoreconf -i
    cd ..
fi

# Grab tarball
if [ ! -f "alglib-$VER.cpp.gpl.tgz" ]; then
    wget "https://www.alglib.net/translator/re/alglib-$VER.cpp.gpl.tgz"
    tar -xf "alglib-$VER.cpp.gpl.tgz"
    ln -s ./cpp/src ./src
fi

mkdir -p "build/$ARCH"
cd "build/$ARCH"

if [[ $ARCH = *"rtems"* ]]; then
    echo "Building for RTEMS"
    . $EPICS_PACKAGE_TOP/build-scripts/toolchains/$ARCH.bash
    ../../alglib-gnubld/configure --prefix="$PWD/../../$ARCH" --enable-rtemsbsp="${RTEMS_BSPS}" --exec-prefix="${EPICS_PACKAGE_TOP}/alglib/$VER/RTEMS-\${rtems_bsp}" --with-rtems-top="${RTEMS_TOP}"
else
    ../../alglib-gnubld/configure --prefix="$PWD/../../$ARCH"
fi

make -j$(nproc) install

