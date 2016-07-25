#!/usr/bin/env bash

KEY=EnterRealKeyHere
VERSION=9.404-5.1
LINUX_VERSION=3.12.48

GPL_FILE=gpl-asg-${VERSION}.iso
GPL_URL=http://downloads.sophos.com/inst_utm/${KEY}/GPL_source_code/${GPL_FILE}
GPL_MOUNT=`realpath ./gpl-iso`

APP_FILE=asg-${VERSION}.iso
APP_URL=http://downloads.sophos.com/inst_utm/${KEY}/v9/software_appliance/iso/${APP_FILE}
APP_MOUNT=`realpath ./app-iso`

WORK=`realpath ./work`
WORK_SRC=`realpath ${WORK}/src`
