#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")"

VERSIONS="1.3.5"
CROSS_TARGETS=""

for ver in $VERSIONS; do
	./build-tirpc.sh $ver $EPICS_HOST_ARCH
	for target in $CROSS_TARGETS; do
		./build-tirpc.sh $ver $target
	done
done

