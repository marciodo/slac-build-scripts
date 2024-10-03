#!/usr/bin/env bash

set -e

VER=$1
ARCH=$2

function usage {
    echo "USAGE: build-cmake.sh 3.30.0 rhel9-x86_64"
    exit 1
}

if [ -z "$ARCH" ]; then
    usage
fi
if [ -z "$VER" ]; then
    usage
fi

mkdir -p $EPICS_PACKAGE_TOP/cmake/$VER
pushd $EPICS_PACKAGE_TOP/cmake/$VER

if [ ! -d src ]; then
    git clone git@github.com:Kitware/CMake.git src
fi

cd src
git checkout v$VER
cd ..

if [[ $ARCH =~ *"buildroot"* ]]; then
    if [ ! -L $ARCH ]; then
        ln -sv rhel7-x86_64 $ARCH
    fi
    exit 0
fi

mkdir -p build/$ARCH
cd build/$ARCH
pwd
../../src/configure --prefix="$EPICS_PACKAGE_TOP/cmake/$VER/$ARCH" --no-qt-gui

make -j12 && make install

