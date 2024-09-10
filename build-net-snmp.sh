#!/usr/bin/env bash
# vim: ts=4 sw=4 et
set -e
VER="$1"
ARCH="$2"

TOP="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

function usage {
    echo "USAGE: $0 <version> <arch>"
    echo "Ex:"
    echo " $0 5.7.2 rhel9-x86_64"
    exit 1
}

if [ -z "$VER" ]; then
    usage
fi
if [ -z "$ARCH" ]; then
    usage
fi

mkdir -p $EPICS_PACKAGE_TOP/net-snmp/$VER
cd $EPICS_PACKAGE_TOP/net-snmp/$VER

# Check if tarball exists
if [ ! -f net-snmp-$VER.tar.gz ]; then
    wget "https://sourceforge.net/projects/net-snmp/files/net-snmp/$VER/net-snmp-$VER.tar.gz/download" -O net-snmp-$VER.tar.gz
fi

# Check if source dir exists
if [ ! -d net-snmp-$VER ]; then
    echo "Extracting tarball..."
    tar -xf "net-snmp-$VER.tar.gz"
fi

mkdir -p build/$ARCH
cd build/$ARCH

../../net-snmp-$VER/configure --prefix="$PWD/../../$ARCH" --with-default-snmp-version=3 --without-perl-modules --disable-embedded-perl --with-logfile=/var/log/snmpd.log --with-persistent-directory=/var/net-snmp --with-sys-location=SLAC --with-sys-contact=lorelli

# Make all and install must be in separate steps because autotools sucks.
make 
make install
