#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")"

VERSIONS="1.64.0"
# TODO
CROSS_TARGETS=

for ver in $VERSIONS; do
	./build-boost.sh $ver $EPICS_HOST_ARCH
	for target in $CROSS_TARGETS; do
		./build-boost.sh $ver $target
	done
done

