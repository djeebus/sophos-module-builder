#!/usr/bin/env bash
set -x

source vars.sh

pushd ${WORK_SRC}/linux-${LINUX_VERSION}
make modules_prepare
popd

pushd ~/code/other/e1000e-3.3.4/src/
make KSRC=${WORK_SRC}/linux-${LINUX_VERSION}
