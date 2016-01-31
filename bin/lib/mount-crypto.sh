#!/usr/bin/env bash

set -e

UUID=30e17b83-aaa2-4164-9248-00610b01ffed
MOUNTPOINT=/media/crypto
MAPPER_NAME=luks

if [[ $1 == close ]]; then
    umount $MOUNTPOINT
    cryptsetup close $MAPPER_NAME
    rmdir $MOUNTPOINT
    exit
fi

mkdir -p $MOUNTPOINT
cryptsetup luksOpen /dev/disk/by-uuid/$UUID $MAPPER_NAME
mount /dev/mapper/$MAPPER_NAME $MOUNTPOINT
cd $MOUNTPOINT
