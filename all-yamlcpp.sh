#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")"

VERSIONS="yaml-cpp-0.5.3_boost-1.64.0"
# TODO
CROSS_TARGETS=

for ver in $VERSIONS; do
	./build-yamlcpp.sh $ver $EPICS_HOST_ARCH
	for target in $CROSS_TARGETS; do
		./build-yamlcpp.sh $ver $target
	done
done

