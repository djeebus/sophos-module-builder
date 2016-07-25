#!/usr/bin/env bash
set -x
set -e
shopt -s nullglob

source vars.sh

# prep work
if mount | grep ${GPL_MOUNT} > /dev/null; then
    sudo umount ${GPL_MOUNT}
fi

if mount | grep ${APP_MOUNT} > /dev/null; then
    sudo umount ${APP_MOUNT}
fi

hash rpm2cpio 2>/dev/null || {
    echo "Please run 'sudo apt install rpm2cpio'"
    exit 1
}

# download isos
if [ ! -f ${GPL_FILE} ]; then
    wget -nc $GPL_URL
fi

if [ ! -f ${APP_FILE} ]; then
    wget -nc $APP_URL
fi

# make mount points
if [ ! -d ${GPL_MOUNT} ]; then
    mkdir ${GPL_MOUNT}
fi

if [ ! -d ${APP_MOUNT} ]; then
    mkdir ${APP_MOUNT}
fi

# mount paths
sudo mount -o loop,ro ${GPL_FILE} ${GPL_MOUNT}
sudo mount -o loop,ro ${APP_FILE} ${APP_MOUNT}


# create working paths
rm -r ${WORK}
mkdir ${WORK} -p
mkdir ${WORK_SRC} -p

# extract packages
pushd ${WORK_SRC}
rpm2cpio ${GPL_MOUNT}/kernel-source-${LINUX_VERSION}-*.src.rpm | cpio -idmv
tar xvf linux-${LINUX_VERSION}.tar.xz
tar xvf kernel-source.git.tar.gz
rpm2cpio ${APP_MOUNT}/install/rpm/kernel-smp64-${LINUX_VERSION}-*.rpm | cpio -idmv

# patch system
pushd ${WORK_SRC}/linux-${LINUX_VERSION}
while read p ; do
    if ! patch -s -E -p1 --no-backup-if-mismatch -i ${WORK_SRC}/kernel-source/$p; then
		echo "*** Patch $p failed ***"
		exit 1
    fi
done < ${WORK_SRC}/kernel-source/series
popd

# copy config
cp ${WORK_SRC}/kernel-source/config/x86_64/smp64 ${WORK_SRC}/linux-${LINUX_VERSION}/.config
cp ${WORK_SRC}/usr/src/linux-${LINUX_VERSION}-*-obj/x86_64/smp64/Module.symvers ${WORK_SRC}/linux-${LINUX_VERSION}/
