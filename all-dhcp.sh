#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")"

VERSIONS="4.4.2"
CROSS_TARGETS="buildroot-2019.08-x86_64 buildroot-2019.08-i686 buildroot-2019.08-arm $EPICS_HOST_ARCH"

for ver in $VERSIONS; do
	./build-alglib.sh $ver $EPICS_HOST_ARCH
	for target in $CROSS_TARGETS; do
		./build-alglib.sh $ver $target
	done
done

