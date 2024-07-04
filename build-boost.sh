#!/usr/bin/env bash
# vim: ts=4 sw=4 et
set -e
VER="$1"
ARCH="$2"

TOP="$(dirname "${BASH_SOURCE[0]}")"

function usage {
    echo "USAGE: $0 <version> <arch>"
    echo "Ex:"
    echo " $0 1.64.0 rhel9-x86_64"
    exit 1
}

if [ -z "$VER" ]; then
    usage
fi
if [ -z "$ARCH" ]; then
    usage
fi

D=boost_$(echo $VER | sed 's/\./_/g')

mkdir -p $EPICS_PACKAGE_TOP/boost/$VER/build/$ARCH
cd $EPICS_PACKAGE_TOP/boost/$VER/src/$D

if [ ! -f "../boost-build/bin/b2" ]; then
    cd tools/build

    ./bootstrap.sh
    ./b2 --prefix="$PWD/../boost-build"
fi

cp -fv "$TOP/boost-jamfiles/"* .

../boost-build/bin/b2 --build-dir="$EPICS_PACKAGE_TOP/boost/$VER/build/$ARCH" --prefix="$EPICS_PACKAGE_TOP/boost/$VER/$ARCH" install
